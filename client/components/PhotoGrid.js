import { useState, useEffect } from 'react'
import justify from 'justified-layout'
import PhotoGridItem from 'client/components/PhotoGridItem'
import { withStyles } from '@material-ui/core/styles'
import debounce from 'lodash/debounce'

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

const metaHeight = 64

const buildGrid = (photos, windowWidth) => {
  var firstRowTop, currentRowTop, currentHeightOffset
  const dimensions = photos.map(p => {
    const { original } = p.versions
    return { height: original.height, width: original.width }
  })
  const result = justify(dimensions, gridOptions(windowWidth))
  var updated, firstRowTop, currentRowTop, currentHeightOffset
  return result.boxes.map((dimensions, i) => {
    [firstRowTop, currentRowTop, currentHeightOffset] =
      calculateOffset(dimensions, firstRowTop, currentRowTop, currentHeightOffset)
    dimensions.top = dimensions.top + currentHeightOffset
    dimensions.imageHeight = dimensions.height
    dimensions.height = dimensions.height + metaHeight
    return {
      photo: photos[i],
      dimensions,
    }
  })
}

const calculateOffset = (dimensions, firstRowTop, currentRowTop, currentHeightOffset = 0) => {
  // First call sets the top row, current row and offset
  if (!firstRowTop) {
    return [dimensions.top, dimensions.top, 0]
  }
  // First row item
  if (dimensions.top == firstRowTop) {
    return [firstRowTop, currentRowTop, currentHeightOffset]
  }
  // First item in a new row
  if (dimensions.top != currentRowTop) {
    return [firstRowTop, dimensions.top, currentHeightOffset + metaHeight]
  }
  // Additional item in row
  return [firstRowTop, dimensions.top, currentHeightOffset]
}

const PhotoGrid = ({ photos, albumSlug, user, classes }) => {
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
          <PhotoGridItem {...item} user={user} albumSlug={albumSlug} key={item.photo.id} />
        ))
      :
        <div style={{display: 'none'}}>
          {buildGrid(photos, 1060).map(item => (
            <PhotoGridItem {...item} user={user} albumSlug={albumSlug} key={item.photo.id} />
          ))}
        </div>
      }
    </div>
  )
}

export default withStyles(styles)(PhotoGrid)
