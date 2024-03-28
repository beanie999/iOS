const http = require('http');
const newrelic = require('newrelic');
const winston = require("winston");

const logger = winston.createLogger({
  level: "debug",
  format: winston.format.json(),
  transports: [new winston.transports.Console()],
});

const options = {
  hostname: 'localhost',
  port: '3002',
  path: '/users',
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
  }
}

const webrequest = (app, fs) => {

    // variable

    // READ
    app.get('/webrequest', function get_webrequest(req, res) {
        let js = {message: "Headers received"};
        js.headers = req.headers;
        logger.debug(js);

        http.get('http://127.0.0.1:3002/users', (resp) => {
        let data = '';
        logger.debug("This is a debug message from 1st.");
        // A chunk of data has been recieved.
        resp.on('data', (chunk) => {
          data += chunk;

        });

        // The whole response has been received. Print out the result.
        resp.on('end', () => {

          res.send(data);
          newrelic.addCustomAttributes('userID','gqx293795');

        });

      }).on("error", (err) => {
          logger.error(err);
      });
    });
};

module.exports = webrequest;
