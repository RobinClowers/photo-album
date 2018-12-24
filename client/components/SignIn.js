import React from 'react'
import Dialog from '@material-ui/core/Dialog'
import DialogTitle from '@material-ui/core/DialogTitle'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import DialogActions from '@material-ui/core/DialogActions'
import Grid from '@material-ui/core/Grid'
import TextField from '@material-ui/core/TextField'
import FormHelperText from '@material-ui/core/FormHelperText'
import Button from '@material-ui/core/Button'
import { Link } from 'client/routes'
import { signIn } from 'client/src/api'

class SignIn extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      error: undefined,
    }
  }

  handleSignIn = async event => {
    event.preventDefault()
    const response = await signIn(
      document.getElementById("email").value,
      document.getElementById("password").value
    )
    if (response.ok) {
      window.location.reload()
    } else {
      const body = await response.json()
      this.setState({ ...this.state, error: body.error })
    }
  }

  render() {
    const { open, dismiss, signUp } = this.props
    return (
      <Dialog open={open} aria-labelledby="sign-in-dialog-title">
        <DialogTitle id="sign-in-dialog-title">Sign In</DialogTitle>
        <form onSubmit={this.handleSignIn}>
          <DialogContent>
            <TextField
              autoFocus
              style={{ marginTop: 0 }}
              fullWidth
              id="email"
              label="Email"
              margin="normal"
              variant="outlined" />
            <TextField
              fullWidth
              id="password"
              label="Password"
              margin="normal"
              type="password"
              variant="outlined" />
            {this.state.error &&
              <FormHelperText error={true}>
                {this.state.error}
              </FormHelperText>
            }
          <DialogContentText>
            Or, if haven't signed up yet:
            <Button onClick={signUp}>Create account</Button>
          </DialogContentText>
          </DialogContent>
          <DialogActions>
            <Grid container justify="flex-start">
              <Link route='forgotPassword'>
                <Button >
                  Forgot Password?
                </Button>
              </Link>
            </Grid>
            <Button onClick={dismiss}>Cancel</Button>
            <Button color="primary" type="submit">Submit</Button>
          </DialogActions>
        </form>
      </Dialog>
    )
  }
}

export default SignIn
