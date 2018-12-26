import React from 'react'
import Head from 'next/head'
import Router from 'next/router';
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import Grid from '@material-ui/core/Grid'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import NarrowPaper from 'client/components/NarrowPaper'
import Section from 'client/components/Section'
import { Link } from 'client/routes'
import { getReturnUrl } from 'client/src/urls'
import { getUser, signUp } from 'client/src/api'

class SignUp extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      confirmationOpen: false,
      email: '',
      errors: {},
      password: '',
      password_confirmation: '',
    }
  }

  handleChange = field => event => {
    this.setState({ ...this.state, [field]: event.target.value })
  }

  static async getInitialProps({ req }) {
    return await getUser(req)
  }

  handleSignUp = async event => {
    event.preventDefault()
    const response = await signUp({
      email: this.state.email,
      password: this.state.password,
      password_confirmation: this.state.password_confirmation,
    })
    if (response.ok) {
      this.setState({ ...this.state, confirmationOpen: true })
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors })
    }
  }

  handleOkClick = event => {
    this.setState({ ...this.state, confirmationOpen: false })
    Router.push(getReturnUrl())
  }

  render() {
    const { user, classes } = this.props
    return (
      <Layout user={user}>
        {this.state.confirmationOpen &&
          <Dialog open={this.state.confirmationOpen}>
            <DialogContent>
              <DialogContentText>
                A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.
              </DialogContentText>
            </DialogContent>
            <DialogActions>
              <Button autoFocus color="primary" onClick={this.handleOkClick}>Ok</Button>
            </DialogActions>
          </Dialog>
        }
        <Grid container justify="center">
          <NarrowPaper>
            <form onSubmit={this.handleSignUp}>
              <Section>
                <Typography variant="h4" gutterBottom>Sign Up</Typography>
              </Section>
              <Section>
                <TextField
                  autoComplete="email"
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
                  autoComplete="new-password"
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
                  autoComplete="new-password"
                  error={!!this.state.errors.password_confirmation}
                  fullWidth
                  helperText={this.state.errors.password_confirmation}
                  label="Confirm Password"
                  margin="normal"
                  onChange={this.handleChange('password_confirmation')}
                  type="password"
                  value={this.state.password_confirmation}
                  variant="outlined" />
                <Grid container justify="flex-end">
                  <Button variant="contained" color="primary" type="submit">Sign up</Button>
                </Grid>
              </Section>
            </form>
            <Section centered>
              <Typography variant="body2">
                Or, if you already have an account
              </Typography>
            </Section>
            <Section centered fullWidth>
              <Link route="signIn" passHref>
                <Button component="a" fullWidth variant="contained">Sign in</Button>
              </Link>
            </Section>
          </NarrowPaper>
        </Grid>
      </Layout>
    )
  }
}

export default SignUp
