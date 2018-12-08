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

export const postComment = async (photo_id, comment) => {
  return await fetch(`${scheme}://${host}/photos/${photo_id}/comments`, {
    method: 'POST',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': window.csrfToken,
    },
    body: JSON.stringify({ comment }),
  })
}

export const createFavorite = async (photo_id) => {
  return await fetch(`${scheme}://${host}/photos/${photo_id}/plus_ones`, {
    method: 'POST',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': window.csrfToken,
    },
  })
}

export const deleteFavorite = async (photo_id, plus_one_id) => {
  return await fetch(`${scheme}://${host}/photos/${photo_id}/plus_ones/${plus_one_id}`, {
    method: 'DELETE',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': window.csrfToken,
    },
  })
}

export const updatePhoto = async (photo_id, photo) => {
  return await fetch(`${scheme}://${host}/admin/photos/${photo_id}`, {
    method: 'PUT',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': window.csrfToken,
    },
    body: JSON.stringify(photo),
  })
}
