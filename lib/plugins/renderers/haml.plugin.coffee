# Requires
DocpadPlugin = require "#{__dirname}/../../plugin.coffee"
haml = require 'hamljs'

# Define Plugin
class HamlPlugin extends DocpadPlugin
	# Plugin name
	name: 'haml'

	# Plugin state
	enable: true

	# Plugin priority
	priority: 725

	# Render some content
	render: ({inExtension,outExtension,templateData,file}, next) ->
		try
			if inExtension is 'haml'
				file.content = haml.render file.content, locals: templateData
				next()
			else
				next()
		catch err
			return next(err)

# Export Plugin
module.exports = HamlPlugin
