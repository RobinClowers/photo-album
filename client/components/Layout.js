import Head from 'next/head'

const Layout = ({children}) => (
  <div>
    <Head>
      <title>Robin's Photos</title>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" />
      <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
      <meta
        name="viewport"
        content="minimum-scale=1, initial-scale=1, width=device-width, shrink-to-fit=no"
      />
    </Head>
    {children}
  </div>
)

export default Layout
