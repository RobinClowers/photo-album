#!/usr/bin/env node
const { createServer } = require('http')
const next = require('next');
const { join } = require('path')
const { parse } = require('url')
const XRegExp = require('xregexp')

const dev = process.env.NODE_ENV !== 'production';
const app = next({ dev });
const port = parseInt(process.env.PORT, 10) || 3000
const currentPath = process.cwd()
const config = require(join(currentPath, process.env.NOW_CONFIG || 'now.json'))
const paramRegex = /\$([a-z]+|[\d]+)/g
const clientRegex = /^\/client/

const routes = config.routes.map(route => {
  return {
    regex: new XRegExp(route.src.replace('/', '\\/') + '\\/?$'),
    dest: route.dest
      .replace(clientRegex, '') // remove client prefix
      .replace(paramRegex, '${$1}'), // regex style replacement tokens
  }
})

const getRequestHandler = app => {
  const nextHandler = app.getRequestHandler()
  return (req, res) => {
    const parsedUrl = parse(req.url, true)
    const { pathname, query } = parsedUrl
    const route = routes.find(route => route.regex.test(pathname))
    if (route) {
      const resultUrl = XRegExp.replace(pathname, route.regex, route.dest)
      const parsedDestination = parse(resultUrl, true)
      const combinedQuery = { ...parsedDestination.query, ...query}
      app.render(req, res, parsedDestination.pathname, combinedQuery)
    } else {
      nextHandler(req, res, parsedUrl)
    }
  }
}

app.prepare().then(() => {
  createServer((req, res) => {
    const handle = getRequestHandler(app)
    handle(req, res)
  }).listen(3000, err => {
    if (err) throw err
    console.log('> Ready on http://localhost:3000')
  })
})
