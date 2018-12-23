import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import DialogTitle from '@material-ui/core/DialogTitle'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import { signUp } from 'client/src/api'

class SignUp extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      errors: {},
    }
  }

  handleSignUp = async event => {
    event.preventDefault()
    const response = await signUp({
      email: document.getElementById('email').value,
      password: document.getElementById('password').value,
      password_confirmation: document.getElementById('password_confirmation').value
    })
    if (response.ok) {
      // Need to show flash message here
      window.location.reload()
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors })
    }
  }

  render() {
    const { open, cancel } = this.props
    return (
      <Dialog open={open} aria-labelledby="sign-in-dialog-title">
        <DialogTitle id="sign-in-dialog-title">Sign Up</DialogTitle>
        <form onSubmit={this.handleSignUp}>
          <DialogContent>
            <TextField
              autoFocus
              style={{ marginTop: 0 }}
              error={!!this.state.errors.email}
              fullWidth
              helperText={this.state.errors.email}
              id="email"
              label="Email"
              margin="normal"
              variant="outlined" />
            <TextField
              error={!!this.state.errors.password}
              fullWidth
              helperText={this.state.errors.password}
              id="password"
              label="Password"
              margin="normal"
              type="password"
              variant="outlined" />
            <TextField
              error={!!this.state.errors.password_confirmation}
              fullWidth
              helperText={this.state.errors.password_confirmation}
              id="password_confirmation"
              label="Confirm Password"
              margin="normal"
              type="password"
              variant="outlined" />
          </DialogContent>
          <DialogActions>
            <Button onClick={cancel}>Cancel</Button>
            <Button type="submit">Submit</Button>
          </DialogActions>
        </form>
      </Dialog>
    )
  }
}

export default SignUp
