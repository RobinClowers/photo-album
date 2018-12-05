import { withStyles } from '@material-ui/core/styles'
import ButtonBase from '@material-ui/core/ButtonBase'
import Icon from '@material-ui/core/Icon'
import { fade } from '@material-ui/core/styles/colorManipulator';
import { Link } from 'client/routes'

const button = theme => ({
  position: 'absolute',
  transform: 'translateY(-50%)',
  top: '50%',
  height: '100%',
  zIndex: 2,
  opacity: 0,
  transition: theme.transitions.create(
    'background-color', {
      duration: theme.transitions.duration.shortest,
    }
  ),
  width: '30%',
  '&:hover': {
    opacity: 1,
  },
})

const buttonIcon = {
  position: 'relative',
  fontSize: '2em',
}

const styles = theme => ({
  button: {
    borderRadius: '50%',
    color: theme.palette.common.white,
    padding: theme.spacing.unit * 2,
    transition: theme.transitions.create(
      'background-color', {
        duration: theme.transitions.duration.shortest,
      }
    ),
    backgroundColor: fade(theme.palette.action.active, theme.palette.action.hoverOpacity),
    // Reset on touch devices, it doesn't add specificity
    '@media (hover: none)': {
      backgroundColor: 'transparent',
    },
  },
  previousButton: {
    ...button(theme),
    left: 0,
  },
  buttonIconPrevious: {
    ...buttonIcon,
    left: '4px',
  },
  buttonIconNext: {
    ...buttonIcon,
    left: '2px',
  },
  nextButton: {
    ...button(theme),
    right: 0,
  },
})


const icon = variant => {
  if (variant === 'next') {
    return 'arrow_forward_ios'
  } else if (variant === 'previous') {
    return 'arrow_back_ios'
  }
}

const ChangePhotoButton = ({ variant, albumSlug, photoFilename, classes }) => (
  <Link
    route='photo'
    params={{slug: albumSlug, filename: photoFilename}}>
    <ButtonBase
      className={variant === 'next' ? classes.nextButton : classes.previousButton}
      aria-label={variant}
      disableRipple={true}>
      <div className={classes.button}>
        <Icon
          className={variant === 'next' ? classes.buttonIconNext : classes.buttonIconPrevious}>
          {icon(variant)}
        </Icon>
      </div>
    </ButtonBase>
  </Link>
)
export default withStyles(styles)(ChangePhotoButton)
