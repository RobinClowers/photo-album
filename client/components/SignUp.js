import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import DialogTitle from '@material-ui/core/DialogTitle'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import { signUp } from 'client/src/api'

class SignUp extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      email: '',
      errors: {},
      password: '',
      password_confirmation: '',
      registrationSucceeded: false,
    }
  }

  handleChange = field => event => {
    this.setState({ ...this.state, [field]: event.target.value })
  }

  handleSignUp = async event => {
    event.preventDefault()
    const response = await signUp({
      email: this.state.email,
      password: this.state.password,
      password_confirmation: this.state.password_confirmation,
    })
    if (response.ok) {
      this.setState({ ...this.state, registrationSucceeded: true })
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors })
    }
  }

  render() {
    const { open, dismiss } = this.props
    return (
      <Dialog open={open} aria-labelledby="sign-in-dialog-title">
        <DialogTitle id="sign-in-dialog-title">Sign Up</DialogTitle>
        {this.state.registrationSucceeded ?
          <React.Fragment>
            <DialogContent>
              <DialogContentText>
                A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.
              </DialogContentText>
            </DialogContent>
            <DialogActions>
              <Button autoFocus color="primary" onClick={dismiss}>Ok</Button>
            </DialogActions>
          </React.Fragment>
          :
          <form onSubmit={this.handleSignUp}>
            <DialogContent>
              <TextField
                autoFocus
                style={{ marginTop: 0 }}
                error={!!this.state.errors.email}
                fullWidth
                helperText={this.state.errors.email}
                label="Email"
                margin="normal"
                onChange={this.handleChange('email')}
                value={this.state.email}
                variant="outlined" />
              <TextField
                error={!!this.state.errors.password}
                fullWidth
                helperText={this.state.errors.password}
                label="Password"
                margin="normal"
                onChange={this.handleChange('password')}
                type="password"
                value={this.state.password}
                variant="outlined" />
              <TextField
                error={!!this.state.errors.password_confirmation}
                fullWidth
                helperText={this.state.errors.password_confirmation}
                label="Confirm Password"
                margin="normal"
                onChange={this.handleChange('password_confirmation')}
                type="password"
                value={this.state.password_confirmation}
                variant="outlined" />
            </DialogContent>
            <DialogActions>
              <Button onClick={dismiss}>Cancel</Button>
              <Button type="submit">Submit</Button>
            </DialogActions>
          </form>
        }
      </Dialog>
    )
  }
}

export default SignUp
