import { useState } from 'react'
import Card from '@material-ui/core/Card'
import CardContent from '@material-ui/core/CardContent'
import Fade from '@material-ui/core/Fade'
import Popper from '@material-ui/core/Popper'
import Typography from '@material-ui/core/Typography'

const FavoritesPopper = ({ favoriteNames, className, children, classes }) => {
  const [{ show, el }, updatePopper] = useState({ show: false, el: undefined })

  const handleMouseEnter = event => {
    updatePopper({ show: true, el: event.currentTarget })
  }

  const handleMouseLeave = event => {
    updatePopper({ show: false, el: undefined })
  }

  return (
    <div className={className} onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave}>
      {children}
      <Popper
        open={show}
        anchorEl={el}
        transition>
        {({ TransitionProps }) => (
          <Fade {...TransitionProps} timeout={350}>
            <Card>
              <CardContent>
                <Typography variant="body2">
                  {favoriteNames}
                </Typography>
              </CardContent>
            </Card>
          </Fade>
        )}
      </Popper>
    </div>
  )
}

export default FavoritesPopper
