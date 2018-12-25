import { withStyles } from '@material-ui/core/styles'

const styles = theme => ({
  section: {
    padding: `${theme.spacing.unit * 2}px ${theme.spacing.unit}px`,
  },
})

const Section = ({ children, classes }) => (
  <div className={classes.section}>
    {children}
  </div>
)

export default withStyles(styles)(Section)
