'use strict';

//imports
var where = require("lodash.where");
var groupBy = require("lodash.groupby");
var url = require("url");
const express = require('express');
const { Client } = require('pg');

// setup
var connectionString = "postgres://user:example@192.168.0.15:5432/db"; //process.env.DATABASE_URL;
console.log('database url from env is: ', connectionString)
// set timezone
process.env.TZ = 'Europe/London';
const client = new Client({
	connectionString
});

client.connect(err => {
  if (err) {
    console.error('connection error', err.stack)
  } else {
    console.log('connected')
  }
})


function QueryResult(row) { 
var queryResult = {
	checksId: row.checksid,
	checksText: row.checkstext,
	checksSubText: row.checkssubtext,
	checksType: row.checkstype,
	checksRequired: row.checksrequired,
	imageLink: row.imagelink,
	segmentId: row.segmentid,
	segmentTitle: row.segmenttitle,
	countryId: row.countryid
};
return queryResult;
}

// Constants
const PORT = 4000;
const HOST = '0.0.0.0';
const selectQuery = `
select 
checks.*, segments.segmenttitle, countries.countryid
from segments 
	inner join inductioncheckspage induct
		on segments.checkspageid = induct.checkspageid
	inner join countries on induct.countryid = countries.countryid
inner join checks on segments.segmentid = checks.segmentid
`;
const whereCountry = `
where countries.countryId = 
`;

// App
const app = express();
app.use(express.json()) // for parsing application/json

// get checks for a particular country - checks pages are stored per country, in form
// checks?countryId = x
// checks?storeId = y
app.get('/checks', (req,res) => {
	//res.status(200).send("Response! Country ID: " + req.query.countryId);
	let countryId = req.query.countryId;
	let storeId = req.query.storeId;
	let query = "";
	if (countryId != null){
		query = selectQuery + whereCountry + req.query.countryId + ";";
	} else if (storeId != null){
		
	} else {
		query = selectQuery + ";";
	}
	client.query(query, 
		function(err, result){
			if (err) {
				console.log (err);
				res.status(400).send(err);
			} else {
				let returnedSegments = result.rows;
				let queryResultArray = [];
				// map into objects
				for (var position = 0; position < returnedSegments.length; position ++) {
					var segment = returnedSegments[position];
					queryResultArray.push(QueryResult(segment));
				}
				// get segments
				var groupBySegment = groupBy(queryResultArray, 'segmentId');
				var keys = Object.keys(groupBySegment);
				// get checks
				var groupByCheck = groupBy(queryResultArray, 'checksId');
				var groupBySegmentTitle = groupBy(queryResultArray, 'segmentTitle');
				// order and push into result object
				let resultObject = {};
				// all checks
				resultObject["allChecks"] = extractChecks(queryResultArray);
				// segments
				var segmentValues = [];
				var pos;
				//console.log("\n ordering by segments");
				//console.log("\n queryResultArray groupby segmenttitle:" + JSON.stringify(groupBySegmentTitle));
				var result = SegmentResultModel(groupBySegmentTitle);
				resultObject["segments"] = result;
					res.status(200).send(resultObject); 
			}
		});
});

