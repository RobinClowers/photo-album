import { withStyles } from '@material-ui/core/styles'

const styles = theme => ({
  section: {
    padding: `${theme.spacing.unit * 2}px ${theme.spacing.unit}px`,
  },
  fullWidth: {
    width: '100%',
  },
  centered: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
})

const containerClasses = (classes, fullWidth, centered) =>
  [
    classes.section,
    centered && classes.centered,
    fullWidth && classes.fullWidth,
  ].join(' ')

const Section = ({ centered, fullWidth, children, classes }) => (
  <div className={(centered && classes.centered)}>
    <div
      className={containerClasses(classes, fullWidth, centered)}>
      {children}
    </div>
  </div>
)

export default withStyles(styles)(Section)
