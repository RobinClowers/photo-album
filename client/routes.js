const routes = module.exports = require('next-routes')()

routes.add('index', '/')
routes.add('changePassword', '/account/change-password', 'account/change-password')
routes.add('album', '/albums/:slug')
routes.add('photo', '/albums/:slug/:filename')
