import Error from 'next/error'
import fetch from 'isomorphic-unfetch'
import Layout from 'client/components/Layout'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'
import { withStyles } from '@material-ui/core/styles'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import { getAlbum } from 'client/src/api'

const styles = theme => ({
  paper: {
    height: 240,
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
    width: 320,
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
      <Layout user={user}>
        <div style={{padding: 20}} >
          <Typography className={classes.title} variant="h2" color="inherit" noWrap>
            {album.title}
          </Typography>
          <Grid justify='center' container spacing={24}>
            {album.photos.map(photo => (
              <Grid item key={photo.id}>
                <Paper className={classes.paper}>
                  <img src={photo.url} className={classes.image} />
                </Paper>
              </Grid>
            ))}
          </Grid>
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Album)
