var fs = require('fs');
var https = require('https');
var bodyParser = require('body-parser');
var http = require('http');
const querystring = require('querystring');
var app = require('express')();
var options = {
   key  : fs.readFileSync('../server.key'),
   cert : fs.readFileSync('../server.crt')
};

app.use(function (req, res, next) {

	var origin = req.get('origin');
    // Website you wish to allow to connect
    //res.setHeader('Access-Control-Allow-Origin', 'https://www.safaribooksonline.com');
    res.setHeader('Access-Control-Allow-Origin', origin);

    // Request methods you wish to allow
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // Request headers you wish to allow
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type,Pragma,Cache-Control');

    // Set to true if you need the website to include cookies in the requests sent
    // to the API (e.g. in case you use sessions)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pass to next layer of middleware
    next();
});

app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

app.get('/', function (req, res) {
   res.send();
});

function forward_to_http (req, res) {
  post(req.path, req.body);
  res.send('ok');
}

app.post('/say', forward_to_http)
app.post('/pause', forward_to_http)
app.post('/stop', forward_to_http)
app.post('/resume', forward_to_http)
app.post('/toggle', forward_to_http)

https.createServer(options, app).listen(7733, function () {
   console.log('Started!');
});

function post(path, data){
	console.log(`Posting to ${path}`);
	var postData = querystring.stringify(data);

	var options = {
	  hostname: 'localhost',
	  port: 7732,
	  path: path,
	  method: 'POST',
	  headers: {
	    'Content-Type': 'application/x-www-form-urlencoded',
	    'Content-Length': Buffer.byteLength(postData)
	  }
	};

	var req = http.request(options, (res) => {
	  console.log(`STATUS: ${res.statusCode}`);
	  console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
	  res.setEncoding('utf8');
	  res.on('data', (chunk) => {
	    console.log(`BODY: ${chunk}`);
	  });
	  res.on('end', () => {
	    console.log('No more data in response.');
	  });
	});

	req.on('error', (e) => {
	  console.log(`problem with request: ${e.message}`);
	});

	// write data to request body
	req.write(postData);
	req.end();	
}

