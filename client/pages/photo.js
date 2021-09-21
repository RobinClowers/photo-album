import React from 'react'
import Head from 'next/head'
import Error from 'next/error'
import Layout from 'client/components/Layout'
import BackToAlbumLink from 'client/components/BackToAlbumLink'
import PhotoComments from 'client/components/PhotoComments'
import { getPhoto } from 'client/src/api'
import { Router } from 'client/routes'
import SwipeablePhoto from 'client/components/SwipeablePhoto'
import debounce from 'lodash/debounce'

const headerHeight = 64
const backLinkHeight = 56
const minMetaHeight = 48
const metaMargin = 8

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
      caption: props.caption,
    }
  }

  handleCommentAdded = () => {
    const { album, photo } = this.props
    this.refresh()
  }

  refresh = () => {
    const { album, photo } = this.props
    Router.replaceRoute('photo', { slug: album.slug, filename: photo.filename })
  }

  handleCaptionUpdated = _event => {
    const { album, photo } = this.props
    Router.pushRoute('photo', { slug: album.slug, filename: photo.filename })
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
        <SwipeablePhoto
          previousPhotoFilename={previous_photo_filename}
          nextPhotoFilename={next_photo_filename}
          albumSlug={album.slug}
          photo={photo}
          topOffset={headerHeight + backLinkHeight + minMetaHeight + metaMargin} />
        <PhotoComments
          comments={comments}
          photo={photo}
          user={user}
          handleCommentAdded={this.handleCommentAdded}
          handleCaptionUpdated={this.handleCaptionUpdated}
          handleFavorite={this.refresh} />
      </Layout>
    )
  }
}

export default Photo
