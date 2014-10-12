var should = require('should')
  , childproc = require('child_process');

checkRunning = function(match, cb) {
  console.log("Running pgrep to check if " + match + " is already running.");
  console.log("(make sure you start the test using the localtests.sh script)");

  childproc.exec('pgrep -f ' + match + ' 2>&1', function(e,out,er) {
    if (e) {
      console.log('problem with running check for device API server');
      console.log(e);
      cb(false);
    } else if (out.length>3) {
      cb(true);
    } else {
      console.log("apiserver.js seems to not be running");
      console.log(e);
      console.log(out);
      console.log(er);
      cb(false);
    }
  });
}

startDevice = function(cb) {
  childproc.exec('cd ../serious-backup-device && npm start', function(e,out,stderr) {
    e.should.not.be.ok;
    console.log(out);
    if (stderr) {
      console.log(stderr);
    }
    cb();
  });
}

startServer = function(cb) {

}

beforeTests = function(done) {
  checkRunning('apiserver.js', function(running) {
    if (!running) {
      startDevice(done);
   } else {
      done();
    }
  });
}

exports.beforeTests = beforeTests;
