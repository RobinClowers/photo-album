import React from 'react'
import PropTypes from 'prop-types'
import Link from 'next/link'
import { withStyles } from '@material-ui/core/styles'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'
import { albumPath } from 'client/src/urls'

const styles = theme => ({
  paper: {
    textAlign: 'center',
    color: theme.palette.text.secondary,
    width: 240,
    overflow: 'hidden',
  },
  title: {
    padding: theme.spacing.unit,
    margin: 0,
  },
  image: {
    width: 240,
    height: 180,
    backgroundRepeat: 'no-repeat',
    backgroundPosition: 'center',
    backgroundSize: 'cover',
  },
})

function AlbumGrid({ classes, albums }) {
  return (
    <div style={{padding: 20}} >
      <Grid justify='center' container spacing={24}>
        {albums.map(album => (
          <Grid item key={album.id}>
            <Link href={albumPath(album.slug)}>
              <a>
                <Paper className={classes.paper}>
                  <div
                    title={album.cover_photo.alt}
                    style={{backgroundImage: `url(${album.cover_photo.urls.mobile_sm})`}}
                    className={classes.image} />
                  <h3 className={classes.title}>{album.title}</h3>
                </Paper>
              </a>
            </Link>
          </Grid>
        ))}
      </Grid>
    </div>
  )
}

AlbumGrid.propTypes = {
  classes: PropTypes.object.isRequired,
  albums: PropTypes.arrayOf(PropTypes.object).isRequired,
}

export default withStyles(styles)(AlbumGrid)
