const routes = module.exports = require('next-routes')()

routes.add('index', '/')
routes.add('album', '/albums/:slug')
