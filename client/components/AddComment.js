import { withStyles } from '@material-ui/core/styles'
import TextField from '@material-ui/core/TextField'
import FormControl from '@material-ui/core/FormControl'
import FormHelperText from '@material-ui/core/FormHelperText'
import Button from '@material-ui/core/Button'
import { postComment } from 'client/src/api'

const styles = theme => ({
  container: {
    alignItems: 'flex-end',
    display: 'flex',
    flexDirection: 'column',
    padding: theme.spacing.unit,
    width: '100%',
  },
  textField: {
    width: '100%',
  },
})

class AddComment extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      comment: '',
      errors: [],
    }
  }

  handleChange(fieldName) {
    return event => {
      this.setState({ ...this.state, [fieldName]: event.target.value })
    }
  }

  handleSubmit = async event => {
    const response = await postComment(this.props.photo_id, {
      body: this.state.comment,
    })
    if (response.ok) {
      this.setState({ errors: [], comment: '' })
      this.props.handleCommentAdded()
    } else {
      const body = await response.json()
      this.setState({ ...this.state, errors: body.errors })
    }
  }

  render() {
    const { classes } = this.props

    return (
      <div className={classes.container}>
        <FormControl fullWidth error aria-describedby="component-error-text">
          <TextField
            error={this.state.errors.length > 0}
            label="Add a comment"
            multiline
            rowsMax="4"
            value={this.state.comment}
            onChange={this.handleChange('comment')}
            className={classes.textField}
            margin="normal"
            variant="outlined" />
          <FormHelperText id="component-error-text" error style={{ margin: 8 }}>
            {this.state.errors}
          </FormHelperText>
        </FormControl>
        <Button variant="contained" color="primary" onClick={this.handleSubmit}>
          Post
        </Button>
      </div>
    )
  }
}

export default withStyles(styles)(AddComment)
