import { withStyles } from '@material-ui/core/styles'
import debounce from 'lodash/debounce'

const styles = theme => ({
  imageContainer: {
    position: 'relative',
    left: '50%',
    transform: 'translateX(-50%)',
  },
  image: {
    width: '100%',
    height: '100%'
  }
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

  calculateImageDimensions() {
    const { photo, topOffset } = this.props
    if (!this.state.isClient) {
      return { display: 'none', }
    }
    const { width, height } = photo.versions.desktop
    if (this.heightRatio(topOffset) > this.widthRatio()) {
      return {
        width: byRatio(width, this.widthRatio()),
        height: byRatio(height, this.widthRatio()),
      }
    }
    return {
      width: byRatio(width, this.heightRatio(topOffset)),
      height: byRatio(height, this.heightRatio(topOffset)),
    }
  }

  showPhoto() {
    if (!this.state.isClient || !this.state.imageLoaded) {
      return { display: 'none', }
    }
    return { display: 'block', }
  }

  heightRatio(topOffset) {
    return ceiling(maxHeight(topOffset) / this.props.photo.versions.desktop.height, 1)
  }

  widthRatio() {
    return ceiling(maxWidth() / this.props.photo.versions.desktop.width, 1)
  }

  render() {
    const { photo, classes } = this.props
    const { urls, versions } = photo

    return (
      <div
        className={classes.imageContainer}
        style={{ ...this.calculateImageDimensions() }}>
        <img
          style={{ ...this.showPhoto() }}
          className={classes.image}
          ref={this.image}
          onLoad={this.handleImageLoad}
          src={photo.urls.desktop}
          srcSet={Object.keys(versions).map(
            key => `${versions[key].url} ${versions[key].width}w`
          ).join(', ')}
          alt={photo.alt} />
      </div>
    )
  }
}

export default withStyles(styles)(FullScreenPhoto)
