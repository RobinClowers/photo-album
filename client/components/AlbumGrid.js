import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'

const styles = theme => ({
  paper: {
    textAlign: 'center',
    color: theme.palette.text.secondary,
    whiteSpace: 'nowrap',
    overflow: 'hidden',
  },
  title: {
    padding: theme.spacing.unit,
    margin: 0,
  },
  image: {
    width: 320,
    height: 240,
  },
})

function AlbumGrid({ classes, albums }) {
  return (
    <div style={{padding: 20}} >
      <Grid justify='center' container spacing={24}>
        {albums.map(album => (
          <Grid item key={album.id}>
            <Paper className={classes.paper}>
              <img src={album.cover_photo.url} className={classes.image} />
              <h3 className={classes.title}>{album.title}</h3>
            </Paper>
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