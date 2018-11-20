import fetch from 'isomorphic-unfetch'
import Layout from 'components/Layout'
import Typography from '@material-ui/core/Typography'
import AlbumGrid from 'components/AlbumGrid'

export default class extends React.Component {
  static async getInitialProps({ req }) {
    const res = await fetch('http://localhost:5000/', {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    })
    const json = await res.json()
    return { albums: json }
  }

  render() {
    return (
      <Layout>
        <Typography variant="h1">
          Robin's Photos 2.0
        </Typography>
        <ul className="album-list">
          {this.props.albums.map(album => (
            <li className="album">
              <h3>{album.title}</h3>
              <img src={album.cover_photo_thumb_url} />
            </li>
          ))}
        </ul>
      </Layout>
    )
  }
}
