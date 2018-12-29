import React from 'react'
import Link from 'next/link'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Icon from '@material-ui/core/Icon'
import { albumPath } from 'client/src/urls'

const styles = theme => ({
  link: {
    alignItems: 'center',
    display: 'flex',
    margin: theme.spacing.unit * 2, // match app bar gutter
    [theme.breakpoints.up('sm')]: {
      margin: theme.spacing.unit * 3, // match app bar gutter
      marginTop: theme.spacing.unit * 2,
      marginBottom: theme.spacing.unit * 2,
    },
  },
})

const BackToAlbumLink = ({ slug, classes }) => (
  <Link href={albumPath(slug)}>
    <a>
      <Typography variant="body2" className={classes.link}>
        <Icon>arrow_back</Icon>
        Back to album
      </Typography>
    </a>
  </Link>
)

export default withStyles(styles)(BackToAlbumLink)
