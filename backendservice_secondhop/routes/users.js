const winston = require("winston");
var newrelic = require("newrelic");

const logger = winston.createLogger({
  level: "debug",
  format: winston.format.json(),
  transports: [new winston.transports.Console()],
});

function returnErrorMayBe() {
    var num = Math.floor(Math.random()*10);
    logger.info("Random number is: " + num);
    try {
        if (num === 0) {
            var crash = fred*10;
        }
    }
        catch (err) {
            logger.error(err.message);
        throw err;
    }
    return num;
}

async function wait() {
    var num = Math.floor(Math.random()*3000);
    logger.info("Sleep time (milli seconds) is: " + num);
    await new Promise(resolve => setTimeout(resolve, num));
    return num;
}

function getUserParam(url) {
    var user = "unknown";
    var params = new URLSearchParams(url.substring(url.search(/\?/) + 1));
    if (params.has("user")) {
        user = params.get("user");
    }
    logger.debug("User is: " + user);
    return user;
}

const userRoutes = (app, fs) => {

    // variables
    const dataPath = './data/users.json';

    // READ
    app.get('/users', function getResults(req, res) {
        logger.debug("2nd hop called, with url: " + req.url);
        var user = newrelic.startSegment('getUserParam', true, function gUser() { return getUserParam(req.url);});
        //console.log(req.headers);
        var err = newrelic.startSegment('returnErrorMayBe', true, function returnError(){ return returnErrorMayBe();});
        newrelic.startSegment('slowFunction', true, function slowFunction() {
            wait().then(result => fs.readFile(dataPath, 'utf8', (err, data) => {
            if (err) {
                throw err;
            }
            res.header("Access-Control-Allow-Origin", "*");
            res.send(JSON.parse(data));
        }))});
    });
};

module.exports = userRoutes;
