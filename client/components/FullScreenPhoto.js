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
      showImage: true,
    }
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize, false)
    this.setState({ ...this.state, isClient: true })

    const element = this.image.current
     if (element && element.complete) {
      this.setState({ isClient: true, showImage: true })
     }
  }

  componentDidUpdate({ photo }) {
    if (this.props.photo !== photo) {
      this.setState({ ...this.state, showImage: false })
      global.setTimeout(this.handleTimeout, 20)
    }
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize, false)
  }

  handleResize = debounce(() => this.forceUpdate(), 20, false)

  handleTimeout = _event => {
    this.setState({ ...this.state, showImage: true })
  }

  calculateImageDimensions() {
    const { photo, topOffset } = this.props
    if (!this.state.isClient) {
      return { display: 'none', }
    }
    const { width, height } = photo.versions.original
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
    if (!this.state.isClient || !this.state.showImage) {
      return { display: 'none', }
    }
    return { display: 'block', }
  }

  heightRatio(topOffset) {
    return ceiling(maxHeight(topOffset) / this.props.photo.versions.original.height, 1)
  }

  widthRatio() {
    return ceiling(maxWidth() / this.props.photo.versions.original.width, 1)
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
          src={photo.urls.original}
          srcSet={Object.keys(versions).map(
            key => `${versions[key].url} ${versions[key].width}w`
          ).join(', ')}
          alt={photo.alt} />
      </div>
    )
  }
}

export default withStyles(styles)(FullScreenPhoto)
