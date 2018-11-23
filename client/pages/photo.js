import Error from 'next/error'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import { getPhoto } from 'client/src/api'

const styles = theme => ({
  container: {
    textAlign: 'center',
  },
  image: {
    width: 1024,
    height: 768,
  },
})

class Photo extends React.Component {
  static async getInitialProps({ query }) {
    if (!query.slug) return { error: true }
    if (!query.filename) return { error: true }

    const res = await getPhoto(query.slug, query.filename)
    console.log('got stuff:', res)
    return res
  }

  render() {
    const { classes, user, photo, error } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <div className={classes.container}>
          <img src={photo.url} className={classes.image} />
          <Typography className={classes.caption} variant="caption" color="inherit">
            {photo.caption}
          </Typography>
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Photo)
