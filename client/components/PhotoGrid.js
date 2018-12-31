import { useState, useEffect } from 'react'
import justify from 'justified-layout'
import PhotoGridItem from 'client/components/PhotoGridItem'
import { withStyles } from '@material-ui/core/styles'
import debounce from 'lodash/debounce'

const gutter = 8 * 4

const styles = theme => ({
  container: {
    position: 'relative',
    marginLeft: gutter,
    marginRight: gutter,
  },
})

const gridWidth = windowWidth => {
  if (windowWidth < 425) {
    return windowWidth
  }
  return windowWidth - gutter * 2
}

const buildGrid = (photos, windowWidth) => {
  const dimensions = photos.map(p => {
    const { original } = p.versions
    return { height: original.height, width: original.width }
  })
  const result = justify(dimensions, { containerWidth: gridWidth(windowWidth) })
  return result.boxes.map((box, i) => ({ ...box, photo: photos[i] }))
}

const PhotoGrid = ({ photos, albumSlug, classes }) => {
  const [isClient, updateIsClient] = useState(false)
  useEffect(() => {
    updateIsClient(true)
    window.addEventListener('resize', handleResize, false)
    return () => {
      window.removeEventListener('resize', handleResize, false)
    }
  }, [])

  const [windowWidth, updateWindowWidth] = useState()
  useEffect(() => {
    updateWindowWidth(window.innerWidth)
  }, [])

  const handleResize = debounce(() => updateWindowWidth(window.innerWidth), 20, false)

  return (
    <div className={classes.container}>
      {isClient ?
        buildGrid(photos, windowWidth).map(item => (
          <PhotoGridItem item={item} albumSlug={albumSlug} key={item.photo.id} />
        ))
      :
        <div style={{display: 'none'}}>
          {buildGrid(photos, 1060).map(item => (
            <PhotoGridItem item={item} albumSlug={albumSlug} key={item.photo.id} />
          ))}
        </div>
      }
    </div>
  )
}

export default withStyles(styles)(PhotoGrid)
