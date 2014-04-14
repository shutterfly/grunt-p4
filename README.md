grunt-p4
========

Execute common p4 commands from your Grunt build.

Note that for these commands, file paths must be specified in the task options,
not the task's list of files. Grunt strips the task file list of non-existent
files, and often (especially in the case of p4 sync) the files you intend to
sync may not yet exist.

All commands are multi-tasks and can be [configured as such](http://gruntjs.com/configuring-tasks).

# Installing

Install at the project level, usually to your dev-dependencies:

`npm install grunt-p4 --save-dev`

# Supported Commands

## revert

Revert a list of files. (See [p4 revert](http://www.perforce.com/perforce/r13.1/manuals/cmdref/revert.html))

### Options
  - paths - Array; a list of file paths

### Example

```javascript

grunt.initConfig({
  p4revert: {
    options: {
      paths: [
        './src/version.js',
        './docs/version.md'
      ]
    }
  }
);

```

## sync

Synchronize local files with a remote repository. (See [p4 sync](http://www.perforce.com/perforce/r13.1/manuals/cmdref/sync.html))

### Options
  - paths - Array; a list of file paths
  - force - Boolean; when true, force the sync, even if the local workspace
  already has the file.
  - preview - Boolean; when true, displays the results of the sync without
  actually performing the sync.

### Example

```javascript

grunt.initConfig({
  p4sync: {
    options: {
      force: true,
      preview: false,
      paths: [
        './src/version.js',
        './docs/version.md'
      ]
    }
  }
);

```

## edit

Check out a file for modification in the local workspace. (See [p4 edit](http://www.perforce.com/perforce/r13.1/manuals/cmdref/edit.html))

### Options
  - paths - Array; a list of file paths
  - preview - Boolean; when true, displays the results of the sync without
  actually performing the sync.

### Example

```javascript

grunt.initConfig({
  p4edit: {
    options: {
      preview: false,
      paths: [
        './src/version.js',
        './docs/version.md'
      ]
    }
  },
});

```

## submit

Submit a changelist to the repository. (See [p4 submit](http://www.perforce.com/perforce/r13.1/manuals/cmdref/submit.html))

### Options
  - description - String; the commit message. If omitted, defaults to
  'Automated submit via Grunt'
  - changelist - Number; the changelist number. If omitted, the operation is
  not performed.

### Example

```javascript

grunt.initConfig({
  p4submit: {
    options: {
      description: 'A commit message',
      changelist: 12345
    }
  },
});

```

# Contributing

Fork this library and run `npm install`. This library is built using [Grunt](https://github.com/gruntjs/grunt),
which must be installed globally (`npm install -g grunt`).

Once installed, run `grunt` to enter watch mode, which will run unit tests with each change. (Run `grunt test`
for a single test run.)

All new code must have associated unit test coverage prior to pull request acceptance.