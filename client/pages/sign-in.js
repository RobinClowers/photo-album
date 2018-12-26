import React from 'react'
import Head from 'next/head'
import Button from '@material-ui/core/Button'
import FormHelperText from '@material-ui/core/FormHelperText'
import Grid from '@material-ui/core/Grid'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import Section from 'client/components/Section'
import NarrowPaper from 'client/components/NarrowPaper'
import FacebookLoginButton from 'client/components/FacebookLoginButton'
import { Link } from 'client/routes'
import { Router } from 'client/routes';
import { getUser, signIn } from 'client/src/api'

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
      Router.pushRoute('index')
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
              <Section centered fullWidth>
                <FacebookLoginButton />
              </Section>
              <Section centered>
                <Typography variant="body2">
                  Or
                </Typography>
              </Section>
              <Section>
                <TextField
                  autoFocus
                  style={{ marginTop: 0 }}
                  fullWidth
                  label="Email"
                  margin="normal"
                  onChange={this.handleChange('email')}
                  value={this.state.email}
                  variant="outlined" />
                <TextField
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
                Or, if havenʼt signed up yet
              </Typography>
            </Section>
            <Section centered fullWidth>
              <Link route='signUp'>
                <Button fullWidth variant="contained">Sign up</Button>
              </Link>
            </Section>
          </NarrowPaper>
        </Grid>
      </Layout>
    )
  }
}

export default SignIn
