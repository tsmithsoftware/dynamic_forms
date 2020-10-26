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
	segmentId: row.segmentid,
	segmentTitle: row.segmenttitle,
	checksId: row.checksid,
	text: row.checkstext,
	subText: row.checkssubtext,
	type: row.checkstype,
	required: row.checksrequired,
	imageLink: row.imageLink
};
return queryResult;
}

// Constants
const PORT = 4000;
const HOST = '0.0.0.0';
const selectQuery = `
select 
	s.segmentid, 
	s.segmenttitle, 
	checks.checksid, 
	checks.checkstext,
	checks.checkssubtext,
	checks.checkstype,
	checks.checksrequired,
	checks.imagelink  
from 
	(segments s 
	 join segmentchecks sc 
	 on 
	 	(s.segmentid = sc.segmentid)
	) join checks 
	on sc.checksid = checks.checksid;
`;

// App
const app = express();
app.use(express.json()) // for parsing application/json

app.get('/checks/:checkId', (req,res) => {
	res.status(200).send("Response! CheckID:" + req.params["checkId"]);
});


app.get('/checks', (req, res) => {
	let resultObject = {};
				
	client.query(selectQuery + ";",
		function (err, result) {
			if (err) {
				console.log (err);
				res.status(400).send(err);
				} else {
					let resultObject = {};
					let returnedSegments = result.rows;
					let queryResultArray = [];
					for (var i = 0; i < returnedSegments.length; i++) {
						var ojb = returnedSegments[i];
						queryResultArray.push(QueryResult(ojb));
					}
					// get segments
					var groupBySegment = groupBy(queryResultArray, 'segmentId');
					var keys = Object.keys(groupBySegment);
					// get checks
					var groupByCheck = groupBy(queryResultArray, 'checksId')
					// order
					resultObject["allChecks"] = extractChecks(groupByCheck);
					
					var segmentValues = [];
					var pos;
					for (pos = 0; pos < keys.length; pos++) {
						var keyValue = keys[pos];
						var re = where(queryResultArray, {"segmentId": parseInt(keyValue)});
						segmentValues.push(re);
					}
					var segmentOne = where(queryResultArray, {"segmentId":1})
					res.status(200).send(segmentValues); 
				}
		} 
	);

}
);

function theCheckObject(row) { 
var queryResult = {
	checksId: row.checksid,
	text: row.checkstext,
	subText: row.checkssubtext,
	type: row.checkstype,
	required: row.checksrequired,
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
		console.log("checkObject :" + JSON.stringify(checkObject));
		checks.push(theCheckObject(checkObject));
	}
	return checks;
}

function replacer(key, value) {
  const originalObject = this[key];
  if(originalObject instanceof Map) {
    return {
      dataType: 'Map',
      value: Array.from(originalObject.entries()), // or with spread: value: [...originalObject]
    };
  } else {
    return value;
  }
}

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);