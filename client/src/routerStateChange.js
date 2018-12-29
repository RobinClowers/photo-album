import { Router } from 'next/router'
import { setReturnUrl } from 'client/src/urls'

const subscribers = {}

export function bindRouterStateChange(component, callback) {
  subscribers[component] = callback
}

export function unbindRouterStateChange(component) {
  delete subscribers[component]
}

const eachSubscriber = callback => {
  Object.keys(subscribers).forEach(key => callback(subscribers[key]))
}

Router.events.on('routeChangeStart', url => {
  eachSubscriber(callback => callback(url, true))
})

Router.events.on('routeChangeComplete', url => {
  eachSubscriber(callback => callback(url, false))
  setReturnUrl(global.location.href)
})

Router.events.on('routeChangeError', url => {
  eachSubscriber(callback => callback(url, false))
})
