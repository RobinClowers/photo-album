const routes = module.exports = require('next-routes')()

routes.add('index', '/')
routes.add('changePassword', '/account/change-password', 'account/change-password')
routes.add('forgotPassword', '/account/forgot-password', 'account/forgot-password')
routes.add('resetPassword', '/account/reset-password', 'account/reset-password')
routes.add('album', '/albums/:slug')
routes.add('photo', '/albums/:slug/:filename')
