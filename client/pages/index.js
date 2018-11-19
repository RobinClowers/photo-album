import fetch from 'isomorphic-unfetch'
import Layout from 'components/Layout'
import Typography from '@material-ui/core/Typography'
import AlbumGrid from 'components/AlbumGrid'

export default class extends React.Component {
  static async getInitialProps(_context) {
    const res = await fetch('http://localhost:5000/', {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    })
    const albums = await res.json()
    return { albums }
  }

  render() {
    return (
      <Layout>
        <Typography variant="display3">
          Robin's Photos 2.0
        </Typography>
        <AlbumGrid albums={this.props.albums} />
      </Layout>
    )
  }
}
