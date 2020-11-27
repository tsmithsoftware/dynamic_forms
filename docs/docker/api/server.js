'use strict';
var where = require("lodash.where");
var groupBy = require("lodash.groupBy");
var url = require("url");
const express = require('express');
const { Client } = require('pg')
var connectionString = 'postgres://user:example@192.168.56.1:5432/db'  //process.env.DATABASE_URL//
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