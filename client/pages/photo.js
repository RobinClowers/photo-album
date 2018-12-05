import Error from 'next/error'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import ChangePhotoButton from 'client/components/ChangePhotoButton'
import FullScreenPhoto from 'client/components/FullScreenPhoto'
import { getPhoto } from 'client/src/api'
import debounce from 'lodash/debounce'

const headerHeight = 64
const captionHeight = 20

const styles = theme => ({
  container: {
    textAlign: 'center',
  },
  photoContainer: {
    position: 'relative',
  },
  caption: {
    marginTop: 4,
  },
})

class Photo extends React.Component {
  static async getInitialProps({ req, query }) {
    if (!query.slug) return { error: true }
    if (!query.filename) return { error: true }

    return await getPhoto(query.slug, query.filename, req)
  }

  render() {
    const {
      classes,
      user,
      photo,
      album,
      next_photo_filename,
      previous_photo_filename,
      error
    } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <div className={classes.container}>
          <div className={classes.photoContainer}>
            {previous_photo_filename &&
              <ChangePhotoButton
                variant="previous"
                albumSlug={album.slug}
                photoFilename={previous_photo_filename} />
            }
            <FullScreenPhoto
              photo_url={photo.url}
              topOffset={headerHeight + captionHeight} />
            {next_photo_filename &&
              <ChangePhotoButton
                variant="next"
                albumSlug={album.slug}
                photoFilename={next_photo_filename} />
            }
          </div>
          <Typography className={classes.caption} variant="caption" color="inherit">
            {photo.caption}
          </Typography>
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Photo)
