import justify from 'justified-layout'
import PhotoGridItem from 'client/components/PhotoGridItem'
import { withStyles } from '@material-ui/core/styles'
import debounce from 'lodash/debounce'

const gutter = 8 * 4

const styles = theme => ({
  container: {
    position: 'relative',
    marginLeft: gutter,
    marginRight: gutter,
  },
})

const buildGrid = (photos, width = global.innerWidth - gutter * 2) => {
  const dimensions = photos.map(p => {
    const { original } = p.versions
    return { height: original.height, width: original.width }
  })
  const result = justify(dimensions, { containerWidth: width })
  return result.boxes.map((box, i) => ({ ...box, photo: photos[i] }))
}

class PhotoGrid extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      isClient: false,
    }
  }

  componentDidMount() {
    this.setState({ ...this.state, isClient: true })
    window.addEventListener('resize', this.handleResize, false)
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize, false)
  }

  handleResize = debounce(() => this.forceUpdate(), 20, false)

  render() {
    const { photos, albumSlug, classes } = this.props

    return (
      <div className={classes.container}>
        {this.state.isClient ?
          buildGrid(photos).map(item => (
            <PhotoGridItem item={item} albumSlug={albumSlug} key={item.photo.id} />
          ))
        :
          <div style={{display: 'none'}}>
            {buildGrid(photos, 1060).map(item => (
              <PhotoGridItem item={item} albumSlug={albumSlug} key={item.photo.id} />
            ))}
          </div>
        }
      </div>
    )
  }
}
export default withStyles(styles)(PhotoGrid)
