module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    watch: {
      all: {
        files: [
          'modules/{,*/}*'
          'partials/{,*/}*'
          'lib/{,*/}*'
        ]
        tasks: [
          'shell:kansoPush'
        ]
      }
    }
    coffee: {
      options:
        join: true
        bare: true
      dist: {
        files:
          'static/js/main.js': [
            'modules/*/__init__.coffee'
            'modules/*/config.coffee'
            'modules/*/routes.coffee'
            'modules/*/*.coffee'
          ]
      }
    }
    uglify: {
      options:
        report: 'gzip'
        mangle: false
      js: {
        files: [{
          expand: true
          cwd: 'static/js'
          src: [
            '*.js'
            'dist/*.js'
          ]
          dest: 'static/compress/js'
        }]
      }
      vendor: {
        files: [{
          expand: true
          cwd: 'static/vendor'
          filter: 'isFile'
          src: [
            '**/*.js'
            '**/GruntFile.js'
            '!**/*.min.js'
            '!**/src/**/*.js'
            '!**/test/**/*.js'
          ]
          dest: 'static/compress/vendor'
        }]
      }
    }
    cssmin: {
      options:
        report: 'gzip'
      minify: {
        expand: true
        filter: 'isFile'
        cwd: 'static/css/'
        src: [
          '*.css'
          '!*.min.css'
        ]
        dest: 'static/compress/css/',
      }
    }
    imagemin: {
      static: {
        options:
          optimizationLevel: 7
          interlaced: true
          progressive: true
        files: [{
          expand: true
          cwd: './static/images/'
          src: ['**/*.{png,jpg,gif}']
          dest: 'static/compress/images'
        }]
      }
    },
    # Kanso
    shell:{
      options:
        stdout: true
      kansoDelete:{
        command: ->
          name = grunt.option('db') || 'default'
          return "kanso deletedb #{name}"
      }
      kansoCreate:{
        command: ->
          name = grunt.option('db') || 'default'
          return "kanso createdb #{name}"
      }
      kansoInit:{
        command: ->
          name = grunt.option('db') || 'default'
          return "kanso upload ./data #{name}"
      }
      kansoPush:{
        command: ->
          name = grunt.option('db') || 'default'
          return "kanso push #{name}"
      }
    }
  }

  grunt.registerTask('init', [
    'shell:kansoDelete'
    'shell:kansoCreate'
    'shell:kansoInit'
    'shell:kansoPush'
  ])

  grunt.registerTask('default', [
    'watch'
  ])

  grunt.registerTask('prod', [
    'uglify'
    'cssmin'
    'imagemin'
  ])
