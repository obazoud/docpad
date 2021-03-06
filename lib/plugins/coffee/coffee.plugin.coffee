# Requires
DocpadPlugin = require "#{__dirname}/../../plugin.coffee"
ck = null
html2ck = null
coffee = null
js2coffee = null

# Define Plugin
class CoffeePlugin extends DocpadPlugin
	# Plugin name
	name: 'coffee'

	# Plugin priority
	priority: 700

	# Render some content
	render: ({inExtension,outExtension,templateData,file}, next) ->
		try
			# CoffeeKup to anything
			if inExtension in ['coffeekup','ck'] or (inExtension is 'coffee' and !(outExtension in ['js','css']))
				ck = require 'coffeekup'  unless ck
				file.content = ck.render file.content, templateData
				next()
			
			# HTML to CoffeeKup
			else if inExtension is 'html' and outExtension in ['coffeekup','ck','coffee']
				html2ck = require 'html2coffeekup'  unless html2ck
				outputStream = {
					content: ''
					write: (content) ->
						@content += content
				}
				html2ck.convert file.content, outputStream, (err) ->
					next err  if err
					file.content = outputStream.content
					next()
			
			# CoffeeScript to JavaScript
			else if inExtension is 'coffee' and outExtension is 'js'
				coffee = require 'coffee-script'  unless coffee
				file.content = coffee.compile file.content
				next()
			
			# JavaScript to CoffeeScript
			else if inExtension is 'js' and outExtension is 'coffee'
				js2coffee = require 'js2coffee/lib/js2coffee.coffee'  unless js2coffee
				file.content = js2coffee.build file.content
				next()
			
			# Removed the CoffeeCSS plugin as it was causing issues in the new version
			# Either caused by docpad v2.0, node.js 0.6, or coffee-script 1.1.1

			# Other
			else
				next()
		
		catch err
			return next err

# Export Plugin
module.exports = CoffeePlugin