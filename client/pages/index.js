import fetch from 'isomorphic-unfetch'
import Layout from 'client/components/Layout'
import AlbumGrid from 'client/components/AlbumGrid'
import { getAlbums } from 'client/src/api'

export default class extends React.Component {
  static async getInitialProps(_context) {
    return await getAlbums()
  }

  render() {
    const { user, albums } = this.props
    return (
      <Layout user={user}>
        <AlbumGrid albums={this.props.albums} />
      </Layout>
    )
  }
}
