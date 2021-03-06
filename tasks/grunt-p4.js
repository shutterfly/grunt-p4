/*

The MIT License

Copyright 2014, Shutterfly, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


(function() {
  module.exports = function(grunt) {
    var createP4Handler, execP4;
    grunt.registerMultiTask('p4revert', 'Revert files in Perforce', function() {
      var p4, paths;
      paths = this.options({
        paths: []
      }).paths;
      p4 = {
        cmd: 'p4',
        args: ['revert'].concat(paths)
      };
      return execP4(p4, this.async());
    });
    grunt.registerMultiTask('p4sync', 'Synchronize files in Perforce', function() {
      var options, p4;
      p4 = {
        cmd: 'p4',
        args: ['sync']
      };
      options = this.options({
        preview: false,
        force: false,
        paths: []
      });
      if (options.preview === true) {
        p4.args.push('-n');
      }
      if (options.force === true) {
        p4.args.push('-f');
      }
      p4.args = p4.args.concat(options.paths);
      return execP4(p4, this.async());
    });
    grunt.registerMultiTask('p4edit', 'Edit files in Perforce', function() {
      var options, p4;
      p4 = {
        cmd: 'p4',
        args: ['edit']
      };
      options = this.options({
        preview: false,
        paths: []
      });
      if (options.preview === true) {
        p4.args.push('-n');
      }
      p4.args = p4.args.concat(options.paths);
      return execP4(p4, this.async());
    });
    grunt.registerMultiTask('p4submit', 'Submit files in Perforce', function() {
      var options, p4;
      p4 = {
        cmd: 'p4',
        args: ['submit']
      };
      options = this.options({
        description: 'Automated submit via Grunt'
      });
      if (options.changelist) {
        p4.args.push('-d', options.description);
        p4.args.push('-c', options.changelist);
        return execP4(p4, this.async());
      } else {
        return grunt.log.writeln('p4 submit was skipped; no changelist specified');
      }
    });
    execP4 = function(command, asyncCallback) {
      grunt.verbose.writeln("Executing " + command.cmd + " " + (command.args.join(' ')));
      return grunt.util.spawn(command, createP4Handler(command.args, asyncCallback));
    };
    return createP4Handler = function(args, done) {
      var commandName;
      commandName = args[0];
      return function(error, result, code) {
        if (error != null) {
          grunt.log.error("p4 " + commandName + " failed");
        } else {
          grunt.log.writeln(("STDOUT:\n" + result.stdout + "\n") + ("STDERR:\n" + result.stderr + "\n") + ("p4 " + commandName + " completed"));
        }
        return done(error);
      };
    };
  };

}).call(this);
