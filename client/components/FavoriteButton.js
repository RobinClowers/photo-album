import { useEffect, useState } from 'react'
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
  heartContainer: {
    marginLeft: theme.spacing.unit,
  },
  favoriteCount: {
    paddingLeft: theme.spacing.unit,
    paddingRight: theme.spacing.unit,
    display: 'inline',
  },
  userFavorite: {
    color: theme.palette.primary.main,
  },
})

const handleFavorite = (photo_id, current_user_favorite, user_id, updateShowPopper, updatePopperEl, onSuccess) =>
  async event => {
    if (!user_id) {
      updateShowPopper(true)
      updatePopperEl(event.currentTarget)
      return
    }
    if (current_user_favorite) {
      const result = await deleteFavorite(photo_id, current_user_favorite.id)
      if (result.ok) {
        onSuccess()
      }
    } else {
      const result = await createFavorite(photo_id)
      if (result.ok) {
        onSuccess()
      }
    }
  }

const FavoriteButton = ({ photo_id, favorites, user, onSuccess, classes}) => {
  const { current_user_favorite } = favorites
  const [showPopper, updateShowPopper] = useState(false)
  const [popperEl, updatePopperEl] = useState()
  const handleClick = () => updateShowPopper(false)
  useEffect(() => {
    window.addEventListener('click', handleClick, true)
    return () => {
      window.removeEventListener('click', handleClick, true)
    }
  })


  return (
    <div className={classes.heartContainer}>
      <Typography variant="body2" className={classes.favoriteCount}>
        {favorites.count}
      </Typography>
      <IconButton
        aria-label="Favorite"
        className={current_user_favorite && classes.userFavorite}
        onClick={handleFavorite(
          photo_id,
          current_user_favorite,
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

export default withStyles(styles)(FavoriteButton)
