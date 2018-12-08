import React from 'react'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import EditCaption from 'client/components/EditCaption'

const styles = theme => ({
  caption: {
    paddingTop: theme.spacing.unit * 1.5, // match button
    position: 'relative',
    width: '100%',
  },
})

class Caption extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      editCaption: false,
    }
  }

  handleEditCaption = _event => {
    this.setState({ ...this.state, editCaption: true })
  }

  handleCaptionUpdated = () => {
    this.setState({ ...this.state, editCaption: false })
    this.props.handleCaptionUpdated()
  }

  render() {
    const { caption, photo_id, user, classes } = this.props
    const { editCaption } = this.state

    return (
      <React.Fragment>
        {!editCaption &&
          <Typography className={classes.caption} variant="caption">
            {caption}
          </Typography>}
        {user.admin && !editCaption &&
          <IconButton
            aria-label="Edit"
            onClick={this.handleEditCaption}>
            <Icon>edit</Icon>
          </IconButton>}
        {editCaption &&
          <EditCaption
            photo_id={photo_id}
            initalValue={caption}
            handleCaptionUpdated={this.handleCaptionUpdated} />}
      </React.Fragment>
    )
  }
}

export default withStyles(styles)(Caption)
