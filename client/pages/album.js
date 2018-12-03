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
  static async getInitialProps({ query }) {
    if (!query.slug) return { error: true }

    return await getAlbum(query.slug)
  }

  render() {
    const { classes, user, album, error } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
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
