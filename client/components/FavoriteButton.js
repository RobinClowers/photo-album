import { useEffect, useState } from 'react'
import classNames from 'classnames'
import { withStyles } from '@material-ui/core/styles'
import Card from '@material-ui/core/Card'
import CardContent from '@material-ui/core/CardContent'
import Fade from '@material-ui/core/Fade'
import Icon from '@material-ui/core/Icon'
import IconButton from '@material-ui/core/IconButton'
import Popper from '@material-ui/core/Popper'
import Typography from '@material-ui/core/Typography'
import { createFavorite, deleteFavorite } from 'client/src/api'
import TextLink from 'client/components/TextLink'

const styles = theme => ({
  background: {
    backgroundColor: `${theme.palette.grey[900]}85`,
    borderRadius: 24,
  },
  heartContainer: {
    alignItems: 'center',
    display: 'flex',
    flexDirection: 'row',
    marginLeft: theme.spacing.unit,
  },
  favoriteCount: {
    padding: theme.spacing.unit * 1.5, // match IconButton
    paddingRight: theme.spacing.unit / 2,
    width: 24,
  },
  userFavorite: {
    color: theme.palette.primary.main,
  },
  white: {
    color: theme.palette.common.white,
  },
})

const handleFavorite = (photoId, currentUserFavorite, user_id, updateShowPopper, updatePopperEl, onSuccess) =>
  async event => {
    if (!user_id) {
      updateShowPopper(true)
      updatePopperEl(event.currentTarget)
      return
    }
    if (currentUserFavorite) {
      const result = await deleteFavorite(photoId, currentUserFavorite.id)
      if (result.ok) {
        onSuccess()
      }
    } else {
      const result = await createFavorite(photoId)
      if (result.ok) {
        onSuccess()
      }
    }
  }

const FavoriteButton = ({ photoId, favorites, user, onSuccess, classes, ...options}) => {
  const [showPopper, updateShowPopper] = useState(false)
  const [popperEl, updatePopperEl] = useState()
  const handleClick = () => updateShowPopper(false)
  useEffect(() => {
    window.addEventListener('click', handleClick, true)
    return () => {
      window.removeEventListener('click', handleClick, true)
    }
  })
  const containerClasses = classNames({
    [classes.heartContainer]: true,
    [classes.background]: options.invertColors,
  })
  const countClasses = classNames({
    [classes.favoriteCount]: true,
    [classes.white]: options.invertColors,
  })
  const buttonClasses = classNames({
    [classes.userFavorite]: favorites.current_user_favorite,
    [classes.white]: options.invertColors && !favorites.current_user_favorite,
  })

  return (
    <div className={containerClasses}>
      <Typography variant="body2" className={countClasses}>
        {favorites.count}
      </Typography>
      <IconButton
        aria-label="Favorite"
        className={buttonClasses}
        onClick={handleFavorite(
          photoId,
          favorites.current_user_favorite,
          user.id,
          updateShowPopper,
          updatePopperEl,
          onSuccess
        )}>
        <Icon>favorite</Icon>
      </IconButton>
      <Popper
        id={showPopper && 'sign-in-popper'}
        open={showPopper}
        anchorEl={popperEl}
        transition>
        {({ TransitionProps }) => (
          <Fade {...TransitionProps} timeout={350}>
            <Card>
              <CardContent>
                <Typography variant="body2">
                  <TextLink route='signIn'>
                    Sign in
                  </TextLink>
                  {' '}to add a favorite
                </Typography>
              </CardContent>
            </Card>
          </Fade>
        )}
      </Popper>
    </div>
  )
}

FavoriteButton.defaultOptions = {
  invertColors: false,
}

export default withStyles(styles)(FavoriteButton)
