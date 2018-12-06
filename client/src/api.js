import fetch from 'isomorphic-unfetch'

const scheme = process.env.API_SCHEME
const host = process.env.API_HOST

export const getAlbums = async request => await getJson('/', request)

export const getAlbum = async (slug, request) => await getJson(`/albums/${slug}`, request)

export const getPhoto = async (slug, filename, request) =>
  await getJson(`/albums/${slug}/photos/${filename}`, request)

const getJson = async (path, request = {}) => {
  const cookie = request.headers && request.headers.cookie
  const response = await fetch(`${scheme}://${host}${path}`, {
    credentials: 'include',
    headers: {
      'Cookie': cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  })
  const data = await response.json()
  return { ...data, csrfToken: response.headers.get('x-csrf-token') }
}

export const signOut = async (request = {}) => {
  const response = await fetch(`${scheme}://${host}/signout`, {
    method: 'DELETE',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': window.csrfToken,
    },
  })

  return response.status === 200
}
