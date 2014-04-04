module.exports = (grunt) ->

  grunt.initConfig

    clean:
      build: ['./target']

    coffee:
      src:
        options:
          join: true
        files:
          'dist/grunt-p4.js': ['./src/**/*.coffee']

      spec:
        options:
          bare: true
          join: false
        expand: true
        src: ['./spec/**/*.spec.coffee']
        dest: './target'
        ext: '.spec.js'

    watch:
      coffee:
        files: '**/*.coffee'
        tasks: ['clean', 'coffee', 'jasmine_node']

    jasmine_node:
      projectRoot: 'target'
      requirejs: false
      forceExit: true
      verbose: true

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-jasmine-node')

  grunt.registerTask('default', ['clean', 'coffee', 'watch'])
  grunt.registerTask('test', ['jasmine_node'])