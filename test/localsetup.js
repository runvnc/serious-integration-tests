var should = require('should')
  , childproc = require('child_process');

checkRunning = function(match, cb) {
  console.log("Running pgrep to check if " + match + " is already running.");
  console.log("Note that this won't work if there is no pgrep (did " +
              "you start the test using the localtests.sh script?");

  childproc.exec('pgrep -fx ' + match + ' 2>&1', function(e,out,er) {
    if (e) {
      cb(false);
    } else if (out.length>3) {
      cb(true);
    } else {
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

exports.beforeTests = beforeTests();
