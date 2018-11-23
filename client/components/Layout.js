import React from 'react'
import Portal from '@material-ui/core/Portal'
import Typography from '@material-ui/core/Typography'
import CircularProgress from '@material-ui/core/CircularProgress'
import { withStyles } from '@material-ui/core/styles'
import AppBar from 'client/components/AppBar'
import { bindRouterStateChange, unbindRouterStateChange }
  from 'client/src/routerStateChange'

const styles = theme => ({
  loadingIndicator: {
    position: 'fixed',
    top: '15px',
    right: 0,
    left: 0,

    backgroundColor: theme.palette.primary.dark,
    borderRadius: '4px',
    color: '#fff',
    margin: '0 auto',
    padding: '8px',
    textAlign: 'center',
    width: '140px',
    height: '35px',
  },
  loading: {
    fontFamily: 'Roboto',
    marginRight: '10px',
    verticalAlign: 'top',
  },
})

class Layout extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      appLoading: false,
    }
  }

  componentDidMount() {
    bindRouterStateChange(this, loading => this.setState({appLoading: loading}))
  }

  componentWillUnmount() {
    unbindRouterStateChange(this)
  }

  render() {
    const {user, children, classes} = this.props
    const { appLoading } = this.state

    return (
      <React.Fragment>
        <Portal>
        {appLoading &&
          <div className={classes.loadingIndicator}>
            <span className={classes.loading}>
              Loading
            </span>
            <CircularProgress color="secondary" size={20} />
          </div>
        }
        </Portal>
        <AppBar user={user} />
        {children}
      </React.Fragment>
    )
  }
}

export default withStyles(styles)(Layout)
