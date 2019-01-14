import React from 'react'
import classNames from 'classnames'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import EditCaption from 'client/components/EditCaption'

const styles = theme => ({
  captionPadding: {
    paddingTop: theme.spacing.unit * 1.5, // match button
  },
  caption: {
    position: 'relative',
    width: '100%',
  },
})

class Caption extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      editCaption: false,
      topPadding: false,
    }
  }

  static defaultProps = {
    noWrap: false,
  }

  handleEditCaption = _event => {
    this.setState({ ...this.state, editCaption: true })
  }

  handleCaptionUpdated = () => {
    this.setState({ ...this.state, editCaption: false })
    this.props.handleCaptionUpdated()
  }

  render() {
    const { caption, photoId, user, classes, ...options } = this.props
    const { editCaption } = this.state
    const captionClasses = classNames({
      [classes.caption]: true,
      [classes.captionPadding]: options.topPadding,
    })

    return (
      <React.Fragment>
        {!editCaption &&
          <Typography noWrap={options.noWrap} className={captionClasses} variant="caption">
            {caption}
          </Typography>}
        {options.editable &&
          user.admin && !editCaption &&
            <IconButton
              aria-label="Edit"
              onClick={this.handleEditCaption}>
              <Icon>edit</Icon>
            </IconButton>}
          {editCaption &&
            <EditCaption
              photoId={photoId}
              initalValue={caption}
              handleCaptionUpdated={this.handleCaptionUpdated} />}
      </React.Fragment>
    )
  }
}

export default withStyles(styles)(Caption)
