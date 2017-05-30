
var lib = require('./lib/lib.js');

// This is actually the one function that we expose.  The rest
// isn't ready to use, yet.
exports.generate = function(buffer) {
    var a = new Array(buffer.length);
    var i;
    for (i = 0; i < buffer.length; i++) {
        a[i] = buffer.readUInt8(i);
    }
    var key = new lib.Bitcoin.ECKey(a);
    var ret = {
        "public"  : key.getBitcoinAddress(),
        "private" : key.getBitcoinWalletImportFormat()
    };
    return ret;
};
