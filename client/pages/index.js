import fetch from 'isomorphic-unfetch'
import Layout from 'components/Layout'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'

export default class extends React.Component {
  static async getInitialProps({ req }) {
    const userAgent = req ? req.headers['user-agent'] : navigator.userAgent
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
