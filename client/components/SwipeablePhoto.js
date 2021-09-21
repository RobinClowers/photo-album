import React from 'react'
import { withStyles } from '@material-ui/core/styles'
import { useSwipeable } from 'react-swipeable'
import ChangePhotoButton from 'client/components/ChangePhotoButton'
import FullScreenPhoto from 'client/components/FullScreenPhoto'
import { Router } from 'client/routes'

const styles = theme => ({
  photoContainer: {
    position: 'relative',
  },
})

const SwipeablePhoto = ({
  classes,
  photo,
  albumSlug,
  nextPhotoFilename,
  previousPhotoFilename,
  topOffset,
}) => {
  const swipeable = useSwipeable({
    onSwipedLeft: (eventData) => {
      if (!nextPhotoFilename) return
      Router.pushRoute('photo', { slug: albumSlug, filename: nextPhotoFilename })
    },
    onSwipedRight: (eventData) => {
      if (!previousPhotoFilename) return
      Router.pushRoute('photo', { slug: albumSlug, filename: previousPhotoFilename })
    },
  })

  return (
    <div
      {...swipeable}
      className={classes.photoContainer}>
      {previousPhotoFilename &&
      <ChangePhotoButton
        variant="previous"
        albumSlug={albumSlug}
        photoFilename={previousPhotoFilename} />
      }
      <FullScreenPhoto
        photo={photo}
        topOffset={topOffset} />
      {nextPhotoFilename &&
      <ChangePhotoButton
        variant="next"
        albumSlug={albumSlug}
        photoFilename={nextPhotoFilename} />
      }
    </div>
  )
}

export default withStyles(styles)(SwipeablePhoto)
