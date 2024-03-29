import React from 'react'
import Head from 'next/head'
import Router from 'next/router';
import Button from '@material-ui/core/Button'
import FormHelperText from '@material-ui/core/FormHelperText'
import Grid from '@material-ui/core/Grid'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import Section from 'client/components/Section'
import NarrowPaper from 'client/components/NarrowPaper'
import { Link } from 'client/routes'
import { getReturnUrl } from 'client/src/urls'
import { setCsrfCookie } from 'client/src/cookies'
import { getUser, signIn, csrfTokenFromHeader } from 'client/src/api'

class SignIn extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      email: '',
      error: undefined,
      password: '',
    }
  }

  static async getInitialProps({ req }) {
    return await getUser(req)
  }

  handleChange = field => event => {
    this.setState({ ...this.state, [field]: event.target.value })
  }

  handleSignIn = async event => {
    event.preventDefault()
    const response = await signIn(
      this.state.email,
      this.state.password,
    )
    if (response.ok) {
      const data = await response.json()
      const csrfToken = csrfTokenFromHeader(response)
      setCsrfCookie(csrfToken)
      Router.push(getReturnUrl())
    } else {
      const body = await response.json()
      this.setState({ ...this.state, error: body.error })
    }
  }

  render() {
    const { user } = this.props
    return (
      <Layout user={user}>
        <Grid container justify="center">
          <NarrowPaper>
            <form onSubmit={this.handleSignIn}>
              <Section>
                <Typography variant="h4" gutterBottom>Sign In</Typography>
              </Section>
              <Section>
                <TextField
                  autoComplete="email"
                  autoFocus
                  style={{ marginTop: 0 }}
                  fullWidth
                  label="Email"
                  margin="normal"
                  onChange={this.handleChange('email')}
                  value={this.state.email}
                  variant="outlined" />
                <TextField
                  autoComplete="password"
                  fullWidth
                  id="password"
                  label="Password"
                  margin="normal"
                  onChange={this.handleChange('password')}
                  type="password"
                  value={this.state.password}
                  variant="outlined" />
                {this.state.error &&
                  <FormHelperText error={true}>
                    {this.state.error}
                  </FormHelperText>
                  }
                <Grid container justify="space-between">
                  <Link route='forgotPassword'>
                    <Button>
                      Forgot Password?
                    </Button>
                  </Link>
                  <Button variant="contained" color="primary" type="submit">Sign in</Button>
                </Grid>
              </Section>
            </form>
            <Section centered>
              <Typography variant="body2">
                Or, if you havenʼt signed up yet
              </Typography>
            </Section>
            <Section centered fullWidth>
              <Link route='signUp' passHref>
                <Button component="a" fullWidth variant="contained">Sign up</Button>
              </Link>
            </Section>
          </NarrowPaper>
        </Grid>
      </Layout>
    )
  }
}

export default SignIn
