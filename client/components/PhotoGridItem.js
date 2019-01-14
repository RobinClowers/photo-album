import { withStyles } from '@material-ui/core/styles'
import { Link, Router } from 'client/routes'
import Caption from 'client/components/Caption'
import FavoriteButton from 'client/components/FavoriteButton'

const styles = theme => ({
  container: {
    display: 'flex',
    flexDirection: 'column',
    position: 'absolute',
    whiteSpace: 'nowrap',
  },
  favoriteContainer: {
    position: 'absolute',
    right: 10,
    bottom: 10,
  },
  link: {
    backgroundColor: theme.palette.primary.light,
    display: 'flex',
    position: 'relative',
  },
  meta: {
    display: 'flex',
    height: 18,
    marginTop: 0,
  },
})

const PhotoGridItem = ({ albumSlug, user, photo, dimensions, classes }) => {
  const { versions, favorites } = photo
  const handleFavorite = () => {
    Router.replaceRoute('album', { slug: albumSlug })
  }

  return (
    <div
      className={classes.container}
      style={{
        top: dimensions.top,
        left: dimensions.left,
        height: dimensions.height,
        width: dimensions.width,
      }}>
      <Link
        route='photo'
        params={{slug: albumSlug, filename: photo.filename}}>
        <a className={classes.link} style={{height: dimensions.imageHeight}}>
          <img
            srcSet={Object.keys(versions).map(
              key => `${versions[key].url} ${versions[key].width}w`
            ).join(', ')}
            sizes={`${dimensions.width}px`}
            src={photo.urls.mobile_sm}
            alt={photo.alt} />
          <div className={classes.favoriteContainer}>
            <FavoriteButton
              invertColors
              photoId={photo.id}
              favorites={favorites}
              onSuccess={handleFavorite}
              user={user} />
          </div>
        </a>
      </Link>
      {photo.caption && (
        <div className={classes.meta}>
          <Caption
            caption={photo.caption}
            noWrap
            photoId={photo.id}
            user={user} />
        </div>)}
    </div>
  )
}

export default withStyles(styles)(PhotoGridItem)
