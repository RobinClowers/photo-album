import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import { withStyles } from '@material-ui/core/styles'
import { facebookSignInUrl } from 'client/src/urls'

const styles = theme => ({
  image: {
    width: 21,
    marginRight: theme.spacing.unit,
  },
})

const handleClick = event => {
  event.preventDefault()
  window.location.replace(facebookSignInUrl())
}

const FacebookLoginButton = ({ classes }) => (
  <Button fullWidth variant="contained" onClick={handleClick}>
    <img src="/static/fb-f-logo.png" className={classes.image} />
    <Typography variant="body2">
      Sign in with Facebook
    </Typography>
  </Button>
)

export default withStyles(styles)(FacebookLoginButton)
