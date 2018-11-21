import CssBaseline from '@material-ui/core/CssBaseline';
import AppBar from 'components/AppBar'

const Layout = ({user, children}) => (
  <CssBaseline>
    <AppBar user={user} />
    {children}
  </CssBaseline>
)

export default Layout
