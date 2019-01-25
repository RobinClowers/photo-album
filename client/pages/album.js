import Head from 'next/head'
import Error from 'next/error'
import Layout from 'client/components/Layout'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import { getAlbum } from 'client/src/api'
import PhotoGrid from 'client/components/PhotoGrid'

const styles = theme => ({
  title: {
    padding: theme.spacing.unit,
    margin: theme.spacing.unit,
    textAlign: 'center',
  },
})

class Album extends React.Component {
  static async getInitialProps({ req, query }) {
    if (!query.slug) return { error: true }

    return await getAlbum(query.slug, req)
  }

  render() {
    const { classes, user, album, share_photo, error } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <Head>
          <title>{`${album.title} photos`}</title>
          <meta property="title" content={`Photos from ${album.title}`} />
          <meta property="description" content={`Photos from ${album.title}`} />
          <meta property="og:title" content={album.title} />
          <meta property="og:description" content={`Photos from ${album.title}`} />
          <meta property="og:url" content={`${process.env.FRONT_END_ROOT}/albums/${album.slug}`} />
          <meta property="og:image" content={album.cover_photo.urls.original} />
          <meta property="og:image:secure_url" content={share_photo.url} />
          <meta property="og:image:width" content={share_photo.width} />
          <meta property="og:image:height" content={share_photo.height} />
        </Head>
        <div>
          <Typography className={classes.title} variant="h2" color="inherit">
            {album.title}
          </Typography>
          <PhotoGrid photos={album.photos} user={user} />
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Album)
