import React from 'react'
import App from 'next/app'
import Head from 'next/head'
import { MuiThemeProvider } from '@material-ui/core/styles'
import CssBaseline from '@material-ui/core/CssBaseline'
import JssProvider from 'react-jss/lib/JssProvider'
import getPageContext from 'client/src/getPageContext'
import { setReturnUrl } from 'client/src/urls'
import { setCsrfCookie } from 'client/src/cookies'
import ReactGA from 'react-ga'


const initializeGoogleAnalytics = () => {
  if (!process.env.GA_TRACKING_ID) {
    console.log("Google Analytics disabled")
    return
  }
  ReactGA.initialize(process.env.GA_TRACKING_ID, { debug: process.env.DEBUG_GA })
  ReactGA.pageview(window.location.pathname + window.location.search)
}

class MyApp extends App {
  constructor(props) {
    super(props)
    this.pageContext = getPageContext()
  }

  componentDidMount() {
    // Make the CSRF token available
    setCsrfCookie(this.props.pageProps.csrfToken)
    setReturnUrl(window.location.pathname)
    // Remove the server-side injected CSS.
    const jssStyles = document.querySelector('#jss-server-side')
    if (jssStyles && jssStyles.parentNode) {
      jssStyles.parentNode.removeChild(jssStyles)
    }
    initializeGoogleAnalytics()
  }

  render() {
    const { Component, pageProps } = this.props
    return (
      <>
        <Head>
          <title>Robinʼs Photos</title>
        </Head>
        {/* Wrap every page in Jss and Theme providers */}
        <JssProvider
          registry={this.pageContext.sheetsRegistry}
          generateClassName={this.pageContext.generateClassName}
        >
          {/* MuiThemeProvider makes the theme available down the React
              tree thanks to React context. */}
          <MuiThemeProvider
            theme={this.pageContext.theme}
            sheetsManager={this.pageContext.sheetsManager}
          >
            {/* CssBaseline kickstart an elegant, consistent, and simple baseline to build upon. */}
            <CssBaseline />
            {/* Pass pageContext to the _document though the renderPage enhancer
                to render collected styles on server side. */}
            <Component pageContext={this.pageContext} {...pageProps} />
          </MuiThemeProvider>
        </JssProvider>
      </>
    )
  }
}

export default MyApp
