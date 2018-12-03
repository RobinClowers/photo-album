import Error from 'next/error'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Layout from 'client/components/Layout'
import { getPhoto } from 'client/src/api'
import debounce from 'lodash/debounce'

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

const maxWidth = () => global.innerWidth

const maxHeight = () => global.innerHeight - headerHeight - captionHeight

class Photo extends React.Component {
  constructor(props) {
    super(props)
    this.image = React.createRef()
    this.state = {
      imageWidth: undefined,
      imageHeight: undefined,
    }
  }

  static async getInitialProps({ query }) {
    if (!query.slug) return { error: true }
    if (!query.filename) return { error: true }

    const res = await getPhoto(query.slug, query.filename)
    return res
  }

  componentDidMount() {
    window.addEventListener(
      'resize',
      debounce(() => this.forceUpdate(), 20, false),
      false)

    const element = this.image.current
    if (element && element.complete) {
        this.imageLoaded()
    }
  }

  imageLoaded = _event => {
    this.setState({
      imageWidth: this.image.current.width,
      imageHeight: this.image.current.height,
    })
  }

  calculateImageDimensions() {
    const { imageWidth, imageHeight } = this.state
    if (!imageWidth) return undefined

    if (this.heightRatio() > this.widthRatio()) {
      return {
        width: byRatio(imageWidth, this.widthRatio()),
        height: byRatio(imageHeight, this.widthRatio()),
      }
    }
    return {
      width: byRatio(imageWidth, this.heightRatio()),
      height: byRatio(imageHeight, this.heightRatio()),
    }
  }

  heightRatio() {
    return ceiling(maxHeight() / this.state.imageHeight, 1)
  }

  widthRatio() {
    return ceiling(maxWidth() / this.state.imageWidth, 1)
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
              display: this.state.imageWidth ? 'block' : 'none',
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
