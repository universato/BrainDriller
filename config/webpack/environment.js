const { environment } = require('@rails/webpacker')
// const { VueLoaderPlugin } = require('vue-loader')
// const vue = require('./loaders/vue')

const { VueLoaderPlugin } = require('vue-loader')
environment.plugins.prepend(
    'VueLoaderPlugin',
    new VueLoaderPlugin()
)
environment.loaders.prepend('vue', {
    test: /\.vue$/,
    use: [{
        loader: 'vue-loader'
    }]
})

// environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
// environment.loaders.prepend('vue', vue)
module.exports = environment
