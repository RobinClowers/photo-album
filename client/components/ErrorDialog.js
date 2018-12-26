import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import DialogTitle from '@material-ui/core/DialogTitle'

const ErrorDialog = ({ open, error, dismiss }) => (
  <Dialog open={open} aria-labelledby="email-confirmed-dialog-title">
    <DialogTitle id="error-dialog-title">
        An error occured
      </DialogTitle>
      <DialogContent>
        <DialogContentText>
          {error}
        </DialogContentText>
      </DialogContent>
    <DialogActions>
      <Button autoFocus color="primary" onClick={dismiss}>Ok</Button>
    </DialogActions>
  </Dialog>
)

export default ErrorDialog
