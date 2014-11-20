var should = require('should')
  , sdk = require('../serious-backup-device-sdk');

describe('backup complete integration', function() {
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

  describe('#backup()', function() {
    it('should start the backup and return a backup time', function(done) {
      this.timeout(36000);
      sdk.backup(function(data) {
        console.log("sdk backup data is");
        console.log(data);
        data.time.should.be.ok;
        backupTime = data.time;
        // wait a second for backup to start.
        setTimeout(function(){ done(); },34000);        
      });
    })
  })

  describe('#restore()', function(done) {
    it('should restore the backup', function(done) {
      this.timeout(45000); 
      sdk.restore(backupTime, function(ret) {
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
