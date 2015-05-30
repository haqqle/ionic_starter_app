"use sct"

bower    = require('bower')
sh       = require('shelljs')
gulp     = require("gulp")
$        = require("gulp-load-plugins")(lazy: false)
$run     = require('run-sequence')
$logger  = $.util.log

paths =
  styles:  ['./scss/ionic.app.scss']
  scripts: ['./app/scripts/**/*.coffee']
  views:   ['./app/views/**/*.jade']
  assets:  ['./app/assets/**']
  config :  ['./config.xml']
  res :  ['./res/**']

gulp.task "copy", ->
  gulp.src(paths.assets)
    .pipe(gulp.dest('./www/'))

  gulp.src(paths.config)
  .pipe(gulp.dest('./www/'))

  gulp.src(paths.res)
  .pipe(gulp.dest('./www/res'))

gulp.task 'sass', (done) ->
  gulp.src(paths.styles)
    .pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
    .pipe($.sass(errLogToConsole: true))
    .pipe($.concat('style.css'))
    .pipe(gulp.dest('./www/css'))
    .pipe($.minifyCss(keepSpecialComments: 0))
    .pipe($.rename(extname: '.min.css'))
    .pipe(gulp.dest('./www/css/'))
    .pipe($.size(showFiles: true))

gulp.task 'coffee', (done) ->
  gulp.src(paths.scripts)
    .pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
    .pipe($.coffee(bare: false).on('error', $logger))
    .pipe($.jshint(".jshintrc"))
    .pipe($.jshint.reporter('jshint-stylish'))
    .pipe($.concat('app.js'))
    .pipe($.insert.prepend("'use strict';\n"))
    .pipe(gulp.dest('./www/js'))
    .pipe($.size(showFiles: true))


gulp.task 'jade', (done) ->
  gulp.src(paths.views)
    .pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
    .pipe($.jade())
    .pipe(gulp.dest('./www/views'))
    .pipe($.angularTemplatecache('views', {standalone:true, root: '/views/'} ))
    .pipe($.rename(extname: '.js'))
    .pipe(gulp.dest('./www/js'))
    .pipe($.size(showFiles: true))

gulp.task 'watch', ->
  gulp.watch(paths.styles, ['sass'])
  gulp.watch(paths.scripts, ['coffee'])
  gulp.watch(paths.views, ['jade'])
  gulp.watch(paths.assets, ['copy'])

gulp.task 'build', (callback) ->
  $run("sass", "coffee", "jade", "copy", callback)

gulp.task 'default', ['build']

gulp.task 'install', ['git-check'], ->
  bower.commands.install().on 'log', (data) ->
    $logger('bower', $.util.colors.cyan(data.id), data.message)

gulp.task 'git-check', (done) ->
  if !sh.which('git')
    console.log(
      '  ' + $.util.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', $.util.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + $.util.colors.cyan('gulp install') + '\' again.'
    )
    process.exit(1)
  done()
