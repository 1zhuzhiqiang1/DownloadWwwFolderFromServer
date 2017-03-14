cordova.define("chinasofti.anyware.AnywarePlugin", function (require, exports, module) {
    var exec = require('cordova/exec');

    exports.coolMethod = function (arg0, success, error) {
        exec(success, error, "AnywarePlugin", "coolMethod", [arg0]);
    };

    exports.downloadWwwFolder = function (arg0, success, error) {
        exec(success, error, "AnywarePlugin", "downloadWwwFolder", [arg0]);
    };

});
