import Head from 'next/head'
import Layout from 'client/components/Layout'
import AlbumGrid from 'client/components/AlbumGrid'
import EmailConfirmed from 'client/components/EmailConfirmed'
import { Router } from 'client/routes';
import { getAlbums } from 'client/src/api'

export default class extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      emailConfirmedOpen: this.props.emailConfirmed,
    }
  }

  static async getInitialProps({ req, query }) {
    const result = await getAlbums(req)
    return {
      ...result,
      emailConfirmed: query.emailConfirmed === 'true' ,
      error: query.error,
    }
  }

  handleDismissEmailConfirmed = () => {
    this.setState({ emailConfirmedOpen: false })
    Router.replaceRoute('index')
  }

  render() {
    const { user, albums, share_photo, emailConfirmed } = this.props
    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <Head>
          <meta property="title" content="Robinʼs Photos" />
          <meta property="description" content="Travel photos from all over the world by Robin Clowers." />
          <meta property="og:title" content="Photos by Robin Clowers" />
          <meta property="og:description" content="Travel photos from all over the world by Robin Clowers." />
          <meta property="og:url" content={process.env.FRONT_END_ROOT} />
          <meta property="og:image" content={share_photo.url} />
          <meta property="og:image:secure_url" content={share_photo.url} />
          <meta property="og:image:width" content={share_photo.width} />
          <meta property="og:image:height" content={share_photo.height} />
        </Head>
        <AlbumGrid albums={this.props.albums} />
        <EmailConfirmed
          open={this.state.emailConfirmedOpen || !!this.props.error}
          error={this.props.error}
          dismiss={this.handleDismissEmailConfirmed} />
      </Layout>
    )
  }
}
