puts path = File.expand_path('../../../log/', __FILE__)

`rm -rf #{path}`
`mkdir #{path}`
`touch #{path + '/.keep'}`
`touch #{path + '/development.log'}`
`touch #{path + '/test.log'}`

puts path = File.expand_path('../../../tmp/screenshots/', __FILE__)
`rm -rf #{path}`
`mkdir #{path}`
