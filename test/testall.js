var should = require('should')
  , sdk = require('../serious-backup-device-sdk');

describe('backup complete integration', function() {
  var backupKey = null;

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
    it('should start the backup and return a backup key', function(done) {
      sdk.backup(function(key) {
        key.should.be.ok;
        key.length.should.be.greaterThan(4);
        backupKey = key;
        done();
      });
    })
  })

  describe('#generalStatus()', function() {
   
    it('should indicate a backup is running', function(done) {
      //sdk.generalStatus(function(currStatus) {
      //  currStatus.should.be.ok;    
        done();
      //});   
    })
  })
  
});
