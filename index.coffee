path = require 'path'
gutil = require 'gulp-util'
es = require 'event-stream'

COMPILERS =
  coffee: require 'gulp-coffee'
  jade: require 'gulp-jade'
  stylus: require 'gulp-stylus'

module.exports = (options={}) ->
  es.through (file) ->
    compiler = COMPILERS[extension = path.extname(file.path).replace('.', '')]
    return @queue(file) unless compiler

    es.readArray([file])
      .pipe(compiler(options[extension] or {}))
      .pipe(es.map (file, callback) =>
        file.path = gutil.replaceExtension(file.path, '.js')
        @queue(file); callback()
      )
