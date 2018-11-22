const webpack = require('webpack')

module.exports = () => ({
  webpack: (config, {}) => {
    config.plugins.push(
      new webpack.DefinePlugin({
        'process.env.API_SCHEME': JSON.stringify(process.env.API_SCHEME),
        'process.env.API_HOST': JSON.stringify(process.env.API_HOST),
      })
    )
    return config
  },
})
