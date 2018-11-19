import Head from 'next/head'
import { createMuiTheme } from '@material-ui/core/styles';
import orange from '@material-ui/core/colors/orange';
import CssBaseline from '@material-ui/core/CssBaseline';
import AppBar from 'components/AppBar'

const theme = createMuiTheme({
  typography: {
    useNextVariants: true
  },
  palette: {
    primary: {
      main: '#3949ab',
    },
    secondary: orange,
  },
})
const Layout = ({children}) => (
  <React.Fragment>
    <Head>
      <title>Robin's Photos</title>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" />
      <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
      <meta
        name="viewport"
        content="minimum-scale=1, initial-scale=1, width=device-width, shrink-to-fit=no"
      />
    </Head>
    <CssBaseline />
      <AppBar />
      {children}
    <CssBaseline />
  </React.Fragment>
)

export default Layout
