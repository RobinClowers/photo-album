import Typography from '@material-ui/core/Typography'
import { withStyles } from '@material-ui/core/styles'
import { facebookSignInUrl } from 'client/src/urls'

const styles = theme => ({
  container: {
    backgroundColor: theme.palette.grey[200],
    alignItems: 'center',
    justifyContent: 'center',
    display: 'flex',
    padding: theme.spacing.unit,
    width: '100%',
  },
  image: {
    width: '30px',
    marginRight: theme.spacing.unit,
  },
})

const FacebookLoginButton = ({ classes }) => (
  <a href={facebookSignInUrl} className={classes.container}>
    <img src="/static/fb-f-logo.png" className={classes.image} />
    <Typography variant="body2">
      Sign in with Facebook
    </Typography>
  </a>
)

export default withStyles(styles)(FacebookLoginButton)
