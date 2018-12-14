import { withStyles } from '@material-ui/core/styles'
import debounce from 'lodash/debounce'

const styles = theme => ({
  image: {
    position: 'relative',
    left: '50%',
    transform: 'translateX(-50%)',
  },
})

const ceiling = (num, ceiling) => (num > ceiling) ? ceiling : num

const byRatio = (initial, ratio) => Math.round(initial * ratio)

const maxWidth = () => global.innerWidth

const maxHeight = topOffset => global.innerHeight - topOffset

class FullScreenPhoto extends React.Component {
  constructor(props) {
    super(props)
    this.image = React.createRef()
    this.state = {
      imageWidth: undefined,
      imageHeight: undefined,
    }
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize, false)

    const element = this.image.current
    if (element && element.complete) {
        this.imageLoaded()
    }
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize, false)
  }

  componentDidUpdate({ photo_urls }) {
    if (this.props.photo_urls !== photo_urls) {
      this.setState({ imageWidth: undefined, imageHeight: undefined })
    }
  }

  handleResize = debounce(() => this.forceUpdate(), 20, false)

  imageLoaded = _event => {
    this.setState({
      imageWidth: this.image.current.width,
      imageHeight: this.image.current.height,
    })
  }

  calculateImageDimensions(topOffset) {
    const { imageWidth, imageHeight } = this.state
    if (!imageWidth) return undefined

    if (this.heightRatio(topOffset) > this.widthRatio()) {
      return {
        width: byRatio(imageWidth, this.widthRatio()),
        height: byRatio(imageHeight, this.widthRatio()),
      }
    }
    return {
      width: byRatio(imageWidth, this.heightRatio(topOffset)),
      height: byRatio(imageHeight, this.heightRatio(topOffset)),
    }
  }

  heightRatio(topOffset) {
    return ceiling(maxHeight(topOffset) / this.state.imageHeight, 1)
  }

  widthRatio() {
    return ceiling(maxWidth() / this.state.imageWidth, 1)
  }

  render() {
    const { photoUrls, topOffset, classes } = this.props

    return (
      <img
        style={{
          display: this.state.imageWidth ? 'block' : 'none',
          ...this.calculateImageDimensions(topOffset),
        }}
        ref={this.image}
        onLoad={this.imageLoaded}
        src={photoUrls.desktop}
        className={classes.image} />
    )
  }
}

export default withStyles(styles)(FullScreenPhoto)
