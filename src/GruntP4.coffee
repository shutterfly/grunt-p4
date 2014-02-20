module.exports = (grunt) ->

  grunt.registerMultiTask 'p4revert', 'Revert files in Perforce', ->
    paths = @options(
      paths: []
    ).paths

    p4 =
      cmd: 'p4'
      args: ['revert'].concat(paths)

    execP4(p4, @async())

  grunt.registerMultiTask 'p4sync', 'Synchronize files in Perforce', ->
    p4 =
      cmd: 'p4'
      args: ['sync']

    options = @options(
      preview: false
      force: false
      paths: []
    )

    if options.preview == true
      p4.args.push('-n')

    if options.force == true
      p4.args.push('-f')

    p4.args = p4.args.concat(options.paths)
    execP4(p4, @async())

  grunt.registerMultiTask 'p4edit', 'Edit files in Perforce', ->
    p4 =
      cmd: 'p4'
      args: ['edit']

    options = @options(
      preview: false
      paths: []
    )

    if options.preview == true
      p4.args.push('-n')

    p4.args = p4.args.concat(options.paths)
    execP4(p4, @async())

  grunt.registerMultiTask 'p4submit', 'Submit files in Perforce', ->
    p4 =
      cmd: 'p4'
      args: ['submit']

    options = @options(
      description: 'Automated submit via Grunt'
    )

    if options.changelist
      p4.args.push('-d', options.description)
      p4.args.push('-c', options.changelist)

      execP4(p4, @async())
    else
      grunt.log.writeln('p4 submit was skipped; no changelist specified')

  execP4 = (command, asyncCallback) ->
    grunt.verbose.writeln("Executing #{command.cmd} #{command.args.join(' ')}")
    grunt.util.spawn(command, createP4Handler(command.args, asyncCallback))

  createP4Handler = (args, done) ->
    commandName = args[0]
    return (error, result, code) ->
      if error?
        grunt.log.error("p4 #{commandName} failed")
      else
        grunt.log.writeln("STDOUT:\n#{ result.stdout }\n" +
        "STDERR:\n#{ result.stderr }\n" +
        "p4 #{ commandName } completed")
      done(error)