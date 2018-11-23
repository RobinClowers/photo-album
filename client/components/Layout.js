import React from 'react'
import AppBar from 'client/components/AppBar'


class Layout extends React.Component {
  render() {
    const {user, children} = this.props

    return (
      <React.Fragment>
        <AppBar user={user} />
        {children}
      </React.Fragment>
    )
  }
}

export default Layout