// post a visit to a db
/**
visit body will be in form:
{
	"visitor":{
			"visitorName": "John Doe",
			"visitorCompany": "BP"
	},
	"siteId": 1,
	"checks": [
		{
			"checkId":1,
			"checkStatus": false
		},
		{
			"checkId":2,
			"checkStatus": true
		}
	]
}
The API call will create a visitor, a pass, a visit and associate the checks with the visit.
Response body will be in form:
{
  "visit": {
    "visitId": 1,
    "createdDateTime": "2020-05-30 00:00:00.000"
  }
}
**/
app.post('/visits', async (req, res) => {
	let requestBody = req.body;
	if (!requestBody.visitor) {
		res.status(400).send('Please include visitor details');
	}
	if (!requestBody.visitor.visitorName) {
		res.status(400).send('Please include visitor name');
	}
	if (!requestBody.visitor.visitorCompany) {
		res.status(400).send('Please include visitor details');
	}
	if (!requestBody.siteId) {
		res.status(400).send('Please include site ID');
	}
	if (!requestBody.checks) {
		res.status(400).send('Please include checks to update');
	}
	const siteId = requestBody.siteId;
	// check if company has been created
	const visitor = requestBody.visitor;
	var companiesQuery = `SELECT * FROM companies WHERE companyName = '${visitor.visitorCompany}';`;
	var companyId = 0;
	console.log("select query: " + companiesQuery);
	client.query(companiesQuery, async function(err,result){
		if (err) {
			console.log (err);
			res.status(500).send(err);
			exit;
		} else {
			let returnedRows = result.rows;
			if (returnedRows.length == 0) { // need to create company
				companiesQuery = `INSERT INTO companies (companyName, whenLoadedId) VALUES ('${visitor.visitorCompany}', 2) RETURNING companyid;`;
				console.log("insert query: " + companiesQuery);
				await client.query(companiesQuery, async function(err, result){
					if (err) {
						console.log (err);
						res.status(500).send(err);
						} else {
							console.log(result);
							console.log("Company successfully added. Company id: " + result.rows[0].companyid);
							companyId = result.rows[0].companyid;
						}
				});
			} 
			else {
				// need to get company Id
				console.log("company id: " + returnedRows[0].companyid);
				companyId = returnedRows[0].companyid;
				if (companyId == 0) {
					console.log("error in obtaining company id");
					res.status(500).send("error in obtaining company id");
				}				
			}
			// company created
			// create visitors
			const visitorsQuery = `INSERT INTO visitors (visitorName, companyId) VALUES('${visitor.visitorName}', ${companyId}) RETURNING visitorid;`;
			var visitorId = 0;
			console.log("visitor insert query: " + visitorsQuery);
			client.query(visitorsQuery, function(err, result) {
				if (err) {
					console.log ("in error handler within client query" + err);
					res.status(500).send(err);
				} else {
					console.log(result);
					console.log(result.rows);
					console.log(result.rows[0]);
					const checkVisitorId = result.rows[0].visitorid;
					console.log("Visitor successfully added. Visitor id: " + JSON.stringify(checkVisitorId));
					visitorId = checkVisitorId;
					
					// visitor created
					// create pass
					const passQuery = `INSERT INTO passes(visitorid) VALUES(${visitorId}) RETURNING passid;`;
					var passId = 0;
					console.log("passes insert query: " + passQuery);
					client.query(passQuery, function(err, result){
						if (err) {
							console.log (err);
							res.status(500).send(err);
						} else {
							console.log("Pass successfully added. Pass id: " + result.rows[0].passid);
							passId = result.rows[0].passid;
							// pass created
							// create visit
							const visitQuery = `INSERT INTO visits(visitorId, passId, siteId) VALUES (${visitorId}, ${passId}, ${siteId}) RETURNING visitid;`;
							var visitId = 0;
							console.log("visit insert query: " + visitQuery);
							client.query(visitQuery, function(err, result){
								if (err) {
									console.log (err);
									res.status(500).send(err);
								} else {
									console.log("Visit successfully added. Visit id: " + result.rows[0].visitid);
									visitId = result.rows[0].visitid;
									// associate checks with visit
									// build insert statement using loop
									var baseInsertQuery = `INSERT INTO signInChecks (visitId, checksId, status) VALUES `;
									console.log("all checks: " + JSON.stringify(requestBody.checks));
									console.log("all checks: " + JSON.stringify(requestBody.checks[0]));
									for (const signInCheckId in requestBody.checks) {
										var model = requestBody.checks[signInCheckId];
										console.log("check: " + JSON.stringify(model));
										baseInsertQuery = baseInsertQuery + `(${visitId}, ${model.checkId}, ${model.checkStatus}),`;
									}
									baseInsertQuery = baseInsertQuery.substring(0, baseInsertQuery.length - 1);
									baseInsertQuery = baseInsertQuery + ";";
									console.log(baseInsertQuery);
									client.query(baseInsertQuery, function(err, result) {
										if (err) {
											console.log (err);
											res.status(500).send(err);
										} else {
											const resultObject = {
												"visitId": visitId,
												"createdDateTime": new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '') + '.000'
											};
											res.status(200).send(resultObject);
										}
									});
								} 
							});
						}
					}
					);
				}
			});
		}
	});
});

function SegmentResultModel(row) {
	var segments = [];
	var keys = Object.keys(row); // General Checks / Specific Checks
	for (var pos = 0; pos < keys.length; pos++) {
		// get check ids
		var checkIds = [];
		let groupById = groupBy(row[keys[pos]], 'checksId');
		Object.keys(groupById).forEach(function(element){
			checkIds.push(Number(element));
		});

		// push to segments array
		segments.push( {
			"title": keys[pos],
			"checks": checkIds
		} );
	}
	return segments;
}

function CheckResultModel(row) { 
var queryResult = {
	checkId: row.checksId,
	text: row.checksText,
	subText: row.checksSubText,
	type: row.checksType,
	required: row.checksRequired,
	imageLink: row.imageLink
};
return queryResult;
}

function extractChecks(group) {
	var checks = [];
	var keys = Object.keys(group);
	var pos;
	for (pos = 0; pos < keys.length; pos++) {
		var keyValue = keys[pos];
		var checkObject = group[keyValue];
		checks.push(CheckResultModel(checkObject));
	}
	return checks;
}

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);