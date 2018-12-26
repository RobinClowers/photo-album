import fetch from 'isomorphic-unfetch'

const scheme = process.env.API_SCHEME
const host = process.env.API_HOST

export const getUser = async request => await getJson('/users/current', request)

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

export const signIn = async (email, password) => {
  return await fetch(`${scheme}://${host}/users/sign_in`, {
    ...defaultOptions(),
    method: 'POST',
    body: JSON.stringify({ user: { email, password } }),
  })
}

export const signOut = async (request = {}) => {
  const response = await fetch(`${scheme}://${host}/users/sign_out`, {
    ...defaultOptions(),
    method: 'DELETE',
  })

  return response.status === 204
}

export const postComment = async (photo_id, comment) => {
  return await fetch(`${scheme}://${host}/photos/${photo_id}/comments`, {
    ...defaultOptions(),
    method: 'POST',
    body: JSON.stringify({ comment }),
  })
}

export const createFavorite = async (photo_id) => {
  return await fetch(`${scheme}://${host}/photos/${photo_id}/plus_ones`, {
    ...defaultOptions(),
    method: 'POST',
  })
}

export const deleteFavorite = async (photo_id, plus_one_id) => {
  return await fetch(`${scheme}://${host}/photos/${photo_id}/plus_ones/${plus_one_id}`, {
    ...defaultOptions(),
    method: 'DELETE',
  })
}

export const updatePhoto = async (photo_id, photo) => {
  return await fetch(`${scheme}://${host}/admin/photos/${photo_id}`, {
    ...defaultOptions(),
    method: 'PUT',
    body: JSON.stringify(photo),
  })
}

export const signUp = async user => {
  return await fetch(`${scheme}://${host}/users`, {
    ...defaultOptions(),
    method: 'POST',
    body: JSON.stringify({ user: { ...user, provider: "email" } }),
  })
}

export const changePassword = async params => {
  return await fetch(`${scheme}://${host}/users`, {
    ...defaultOptions(),
    method: 'PATCH',
    body: JSON.stringify({ user: params })
  })
}

export const resetPassword = async params => {
  return await fetch(`${scheme}://${host}/users/password`, {
    ...defaultOptions(),
    method: 'PATCH',
    body: JSON.stringify({ user: params })
  })
}

export const sendPasswordReset = async email => {
  return await fetch(`${scheme}://${host}/users/password`, {
    ...defaultOptions(),
    method: 'POST',
    body: JSON.stringify({ user: { email } })
  })
}

const defaultOptions = () => ({
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-CSRF-Token': window.csrfToken,
  },
})
