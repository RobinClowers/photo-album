import React from 'react'
import { withStyles } from '@material-ui/core/styles'
import { Link } from 'client/routes'

const styles = (theme => ({
  link: {
    color: theme.palette.primary.main,
  },
}))

const TextLink = ({children, classes, ...linkProps}) => {
  return (
    <Link  {...linkProps}>
      <a className={classes.link}>
        {children}
      </a>
    </Link>
  )
}

export default withStyles(styles)(TextLink)
