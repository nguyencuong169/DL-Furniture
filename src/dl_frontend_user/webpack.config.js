const webpack = require('webpack')

module.exports = {
  // other webpack config
  plugins: [
    //   new webpack.ProvidePlugin({
    //     Vue: ['vue/dist/vue.esm.js', 'default']
    //   })
    new webpack.ProvidePlugin({
      Vue: ['vue/dist/vue.esm.js', 'default'],
      $: 'jquery',
      jQuery: 'jquery',
      jquery: 'jquery',
      'window.jQuery': 'jquery'
    })
  ]
}
