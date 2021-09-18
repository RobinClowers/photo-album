import cookie from 'cookie'

export const setCsrfCookie = csrfToken => {
  document.cookie = `csrfToken=${csrfToken};path=/;SameSite=Strict`
}

export const csrfToken = () => cookie.parse(document.cookie)['csrfToken']
