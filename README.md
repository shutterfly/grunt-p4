grunt-p4
========

Execute common p4 commands from your Grunt build.

Note that for these commands, file paths must be specified in the task options,
not the task's list of files. Grunt strips the task file list of non-existent
files, and often (especially in the case of p4 sync) the files you intend to
sync may not yet exist.

All commands are multi-tasks and can be [configured as such](http://gruntjs.com/configuring-tasks).

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