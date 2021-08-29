import { useState } from 'react'
import PropTypes from 'prop-types'
import AppBar from '@material-ui/core/AppBar'
import Toolbar from '@material-ui/core/Toolbar'
import IconButton from '@material-ui/core/IconButton'
import Typography from '@material-ui/core/Typography'
import InputBase from '@material-ui/core/InputBase'
import Badge from '@material-ui/core/Badge'
import Popover from '@material-ui/core/Popover'
import PopupState, { bindTrigger, bindPopover } from 'material-ui-popup-state/index'
import MenuItem from '@material-ui/core/MenuItem'
import Menu from '@material-ui/core/Menu'
import { fade } from '@material-ui/core/styles/colorManipulator'
import { withStyles } from '@material-ui/core/styles'
import Icon from '@material-ui/core/Icon'
import MenuDrawer from 'client/components/MenuDrawer'
import { adminUrl } from 'client/src/urls'
import { signOut } from 'client/src/api'
import { Link } from 'client/routes'

const styles = theme => ({
  root: {
    width: '100%',
  },
  grow: {
    flexGrow: 1,
  },
  title: {
    display: 'none',
    [theme.breakpoints.up('sm')]: {
      display: 'block',
    },
  },
  menuButton: {
    marginLeft: 12,
    marginRight: 20,
  },
  search: {
    position: 'relative',
    borderRadius: theme.shape.borderRadius,
    backgroundColor: fade(theme.palette.common.white, 0.15),
    '&:hover': {
      backgroundColor: fade(theme.palette.common.white, 0.25),
    },
    marginRight: theme.spacing.unit * 2,
    marginLeft: 0,
    width: '100%',
    [theme.breakpoints.up('sm')]: {
      marginLeft: theme.spacing.unit * 3,
      width: 'auto',
    },
  },
  searchIcon: {
    width: theme.spacing.unit * 9,
    height: '100%',
    position: 'absolute',
    pointerEvents: 'none',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  profileImage: {
    height: 24,
    width: 24,
    borderRadius: 24,
  },
  inputRoot: {
    color: 'inherit',
    width: '100%',
  },
  inputInput: {
    paddingTop: theme.spacing.unit,
    paddingRight: theme.spacing.unit,
    paddingBottom: theme.spacing.unit,
    paddingLeft: theme.spacing.unit * 10,
    transition: theme.transitions.create('width'),
    width: '100%',
    [theme.breakpoints.up('md')]: {
      width: 200,
    },
  },
})

const searchKeyDown = (e) => {
  if (e.which === 13) {
    window.location = `https://www.google.com/search?q=site%3Aphotos.robinclowers.com&q=${e.target.value}`
  }
}

const handleSignOut = async _event => {
  if (await signOut()) {
    window.location.reload()
  }
}

const PrimarySearchAppBar = ({ user, openDrawer, classes }) => {
  return (
    <PopupState variant="popover" popupId="demo-popup-popover">
      {popupState => (
        <div className={classes.root}>
          <AppBar position="static">
            <Toolbar>
            <IconButton className={classes.menuButton} onClick={openDrawer} color="inherit" aria-label="Open drawer">
              <Icon>menu</Icon>
            </IconButton>
              <Link route='index'>
                <a>
                  <Typography className={classes.title} variant="h6" color="inherit" noWrap>
                    Robinʼs Photos
                  </Typography>
                </a>
              </Link>
              <div className={classes.search}>
                <div className={classes.searchIcon}>
                  <Icon>search</Icon>
                </div>
                <form action="https://google.com/search" method="get">
                  <InputBase
                    name="q"
                    type="hidden"
                    value="site:photos.robinclowers.com"
                  />
                  <InputBase
                    name="q"
                    placeholder="Search"
                    classes={{
                      root: classes.inputRoot,
                      input: classes.inputInput,
                    }}
                    onKeyDown={searchKeyDown}
                  />
                </form>
              </div>
              <div className={classes.grow} />
                <div>
                  <IconButton
                    aria-owns={popupState ? 'material-appbar' : undefined}
                    aria-haspopup="true"
                    color="inherit"
                    {...bindTrigger(popupState)}>
                    {user.id && user.profile_photo_url ?
                      <img
                        className={classes.profileImage}
                        src={user.profile_photo_url}
                        alt="profile photo" />
                      :
                      <Icon>account_circle</Icon>}
                  </IconButton>
                  <Popover {...bindPopover(popupState)}>
                    <div style={{padding: 20}}>
                      {user && user.id &&
                        <React.Fragment>
                          <Typography variant="h6">{user.name}</Typography>
                          {user.admin &&
                            <MenuItem component="a" href={adminUrl}>
                              Admin
                            </MenuItem>}
                            <Link route='changePassword'>
                              <MenuItem component="a">
                                Change Password
                              </MenuItem>
                            </Link>
                          <MenuItem component="a" onClick={handleSignOut}>Sign Out</MenuItem>
                        </React.Fragment>}
                      {!user || !user.id &&
                        <React.Fragment>
                          <Typography variant="h6">Welcome</Typography>
                          <Link route="signIn">
                            <MenuItem component="a">
                              Sign in
                            </MenuItem>
                          </Link>
                          <Link route="signUp">
                            <MenuItem component="a">
                              Sign up
                            </MenuItem>
                          </Link>
                        </React.Fragment>}
                    </div>
                  </Popover>
                </div>
            </Toolbar>
          </AppBar>
        </div>
      )}
    </PopupState>
  )
}

PrimarySearchAppBar.propTypes = {
  user: PropTypes.object,
  classes: PropTypes.object.isRequired,
}

export default withStyles(styles)(PrimarySearchAppBar)
