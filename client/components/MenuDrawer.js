import Drawer from '@material-ui/core/Drawer'
import Divider from '@material-ui/core/Divider'
import List from '@material-ui/core/List'
import ListItem from '@material-ui/core/ListItem'
import ListItemIcon from '@material-ui/core/ListItemIcon'
import ListItemText from '@material-ui/core/ListItemText'
import Icon from '@material-ui/core/Icon'
import IconButton from '@material-ui/core/IconButton'
import { withStyles } from '@material-ui/core/styles'
import { adminUrl } from 'client/src/urls'
import { Link } from 'client/routes'

export const drawerWidth = 240

const styles = theme => ({
  drawer: {
    width: drawerWidth,
    flexShrink: 0,
  },
  paper: {
    width: drawerWidth,
  },
  header: {
    display: 'flex',
    alignItems: 'center',
    padding: '0 8px',
    ...theme.mixins.toolbar,
    justifyContent: 'flex-end',
  },
})

const ListItemLink = props => (
  <ListItem button component="a" {...props} />
)

const MenuDrawer = ({ user, open, close, classes }) => {
  return (
    <Drawer
      className={classes.drawer}
      variant="persistent"
      anchor="left"
      open={open}
      classes={{
        paper: classes.paper,
      }}>
      <div className={classes.header}>
        <IconButton onClick={close}>
          <Icon>chevron_left</Icon>
        </IconButton>
      </div>
      <Divider />
      <List>
        <Link route='index' passHref>
          <ListItemLink>
            <ListItemIcon>
              <Icon>home</Icon>
            </ListItemIcon>
            <ListItemText primary="Home" />
          </ListItemLink>
        </Link>
        <Link route='favorites' passHref>
          <ListItemLink>
            <ListItemIcon>
              <Icon>favorite</Icon>
            </ListItemIcon>
            <ListItemText primary="Favorites" />
          </ListItemLink>
        </Link>
        {user.admin &&
          <ListItemLink href={adminUrl}>
            <ListItemIcon>
              <Icon>settings</Icon>
            </ListItemIcon>
            <ListItemText primary="Admin" />
          </ListItemLink>}
      </List>
    </Drawer>
  )
}

export default withStyles(styles)(MenuDrawer)
