import { withStyles } from '@material-ui/core/styles'
import { Link } from 'client/routes'

const styles = theme => ({
  photo: {
    backgroundColor: theme.palette.primary.light,
    position: 'absolute',
    textAlign: 'center',
    whiteSpace: 'nowrap',
  },
})

const PhotoGridItem = ({ albumSlug, item, classes }) => {
  const { versions } = item.photo

  return (
    <Link
      route='photo'
      params={{slug: albumSlug, filename: item.photo.filename}}>
      <a>
        <img
          style={{
            top: item.top,
            left: item.left,
            height: item.height,
            width: item.width,
          }}
          className={classes.photo}
          srcSet={Object.keys(versions).map(
            key => `${versions[key].url} ${versions[key].width}w`
          ).join(', ')}
          sizes={`${item.width}px`}
          src={item.photo.urls.mobile_sm}
          alt={item.photo.alt} />
      </a>
    </Link>
  )
}

export default withStyles(styles)(PhotoGridItem)
