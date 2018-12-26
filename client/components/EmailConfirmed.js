import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import DialogTitle from '@material-ui/core/DialogTitle'

const EmailConfirmed = ({ open, error, dismiss }) => (
  <Dialog open={open} aria-labelledby="email-confirmed-dialog-title">
    <DialogTitle id="email-confirmed-dialog-title">
          {error ? 'An error occured' : 'Email Confirmed'}
      </DialogTitle>
      <DialogContent>
        <DialogContentText>
          {error ? error : 'Your email address has been successfully confirmed.'}
        </DialogContentText>
      </DialogContent>
    <DialogActions>
      <Button autoFocus color="primary" onClick={dismiss}>Ok</Button>
    </DialogActions>
  </Dialog>
)

export default EmailConfirmed
