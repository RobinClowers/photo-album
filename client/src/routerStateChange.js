import { Router } from 'client/routes'

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

Router.onRouteChangeStart = _url => {
  eachSubscriber(callback => callback(true))
}

Router.onRouteChangeComplete = _url => {
  eachSubscriber(callback => callback(false))
}

Router.onRouteChangeError = _url => {
  eachSubscriber(callback => callback(false))
}
