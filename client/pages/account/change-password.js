import Head from 'next/head'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import Grid from '@material-ui/core/Grid'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import NarrowPaper from 'client/components/NarrowPaper'
import Layout from 'client/components/Layout'
import { Router } from 'client/routes';
import { getUser, changePassword } from 'client/src/api'

class ChangePassword extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      current_password: '',
      errors: {},
      password: '',
      password_confirmation: '',
      passwordChanged: false,
    }
  }

  static async getInitialProps({ req, query }) {
    return await getUser(req)
  }

  handleChange = field => event => {
    this.setState({ ...this.state, [field]: event.target.value })
  }

  handleSubmit = async event => {
    event.preventDefault()
    const response = await changePassword({
      current_password: this.state.current_password,
      password: this.state.password,
      password_confirmation: this.state.password_confirmation,
    })
    if (response.ok) {
      this.setState({ ...this.state, errors: {}, passwordChanged: true })
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors })
    }
  }

  handleDismiss = _event => {
    Router.pushRoute('index')
  }

  render() {
    const { user } = this.props
    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <Head>
          <title>Change Password - Robinʼs Photos</title>
        </Head>
        {this.state.passwordChanged &&
          <Dialog open={this.state.passwordChanged}>
            <DialogContent>
              <DialogContentText>
                Your password has been changed successfully.
              </DialogContentText>
            </DialogContent>
            <DialogActions>
              <Button onClick={this.handleDismiss} color="primary" autoFocus>Ok</Button>
            </DialogActions>
          </Dialog>
        }
        <Grid container justify="center">
          <NarrowPaper>
            <Typography variant="h4" gutterBottom>
              Change password
            </Typography>
            <form onSubmit={this.handleSubmit}>
              <TextField
                autoFocus
                error={!!this.state.errors.current_password}
                fullWidth
                helperText={this.state.errors.current_password}
                label="Current password"
                margin="normal"
                onChange={this.handleChange('current_password')}
                type="password"
                value={this.state.current_password}
                variant="outlined" />
              <TextField
                error={!!this.state.errors.password}
                fullWidth
                helperText={this.state.errors.password}
                label="New password"
                margin="normal"
                onChange={this.handleChange('password')}
                type="password"
                value={this.state.password}
                variant="outlined" />
              <TextField
                error={!!this.state.errors.password_confirmation}
                fullWidth
                helperText={this.state.errors.password_confirmation}
                label="Confirm new password"
                margin="normal"
                onChange={this.handleChange('password_confirmation')}
                type="password"
                value={this.state.password_confirmation}
                variant="outlined" />
              <Grid container justify="flex-end">
                <Button color="primary" variant="contained" type="submit">
                  Change my password
                </Button>
              </Grid>
            </form>
          </NarrowPaper>
        </Grid>
      </Layout>
    )
  }
}

export default ChangePassword
