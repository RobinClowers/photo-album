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

const ceiling = (num, ceiling) => (num > ceiling) ? ceiling : num

const byRatio = (initial, ratio) => Math.round(initial * ratio)

class Photo extends React.Component {
  constructor(props) {
    super(props)
    this.image = React.createRef()
    this.state = {
      maxWidth: undefined,
      maxHeight: undefined,
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
      maxWidth: global.innerWidth,
      maxHeight: global.innerHeight - headerHeight - captionHeight,
    })
  }

  calculateImageDimensions() {
    const { maxWidth } = this.state
    const imageElement = this.image.current
    if (!maxWidth || !imageElement) return undefined

    if (this.heightRatio() > this.widthRatio()) {
      return {
        width: byRatio(imageElement.width, this.widthRatio()),
        height: byRatio(imageElement.height, this.widthRatio()),
      }
    }
    return {
      width: byRatio(imageElement.width, this.heightRatio()),
      height: byRatio(imageElement.height, this.heightRatio()),
    }
  }

  heightRatio() {
    return ceiling(this.state.maxHeight / this.image.current.height, 1)
  }

  widthRatio() {
    return ceiling(this.state.maxWidth / this.image.current.width, 1)
  }

  render() {
    const { classes, user, photo, error } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <div className={classes.container}>
          <img
            style={{
              display: this.state.maxHeight ? 'block' : 'none',
              ...this.calculateImageDimensions(),
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
