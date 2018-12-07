import Error from 'next/error'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import ChangePhotoButton from 'client/components/ChangePhotoButton'
import FullScreenPhoto from 'client/components/FullScreenPhoto'
import PhotoComments from 'client/components/PhotoComments'
import { getPhoto } from 'client/src/api'
import { Router } from 'client/routes'
import debounce from 'lodash/debounce'

const headerHeight = 64
const minMetaHeight = 48
const metaMargin = 8

const styles = theme => ({
  photoContainer: {
    position: 'relative',
  },
})

class Photo extends React.Component {
  static async getInitialProps({ req, query }) {
    if (!query.slug) return { error: true }
    if (!query.filename) return { error: true }

    return await getPhoto(query.slug, query.filename, req)
  }

  handleCommentAdded = () => {
    const { album, photo } = this.props
    Router.replaceRoute('photo', { slug: album.slug, filename: photo.filename })
  }

  render() {
    const {
      classes,
      user,
      photo,
      album,
      comments,
      next_photo_filename,
      previous_photo_filename,
      error
    } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <div>
          <div className={classes.photoContainer}>
            {previous_photo_filename &&
              <ChangePhotoButton
                variant="previous"
                albumSlug={album.slug}
                photoFilename={previous_photo_filename} />
            }
            <FullScreenPhoto
              photo_url={photo.url}
              topOffset={headerHeight + minMetaHeight + metaMargin} />
            {next_photo_filename &&
              <ChangePhotoButton
                variant="next"
                albumSlug={album.slug}
                photoFilename={next_photo_filename} />
            }
          </div>
          <PhotoComments
            comments={comments}
            photo={photo}
            user={user}
            handleCommentAdded={this.handleCommentAdded} />
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Photo)
