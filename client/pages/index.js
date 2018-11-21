import fetch from 'isomorphic-unfetch'
import Layout from 'client/components/Layout'
import AlbumGrid from 'client/components/AlbumGrid'

export default class extends React.Component {
  static async getInitialProps(_context) {
    const res = await fetch('http://localhost:5000/', {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    })
    return await res.json()
  }

  render() {
    const { user, albums } = this.props
    return (
      <Layout user={user}>
        <AlbumGrid albums={this.props.albums} />
      </Layout>
    )
  }
}
