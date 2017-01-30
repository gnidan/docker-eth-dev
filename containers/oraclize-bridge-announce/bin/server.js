var fs = require('fs');
var http = require('http');
var chokidar = require('chokidar');
var path = require('path');

const PORT=80;
const DIR='/var/oraclize-instance/';

function handleRequest(request, response) {
    awaitInstanceJSON().then(function (json) {
        var oar = json.oar;
        response.end(oar);
    });
}

function getRecentFiles(dir) {
    return fs.readdirSync(DIR)
                  .map(function(v) {
                      return { name:v,
                               time:fs.statSync(DIR + v).mtime.getTime()
                             };
                   })
                   .sort(function(a, b) { return a.time - b.time; })
                   .map(function(v) { return v.name; });
}


function awaitInstanceJSON() {
    return new Promise(function(resolve, reject) {
        var recentFiles = getRecentFiles(DIR);
        console.log("recentFiles ", recentFiles);
        var mostRecent = recentFiles[recentFiles.length - 1];

        if (mostRecent === 'SENTINEL') {
            console.log("got SENTINEL, waiting");
            var watcher = chokidar.watch(
                DIR + "oracle_instance_*.json",
                {persistent: true}
            );
            watcher.on('add', function (addedPath) {
                if (recentFiles.indexOf(path.basename(addedPath)) === -1) {
                    console.log("found new file ", addedPath);
                    resolve(parseFile(addedPath));
                }
            });
        } else {
            resolve(parseFile(DIR + mostRecent));
        }
    });
}

function parseFile(path) {
    var contents = fs.readFileSync(path);
    return JSON.parse(contents);
}

//

var server = http.createServer(handleRequest);

server.listen(PORT, function() {
    console.log("Server listening on port %s", PORT);
});
