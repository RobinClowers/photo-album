import Error from 'next/error'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import { getPhoto } from 'client/src/api'

const headerHeight = 64
const captionHeight = 20

const styles = theme => ({
  container: {
    textAlign: 'center',
  },
  caption: {
    marginTop: 4,
  },
  image: {
    position: 'relative',
    left: '50%',
    transform: 'translateX(-50%)',
  },
})

class Photo extends React.Component {
  constructor(props) {
    super(props)
    this.image = React.createRef()
    this.state = {
      windowHeight: undefined,
    }
  }

  static async getInitialProps({ query }) {
    if (!query.slug) return { error: true }
    if (!query.filename) return { error: true }

    const res = await getPhoto(query.slug, query.filename)
    return res
  }

  componentDidMount() {
    const element = this.image.current
    if (element && element.complete) {
        this.imageLoaded()
    }
  }

  imageLoaded = _event => {
    this.setState({
      windowHeight: global.innerHeight,
    })
  }

  render() {
    const { classes, user, photo, error } = this.props
    const { windowHeight } = this.state

    if (error) {
      return <Error statusCode={500} />
    }

    const height = windowHeight ?
      windowHeight - headerHeight - captionHeight : 'auto'

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <div className={classes.container}>
          <img
            style={{
              height,
              display: windowHeight ? 'block' : 'none',
            }}
            ref={this.image}
            onLoad={this.imageLoaded}
            src={photo.url}
            className={classes.image} />
          <Typography className={classes.caption} variant="caption" color="inherit">
            {photo.caption}
          </Typography>
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Photo)
