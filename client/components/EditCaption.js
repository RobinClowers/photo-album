import React from 'react'
import { withStyles } from '@material-ui/core/styles'
import TextField from '@material-ui/core/TextField'
import FormControl from '@material-ui/core/FormControl'
import FormHelperText from '@material-ui/core/FormHelperText'
import Button from '@material-ui/core/Button'
import { updatePhoto } from 'client/src/api'

const styles = theme => ({
  container: {
    alignItems: 'flex-end',
    display: 'flex',
    flexDirection: 'column',
    width: '100%',
  },
  textField: {
    width: '100%',
  },
})

class EditCaption extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      caption: props.initalValue,
      errors: [],
    }
  }

  handleChange(fieldName) {
    return event => {
      this.setState({ ...this.state, [fieldName]: event.target.value })
    }
  }

  handleSubmit = async _event => {
    const response = await updatePhoto(this.props.photoId, {
      caption: this.state.caption,
    })
    if (response.ok) {
      this.setState({ errors: [], caption: '' })
      this.props.handleCaptionUpdated()
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors })
    }
  }

  handleKeyPress = async event => {
    if (event.which == 13 && event.shiftKey) {
      this.handleSubmit(event)
    }
  }

  render() {
    const { classes } = this.props

    return (
      <div className={classes.container}>
        <FormControl fullWidth error aria-describedby="component-error-text">
          <TextField
            autoFocus
            error={this.state.errors.length > 0}
            label="Add a caption"
            multiline
            rowsMax="4"
            value={this.state.caption}
            onChange={this.handleChange('caption')}
            onKeyPress={this.handleKeyPress}
            className={classes.textField}
            margin="normal"
            variant="outlined" />
          <FormHelperText id="component-error-text" error style={{ margin: 8 }}>
            {this.state.errors}
          </FormHelperText>
        </FormControl>
        <Button variant="contained" color="primary" onClick={this.handleSubmit}>
          Update
        </Button>
      </div>
    )
  }
}

export default withStyles(styles)(EditCaption)
