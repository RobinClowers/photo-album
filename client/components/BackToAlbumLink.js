import React from 'react'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Icon from '@material-ui/core/Icon'
import { Link } from 'client/routes'

const styles = theme => ({
  link: {
    alignItems: 'center',
    cursor: 'pointer',
    display: 'flex',
    margin: theme.spacing.unit * 2, // match app bar gutter
    [theme.breakpoints.up('sm')]: {
      margin: theme.spacing.unit * 3, // match app bar gutter
      marginTop: theme.spacing.unit * 2,
      marginBottom: theme.spacing.unit * 2,
    },
  },
})

const BackToAlbumLink = ({ url, classes }) => (
  <Link route={url}>
    <Typography variant="body2" component="a" className={classes.link}>
      <Icon>arrow_back</Icon>
      Back to album
    </Typography>
  </Link>
)

export default withStyles(styles)(BackToAlbumLink)
