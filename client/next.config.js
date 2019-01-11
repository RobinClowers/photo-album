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
        new webpack.DefinePlugin(definePluginConfig())
      )
      return config
    },
  }
}

const defaultEnv = {
  'process.env.API_ROOT': JSON.stringify(process.env.API_ROOT),
  'process.env.FRONT_END_ROOT': JSON.stringify(process.env.FRONT_END_ROOT),
  'process.env.GA_TRACKING_ID': JSON.stringify(process.env.GA_TRACKING_ID),
  'process.env.DEBUG_GA': JSON.stringify(process.env.DEBUG_GA),
}

const definePluginConfig = () => {
  if (process.env.NOW_GITHUB_COMMIT_REF === 'staging') {
    return {
      ...defaultEnv,
      'process.env.API_ROOT': JSON.stringify(process.env.STAGING_API_ROOT),
      'process.env.FRONT_END_ROOT': JSON.stringify(process.env.STAGING_FRONT_END_ROOT),
    }
  }
  return defaultEnv
}
