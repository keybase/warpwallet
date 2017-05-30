var test = require('tap').test;
var browserify = require('browserify');
var vm = require('vm');

function bundle (file) {
    test('bundle transform', function (t) {
        t.plan(1);

        var b = browserify();
        b.add(__dirname + file);
        b.transform(__dirname + '/..');
        b.bundle(function (err, src) {
            if (err) t.fail(err);
            vm.runInNewContext(src, {
                setTimeout : setTimeout,
                console: { log: log }
            });
        });

        function log (msg) {
            t.equal(msg, 555);
        }
    });
}

bundle('/../example/foo.coffee');
bundle('/../example/foo.litcoffee');
bundle('/../example/foo.iced');
bundle('/../example/foo2.iced');
