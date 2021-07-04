puts path = File.expand_path('../../../log/', __dir__)

`rm -rf #{path}`
`mkdir #{path}`
`touch #{path + '/.keep'}`
`touch #{path + '/development.log'}`
`touch #{path + '/test.log'}`

puts path = File.expand_path('../../../tmp/screenshots/', __dir__)
`rm -rf #{path}`
`mkdir #{path}`
