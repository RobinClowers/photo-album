import Error from 'next/error'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import ButtonBase from '@material-ui/core/ButtonBase'
import Icon from '@material-ui/core/Icon'
import { fade } from '@material-ui/core/styles/colorManipulator';
import Layout from 'client/components/Layout'
import { getPhoto } from 'client/src/api'
import { Link } from 'client/routes'
import debounce from 'lodash/debounce'

const headerHeight = 64
const captionHeight = 20

const button = theme => ({
  position: 'absolute',
  transform: 'translateY(-50%)',
  top: '50%',
  height: '100%',
  zIndex: 2,
  opacity: 0,
  transition: theme.transitions.create(
    'background-color', {
      duration: theme.transitions.duration.shortest,
    }
  ),
  width: '30%',
  '&:hover': {
    opacity: 1,
  },
})

const buttonIcon = {
  position: 'relative',
  fontSize: '2em',
}

const styles = theme => ({
  container: {
    textAlign: 'center',
  },
  photoContainer: {
    position: 'relative',
  },
  caption: {
    marginTop: 4,
  },
  image: {
    position: 'relative',
    left: '50%',
    transform: 'translateX(-50%)',
  },
  button: {
    borderRadius: '50%',
    color: theme.palette.common.white,
    padding: theme.spacing.unit * 2,
    transition: theme.transitions.create(
      'background-color', {
        duration: theme.transitions.duration.shortest,
      }
    ),
    backgroundColor: fade(theme.palette.action.active, theme.palette.action.hoverOpacity),
    // Reset on touch devices, it doesn't add specificity
    '@media (hover: none)': {
      backgroundColor: 'transparent',
    },
  },
  previousButton: {
    ...button(theme),
    left: 0,
  },
  buttonIconPrevious: {
    ...buttonIcon,
    left: '6px',
  },
  buttonIconNext: {
    ...buttonIcon,
    left: '2px',
  },
  nextButton: {
    ...button(theme),
    right: 0,
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

  componentDidUpdate({ photo }) {
    if (this.props.photo !== photo) {
      this.setState({ imageWidth: undefined, imageHeight: undefined })
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
    const {
      classes,
      user,
      photo,
      album,
      next_photo_filename,
      previous_photo_filename,
      error
    } = this.props

    if (error) {
      return <Error statusCode={500} />
    }

    return (
      <Layout user={user} pageContext={this.props.pageContext}>
        <div className={classes.container}>
          <div className={classes.photoContainer}>
            {previous_photo_filename &&
              <Link
                route='photo'
                params={{slug: album.slug, filename: previous_photo_filename}}>
                <ButtonBase className={classes.previousButton} aria-label="next" disableRipple={true}>
                  <div className={classes.button}>
                    <Icon className={classes.buttonIconPrevious}>arrow_back_ios</Icon>
                  </div>
                </ButtonBase>
              </Link>
            }
            <img
              style={{
                display: this.state.imageWidth ? 'block' : 'none',
                ...this.calculateImageDimensions(),
              }}
              ref={this.image}
              onLoad={this.imageLoaded}
              src={photo.url}
              className={classes.image} />
            {next_photo_filename &&
              <Link
                route='photo'
                params={{slug: album.slug, filename: next_photo_filename}}>
                <ButtonBase className={classes.nextButton} aria-label="next" disableRipple={true}>
                  <div className={classes.button}>
                    <Icon className={classes.buttonIconNext}>arrow_forward_ios</Icon>
                  </div>
                </ButtonBase>
              </Link>
            }
          </div>
          <Typography className={classes.caption} variant="caption" color="inherit">
            {photo.caption}
          </Typography>
        </div>
      </Layout>
    )
  }
}

export default withStyles(styles)(Photo)
