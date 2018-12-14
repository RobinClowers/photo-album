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
      isClient: false,
      imageLoaded: false,
    }
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize, false)
    this.setState({ ...this.state, isClient: true })

    const element = this.image.current
     if (element && element.complete) {
      this.setState({ isClient: true, imageLoaded: true })
     }
  }

  componentDidUpdate({ photo }) {
    if (this.props.photo !== photo) {
      this.setState({ ...this.state, imageLoaded: false })
    }
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize, false)
  }

  handleResize = debounce(() => this.forceUpdate(), 20, false)

  handleImageLoad = _event => {
    this.setState({ ...this.state, imageLoaded: true })
  }

  calculateImageDimensions(photo, topOffset) {
    if (!this.state.isClient) {
      return { display: 'none', }
    }
    const { width, height } = photo.versions.desktop
    if (this.heightRatio(topOffset) > this.widthRatio()) {
      return {
        display: this.state.imageLoaded ? 'block' : 'none',
        width: byRatio(width, this.widthRatio()),
        height: byRatio(height, this.widthRatio()),
      }
    }
    return {
      display: this.state.imageLoaded ? 'block' : 'none',
      width: byRatio(width, this.heightRatio(topOffset)),
      height: byRatio(height, this.heightRatio(topOffset)),
    }
  }

  heightRatio(topOffset) {
    return ceiling(maxHeight(topOffset) / this.props.photo.versions.desktop.height, 1)
  }

  widthRatio() {
    return ceiling(maxWidth() / this.props.photo.versions.desktop.width, 1)
  }

  render() {
    const { photo, topOffset, classes } = this.props
    const { urls, versions } = photo

    return (
      <img
        style={{ ...this.calculateImageDimensions(photo, topOffset) }}
        ref={this.image}
        onLoad={this.handleImageLoad}
        src={photo.urls.desktop}
        srcSet={Object.keys(versions).map(
          key => `${versions[key].url} ${versions[key].width}w`
        ).join(', ')}
        alt={photo.alt}
        className={classes.image} />
    )
  }
}

export default withStyles(styles)(FullScreenPhoto)
