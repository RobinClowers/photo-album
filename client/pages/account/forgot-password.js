import Head from 'next/head'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import Grid from '@material-ui/core/Grid'
import Paper from '@material-ui/core/Paper'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import { withStyles } from '@material-ui/core/styles'
import Layout from 'client/components/Layout'
import { Router } from 'client/routes';
import { getUser, sendPasswordReset } from 'client/src/api'

const styles = theme => ({
  paper: {
    marginTop: theme.spacing.unit * 2,
    padding: theme.spacing.unit * 2,
    width: '100%',
    [theme.breakpoints.up('sm')]: {
      width: 600,
    },
  },
})

class ForgotPassword extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      errors: {},
      emailSent: false,
    }
  }

  static async getInitialProps({ req, query }) {
    return await getUser(req)
  }

  handleSubmit = async event => {
    event.preventDefault()
    const response = await sendPasswordReset(document.getElementById("email").value)
    if (response.ok) {
      this.setState({ ...this.state, errors: {}, emailSent: true })
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors})
    }
  }

  handleDismiss = _event => {
    Router.pushRoute('index')
  }

  render() {
    const { user, classes } = this.props
    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <Head>
          <title>Forgot Password - Robin&#700;s Photos</title>
        </Head>
        {this.state.emailSent &&
          <Dialog open={this.state.emailSent}>
            <DialogContent>
              <DialogContentText>
                You will receive an email with instructions for how to reset your password shortly.
              </DialogContentText>
            </DialogContent>
            <DialogActions>
              <Button onClick={this.handleDismiss} color="primary" autoFocus>Ok</Button>
            </DialogActions>
          </Dialog>
        }
        <Grid container justify="center">
          <Paper className={classes.paper}>
            <Typography variant="h4" gutterBottom>
              Forgot your password?
            </Typography>
            <Typography variant="body2" gutterBottom>
              Enter your email and we will send you instructions to reset your password.
            </Typography>
            <form onSubmit={this.handleSubmit}>
              <TextField
                autoFocus
                error={!!this.state.errors.email}
                fullWidth
                helperText={this.state.errors.email}
                id="email"
                label="Email"
                margin="normal"
                variant="outlined" />
              <Grid container justify="flex-end">
                <Button color="primary" variant="contained" type="submit">
                  Reset password
                </Button>
              </Grid>
            </form>
          </Paper>
        </Grid>
      </Layout>
    )
  }
}

export default withStyles(styles)(ForgotPassword)
