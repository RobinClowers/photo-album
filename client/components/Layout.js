import { useRef, useState, useEffect } from 'react'
import Portal from '@material-ui/core/Portal'
import Typography from '@material-ui/core/Typography'
import classNames from 'classnames'
import CircularProgress from '@material-ui/core/CircularProgress'
import { withStyles } from '@material-ui/core/styles'
import AppBar from 'client/components/AppBar'
import MenuDrawer, { drawerWidth }  from 'client/components/MenuDrawer'
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

const Layout = ({ user, children, classes }) => {
  const [appLoading, updateAppLoading] = useState(false)
  const subscription = useRef()
  useEffect(() => {
    bindRouterStateChange(subscription, loading => updateAppLoading(loading))
    return () => {
      unbindRouterStateChange(subscription)
    }
  }, [])

  const [drawerOpen, updateDrawerOpen] = useState(false)
  const handleDrawerOpen = () => {
    updateDrawerOpen(true)
  }
  const handleDrawerClose = () => {
    updateDrawerOpen(false)
  }

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
      <AppBar user={user} openDrawer={handleDrawerOpen} />
      {children}
      <MenuDrawer user={user} open={drawerOpen} close={handleDrawerClose} />
    </React.Fragment>
  )
}

export default withStyles(styles)(Layout)
