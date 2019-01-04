import React from 'react'
import Head from 'next/head'
import Error from 'next/error'
import Swipe from 'react-easy-swipe'
import { withStyles } from '@material-ui/core/styles'
import Layout from 'client/components/Layout'
import BackToAlbumLink from 'client/components/BackToAlbumLink'
import ChangePhotoButton from 'client/components/ChangePhotoButton'
import FullScreenPhoto from 'client/components/FullScreenPhoto'
import PhotoComments from 'client/components/PhotoComments'
import { getPhoto, createFavorite, deleteFavorite } from 'client/src/api'
import { Router } from 'client/routes'
import debounce from 'lodash/debounce'

const headerHeight = 64
const backLinkHeight = 56
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

  constructor(props) {
    super(props)
    this.state = {
      editCaption: false,
      showSignInPopper: false,
      signInPopperEl: undefined,
      caption: props.caption,
    }
  }

  componentDidMount() {
    window.addEventListener('click', this.handleClick, true)
  }

  componentWillUnmount() {
    window.removeEventListener('click', this.handleClick, true)
  }

  handleClick = event => {
    if (this.state.showSignInPopper) {
      this.setState({ showSignInPopper: false, signInPopperEl: undefined })
    }
  }

  handleCommentAdded = () => {
    const { album, photo } = this.props
    this.refresh()
  }

  refreshOnSuccess = result => result.ok && this.refresh()

  refresh = () => {
    const { album, photo } = this.props
    Router.replaceRoute('photo', { slug: album.slug, filename: photo.filename })
  }

  handleFavorite = async event => {
    if (!this.props.user.id) {
      this.setState({ showSignInPopper: true, signInPopperEl: event.currentTarget })
      return
    }
    const photo_id = this.props.photo.id
    const { current_user_favorite } = this.props.photo.favorites
    if (current_user_favorite) {
      this.refreshOnSuccess(await deleteFavorite(photo_id, current_user_favorite.id))
    } else {
      this.refreshOnSuccess(await await createFavorite(photo_id))
    }
  }

  handleCaptionUpdated = _event => {
    const { album, photo } = this.props
    Router.pushRoute('photo', { slug: album.slug, filename: photo.filename })
  }

  handleSwipeLeft = (pos, event) => {
    const { album, next_photo_filename } = this.props
    Router.pushRoute('photo', { slug: album.slug, filename: next_photo_filename })
  }

  handleSwipeRight = (pos, event) => {
    const { album, previous_photo_filename } = this.props
    Router.pushRoute('photo', { slug: album.slug, filename: previous_photo_filename })
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
        <Head>
          <title>{`${album.title} photo`}</title>
          <meta property="title" content={`Photo from ${album.title}`} />
          <meta property="description" content={photo.caption || `A photo from ${album.title}.`} />
          <meta property="og:title" content={`Photo from ${album.title}`} />
          <meta property="og:description" content={photo.caption || `A photo from ${album.title}.`} />
          <meta property="og:url" content={`${process.env.FRONT_END_ROOT}/albums/${album.slug}/${photo.filename}`} />
          <meta property="og:image" content={photo.urls.original} />
          <meta property="og:image:secure_url" content={photo.urls.original} />
          <meta property="og:image:width" content={photo.versions.original.width} />
          <meta property="og:image:height" content={photo.versions.original.height} />
        </Head>
        <BackToAlbumLink url={`/albums/${album.slug}`} />
        <Swipe
          onSwipeLeft={this.handleSwipeLeft}
          onSwipeRight={this.handleSwipeRight}
          className={classes.photoContainer}>
          {previous_photo_filename &&
            <ChangePhotoButton
              variant="previous"
              albumSlug={album.slug}
              photoFilename={previous_photo_filename} />
          }
          <FullScreenPhoto
            photo={photo}
            topOffset={headerHeight + backLinkHeight + minMetaHeight + metaMargin} />
          {next_photo_filename &&
            <ChangePhotoButton
              variant="next"
              albumSlug={album.slug}
              photoFilename={next_photo_filename} />
          }
        </Swipe>
        <PhotoComments
          comments={comments}
          photo={photo}
          user={user}
          handleCommentAdded={this.handleCommentAdded}
          handleCaptionUpdated={this.handleCaptionUpdated}
          showSignInPopper={this.state.showSignInPopper}
          signInPopperEl={this.state.signInPopperEl}
          handleFavorite={this.handleFavorite} />
      </Layout>
    )
  }
}

export default withStyles(styles)(Photo)
