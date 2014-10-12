To run local tests use the `./localtests.sh` command.  Note that you must have `mocha` and `pgrep` installed.

This tests everything working together.  
It starts first up a server (normally would run on EC2, here runs on localhost),
and a client REST API server (normally would run on the Beaglebone, for testing runs on localhost).
Redis should be running.

The mocha tests check that the client SDK returns the correct values given the test data.
In the process it tests the function and integration of the server (with its REST API and 0mq file transport),
the client REST API server (and the library module it uses), and the client SDK that connects to the 
client REST API Server.

