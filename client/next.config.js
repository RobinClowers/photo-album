const { PHASE_PRODUCTION_SERVER } =
  process.env.NODE_ENV === "development"
    ? require("next/constants")
    : require("next-server/constants");

module.exports = (phase) => {
  if (phase === PHASE_PRODUCTION_SERVER) {
    return {}
  }

  const webpack = require('webpack')
  return {
    webpack: (config, {}) => {
      config.plugins.push(
        new webpack.DefinePlugin({
          'process.env.API_ROOT': JSON.stringify(process.env.API_ROOT),
          'process.env.FRONT_END_ROOT': JSON.stringify(process.env.FRONT_END_ROOT),
        })
      )
      return config
    },
  }
}
