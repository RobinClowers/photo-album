import Head from 'next/head'
import Layout from 'client/components/Layout'
import AlbumGrid from 'client/components/AlbumGrid'
import { getAlbums } from 'client/src/api'

export default class extends React.Component {
  static async getInitialProps({ req }) {
    return await getAlbums(req)
  }

  render() {
    const { user, albums, share_photo } = this.props
    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <Head>
          <meta property="title" content="Robin's Photos" />
          <meta property="description" content="Travel photos from all over the world by Robin Clowers." />
          <meta property="og:title" content="Photos by Robin Clowers" />
          <meta property="og:description" content="Travel photos from all over the world by Robin Clowers." />
          <meta property="og:url" content={process.env.ROOT_URL} />
          <meta property="og:image" content={share_photo.url} />
          <meta property="og:image:secure_url" content={share_photo.url} />
          <meta property="og:image:width" content={share_photo.width} />
          <meta property="og:image:height" content={share_photo.height} />
        </Head>
        <AlbumGrid albums={this.props.albums} />
      </Layout>
    )
  }
}
