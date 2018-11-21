const scheme = 'http'
const host = process.env.API_HOST || 'localhost:5000'

export const getAlbums = async slug => await getJson('/')

export const getAlbum = async slug => await getJson(`/albums/${slug}`)

const getJson = async path => {
  const response = await fetch(`${scheme}://${host}${path}`, {
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  })
  return response.json()
}
