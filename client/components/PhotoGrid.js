import { useState, useEffect } from 'react'
import debounce from 'lodash/debounce'
import justify from 'justified-layout'
import { withStyles } from '@material-ui/core/styles'
import PhotoGridItem from 'client/components/PhotoGridItem'
import LayoutOffset from 'client/src/LayoutOffset'

const gutter = 8 * 4

const styles = theme => ({
  container: {
    position: 'relative',
    margin: 0,
    [theme.breakpoints.up('sm')]: {
      marginLeft: gutter,
      marginRight: gutter,
    },
  },
})

const gridOptions = windowWidth => {
  if (windowWidth < 600) {
    return {
      containerWidth: windowWidth,
      containerPadding: 0,
    }
  }
  return {
    containerWidth: windowWidth - gutter * 2,
    containerPadding: 10,
  }
}

const metaHeight = 18

const buildGrid = (photos, windowWidth) => {
  const dimensions = photos.map(p => {
    const { original } = p.versions
    if (!original) return null
    return { height: original.height, width: original.width }
  })
  const result = justify(dimensions.filter(d => !!d), gridOptions(windowWidth))
  const layoutOffset = new LayoutOffset(metaHeight)
  return result.boxes.map((dimensions, i) => (
    layoutOffset.calculate(dimensions, photos[i])
  ))
}

const PhotoGrid = ({ photos, user, classes }) => {
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
          <PhotoGridItem {...item} user={user} key={item.photo.id} />
        ))
      :
        <div style={{display: 'none'}}>
          {buildGrid(photos, 1060).map(item => (
            <PhotoGridItem {...item} user={user} key={item.photo.id} />
          ))}
        </div>
      }
    </div>
  )
}

export default withStyles(styles)(PhotoGrid)
