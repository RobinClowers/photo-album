import Layout from 'client/components/Layout'
import AlbumGrid from 'client/components/AlbumGrid'
import { getAlbums } from 'client/src/api'

export default class extends React.Component {
  static async getInitialProps({ req }) {
    return await getAlbums(req)
  }

  render() {
    const { user, albums } = this.props
    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <AlbumGrid albums={this.props.albums} />
      </Layout>
    )
  }
}
