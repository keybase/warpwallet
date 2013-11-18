
var triplesec = require('triplesec');
var scrypt = triplesec.scrypt;
var generate = require('keybase-bitcoin').generate;
var WordArray = triplesec.WordArray;

exports.run = function(key, salt, params, progress_hook,cb) {
	d.klass = triplesec.HMAC_SHA256;
	triplesec.pbkdf2(d,cb);
};
