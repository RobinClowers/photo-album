import CssBaseline from '@material-ui/core/CssBaseline';
import AppBar from 'client/components/AppBar'

const Layout = ({user, children}) => (
  <CssBaseline>
    <AppBar user={user} />
    {children}
  </CssBaseline>
)

export default Layout
