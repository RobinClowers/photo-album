import React from 'react'
import PropTypes from 'prop-types'
import Document, { Head, Main, NextScript } from 'next/document'
import flush from 'styled-jsx/server'

class MyDocument extends Document {
  render() {
    const { pageContext } = this.props

    return (
      <html lang="en" dir="ltr">
        <Head>
          <meta charSet="utf-8" />
          {/* Use minimum-scale=1 to enable GPU rasterization */}
          <meta
            name="viewport"
            content="minimum-scale=1, initial-scale=1, width=device-width, shrink-to-fit=no"
          />
          {/* PWA primary color */}
          <meta name="theme-color" content={pageContext.theme.palette.primary.main} />
          <meta name="google-site-verification" content="Hxg_i311K6d-q0_vSMeQoH63c_kzbTmHaI9iUgw93MY" />
          {/* Material-UI styles */}
          <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" />
          <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
          <link href="/static/apple-touch-icon-57x57.png" rel="apple-touch-icon" sizes="57x57" />
          <link href="/static/apple-touch-icon-60x60.png" rel="apple-touch-icon" sizes="60x60" />
          <link href="/static/apple-touch-icon-72x72.png" rel="apple-touch-icon" sizes="72x72" />
          <link href="/static/apple-touch-icon-76x76.png" rel="apple-touch-icon" sizes="76x76" />
          <link href="/static/apple-touch-icon-114x114.png" rel="apple-touch-icon" sizes="114x114" />
          <link href="/static/apple-touch-icon-120x120.png" rel="apple-touch-icon" sizes="120x120" />
          <link href="/static/apple-touch-icon-144x144.png" rel="apple-touch-icon" sizes="144x144" />
          <link href="/static/apple-touch-icon-152x152.png" rel="apple-touch-icon" sizes="152x152" />
          <link href="/static/apple-touch-icon-180x180.png" rel="apple-touch-icon" sizes="180x180" />
          <link href="/static/favicon-32x32.png" rel="icon" sizes="32x32" type="image/png" />
          <link href="/static/android-chrome-192x192.png" rel="icon" sizes="192x192" type="image/png" />
          <link href="/static/favicon-96x96.png" rel="icon" sizes="96x96" type="image/png" />
          <link href="/static/favicon-16x16.png" rel="icon" sizes="16x16" type="image/png" />
          <style global jsx>{`
            a {
              text-decoration: none;
              color: inherit;
            }
          `}</style>
        </Head>
        <body>
          <Main />
          <NextScript />
        </body>
      </html>
    )
  }
}

MyDocument.getInitialProps = ctx => {
  // Resolution order
  //
  // On the server:
  // 1. app.getInitialProps
  // 2. page.getInitialProps
  // 3. document.getInitialProps
  // 4. app.render
  // 5. page.render
  // 6. document.render
  //
  // On the server with error:
  // 1. document.getInitialProps
  // 2. app.render
  // 3. page.render
  // 4. document.render
  //
  // On the client
  // 1. app.getInitialProps
  // 2. page.getInitialProps
  // 3. app.render
  // 4. page.render

  // Render app and page and get the context of the page with collected side effects.
  let pageContext
  const page = ctx.renderPage(Component => {
    const WrappedComponent = props => {
      pageContext = props.pageContext
      return <Component {...props} />
    }

    WrappedComponent.propTypes = {
      pageContext: PropTypes.object.isRequired,
    }

    return WrappedComponent
  })

  return {
    ...page,
    pageContext,
    // Styles fragment is rendered after the app and page rendering finish.
    styles: (
      <React.Fragment>
        <style
          id="jss-server-side"
          // eslint-disable-next-line react/no-danger
          dangerouslySetInnerHTML={{ __html: pageContext.sheetsRegistry.toString() }}
        />
        {flush() || null}
      </React.Fragment>
    ),
  }
}

export default MyDocument
