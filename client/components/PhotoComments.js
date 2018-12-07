import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Card from '@material-ui/core/Card'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import CardContent from '@material-ui/core/CardContent'
import AddComment from 'client/components/AddComment'

const styles = theme => ({
  commentContainer: {
    left: '50%',
    position: 'relative',
    transform: 'translateX(-50%)',
    marginTop: theme.spacing.unit,
    width: '100%',
    [theme.breakpoints.only('sm')]: {
      width: 600,
    },
    [theme.breakpoints.only('md')]: {
      width: 800,
    },
    [theme.breakpoints.up('lg')]: {
      width: 1024,
    },
  },
  meta: {
    alignItems: 'start',
    display: 'flex',
    justifyContent: 'space-between',
    paddingLeft: theme.spacing.unit * 2,
  },
  caption: {
    paddingTop: theme.spacing.unit * 1.5, // match button
  },
  heartContainer: {
  },
  favoriteCount: {
    marginLeft: theme.spacing.unit,
    marginRight: theme.spacing.unit,
    display: 'inline',
  },
  commentList: {
    alignItems: 'center',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    listStyleType: 'none',
    paddingInlineStart: 0,
    marginTop: theme.spacing.unit,
    width: '100%',
  },
  commentListItem: {
    display: 'flex',
    marginBottom: theme.spacing.unit,
    width: '100%',
  },
  card: {
    textAlign: 'left',
    width: '100%',
  },
  commentRight: {
    paddingLeft: 50 + theme.spacing.unit,
  },
  profileImage: {
    height: 50,
    width: 50,
    float: 'left',
    marginRight: theme.spacing.unit,
  },
})

const PhotoComments = ({ comments, photo, user, handleCommentAdded, classes }) => (
  <div className={classes.commentContainer}>
    <div className={classes.meta}>
      <Typography className={classes.caption} variant="caption">
        {photo.caption}
      </Typography>
      <div className={classes.heartContainer}>
        <Typography variant="body2" className={classes.favoriteCount}>
          {photo.favorites.count}
        </Typography>
        <IconButton>
          <Icon>favorite</Icon>
        </IconButton>
      </div>
    </div>
  <ul className={classes.commentList}>
    {comments.map(comment => (
      <li className={classes.commentListItem} key={comment.id}>
        <Card className={classes.card}>
          <CardContent>
            <img
              className={classes.profileImage}
              src={comment.user_profile_photo_url}
              alt="profile photo" />
            <div className={classes.commentRight}>
              <Typography variant="subtitle2">
                {comment.user_name}
              </Typography>
              <Typography variant="body2" component="p" gutterBottom>
                {comment.body}
              </Typography>
            </div>
          </CardContent>
        </Card>
      </li>
    ))}
    <li className={classes.commentListItem}>
      <AddComment photo_id={photo.id} handleCommentAdded={handleCommentAdded} />
    </li>
  </ul>
  </div>
)

export default withStyles(styles)(PhotoComments)
