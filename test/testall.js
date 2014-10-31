var should = require('should')
  , sdk = require('../serious-backup-device-sdk');

describe('backup complete integration', function() {
  var backupKey = null;
  var backupTime = null;

  before(function(done) {
    if (process.env.hasOwnProperty('TEST_REMOTE') &&
        process.env.TEST_REMOTE === 'YES') {
      var remote = require('./remotesetup');
      remote.beforeTests(done);
    } else {
      var local = require('./localsetup');
      local.beforeTests(done);
    }
  })

  describe('#qrimagetag()', function() {
    it('should return an image tag', function(done) {
      sdk.QRImageTag('dummy-backup-key', function(tag) {
        it.should.match(/\<img(.)*/);
        done();
      });
    });
  });
 
  describe('#backup()', function() {
    it('should start the backup and return a backup time', function(done) {
      this.timeout(26000);
      sdk.backup(function(data) {
        console.log('backup returns: ***********');
        console.log(data);
        var key = data.key;
        key.should.be.ok;
        key.length.should.be.greaterThan(4);
        backupKey = key;
        data.time.should.be.ok;
        backupTime = data.time;
        // wait a second for backup to start.
        setTimeout(function(){ done(); },30000);        
      });
    })
  })

  describe('#generalStatus()', function() {
    it('should indicate a backup is running', function(done) {
      this.timeout(35000);
      checkFinished = function() {
        sdk.generalStatus(function(currStatus) {
          currStatus.should.be.ok;
          console.log("current status:");
          console.log(currStatus);
          if (currStatus.activeCount == 0) {
            return done();
          } else {
            setTimeout(function() { checkFinished(); }, 25000);
          }
        });
      }
      checkFinished();
    })
  })
 
  describe('#restore()', function(done) {
    it('should restore the backup', function(done) {
      this.timeout(45000); 
      sdk.restore(backupKey, backupTime, function(ret) {
        ret.should.be.ok;
        setTimeout(function() { done(); }, 36000);
      });
     });
  });

  describe('#listBackups()', function(done) {
    it('should list backups', function(done) {
      sdk.listBackups(function(ret) {
        ret.length.should.be.above(0);
        console.log("backups:");
        console.log(ret);
        done();
      });
    });
  });
 
});
