import Paper from '@material-ui/core/Paper'
import { withStyles } from '@material-ui/core/styles'

const styles = theme => ({
  paper: {
    marginTop: theme.spacing.unit * 2,
    padding: theme.spacing.unit * 2,
    maxWidth: 600,
  },
})

const NarrowPaper = ({ children, classes }) => (
  <Paper className={classes.paper}>
    {children}
  </Paper>
)

export default withStyles(styles)(NarrowPaper)
