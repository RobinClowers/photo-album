import Head from 'next/head'
import Typography from '@material-ui/core/Typography'
import { withStyles } from '@material-ui/core/styles'
import Layout from 'client/components/Layout'
import PhotoGrid from 'client/components/PhotoGrid'
import { getFavorites } from 'client/src/api'

const styles = theme => ({
  title: {
    padding: theme.spacing.unit,
    margin: theme.spacing.unit,
    textAlign: 'center',
  },
})

const Favorites = ({ photos, share_photo, user, pageContext, classes }) => {
  return (
    <Layout user={user} pageContext={pageContext}>
      <Head>
        <title>Favorite Photos</title>
        <meta property="title" content="Favorite photos" />
        <meta property="description" content="Users's favorite photos" />
        <meta property="og:title" content="Favorite photos" />
        <meta property="og:description" content="User's favorite photos" />
        <meta property="og:url" content={`${process.env.FRONT_END_ROOT}/favorites`} />
        <meta property="og:image" content={share_photo.url} />
        <meta property="og:image:secure_url" content={share_photo.url} />
        <meta property="og:image:width" content={share_photo.width} />
        <meta property="og:image:height" content={share_photo.height} />
      </Head>
      <div>
        <Typography className={classes.title} variant="h2" color="inherit">
          Favorite Photos
        </Typography>
        <PhotoGrid photos={photos} user={user} />
      </div>
    </Layout>
  )
}

Favorites.getInitialProps = async ({ req }) => await getFavorites(req)


export default withStyles(styles)(Favorites)
