import { Router } from 'client/routes'
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

Router.onRouteChangeStart = _path => {
  eachSubscriber(callback => callback(true))
}

Router.onRouteChangeComplete = _path => {
  eachSubscriber(callback => callback(false))
  setReturnUrl(global.location.href)
}

Router.onRouteChangeError = _path => {
  eachSubscriber(callback => callback(false))
}
