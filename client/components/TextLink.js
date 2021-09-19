import React from 'react'
import { withStyles } from '@material-ui/core/styles'
import { Link } from 'client/routes'

const styles = (theme => ({
  link: {
    color: theme.palette.primary.main,
  },
}))

const TextLink = React.forwardRef(({children, classes, ...linkProps}, ref) => {
  return (
    <Link {...linkProps}>
      <a ref={ref} className={classes.link}>
        {children}
      </a>
    </Link>
  )
})

export default withStyles(styles)(TextLink)
