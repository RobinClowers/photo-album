import Link from 'next/link'
import { withStyles } from '@material-ui/core/styles'
import { photoPath } from 'client/src/urls'

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
    <Link href={photoPath(albumSlug, item.photo.filename)}>
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
