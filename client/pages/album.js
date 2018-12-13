import Head from 'next/head'
import Error from 'next/error'
import Layout from 'client/components/Layout'
import Grid from '@material-ui/core/Grid'
import { withStyles } from '@material-ui/core/styles'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import { getAlbum } from 'client/src/api'
import { Link } from 'client/routes'

const styles = theme => ({
  gridItem: {
    cursor: 'pointer',
    textAlign: 'center',
    color: theme.palette.text.secondary,
    whiteSpace: 'nowrap',
    overflow: 'hidden',
  },
  title: {
    padding: theme.spacing.unit,
    margin: theme.spacing.unit,
    textAlign: 'center',
  },
  image: {
    width: 240,
    height: 240,
  },
})

class Album extends React.Component {
  static async getInitialProps({ req, query }) {
    if (!query.slug) return { error: true }

    return await getAlbum(query.slug, req)
  }

  render() {
    const { classes, user, album, error } = this.props

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
          <meta property="og:url" content={`${process.env.ROOT_URL}/albums/${album.slug}`} />
          <meta property="og:image" content={album.cover_photo_secure_url} />
          <meta property="og:image:secure_url" content={album.cover_photo_secure_url} />
        </Head>
        <div style={{padding: 20}} >
          <Typography className={classes.title} variant="h2" color="inherit" noWrap>
            {album.title}
          </Typography>
          <Grid justify='center' container spacing={8}>
            {album.photos.map(photo => (
              <Link
                route='photo'
                params={{slug: album.slug, filename: photo.filename}}
                key={photo.id}>
                <Grid item>
                  <div className={classes.gridItem}>
                    <img src={photo.small_url} className={classes.image} />
                  </div>
                </Grid>
              </Link>
            ))}
          </Grid>
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Album)
