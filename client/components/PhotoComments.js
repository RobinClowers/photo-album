import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Card from '@material-ui/core/Card'
import CardContent from '@material-ui/core/CardContent'
import Caption from 'client/components/Caption'
import AddComment from 'client/components/AddComment'
import FavoriteButton from 'client/components/FavoriteButton'
import TextLink from 'client/components/TextLink'

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
  },
  caption: {
    paddingTop: theme.spacing.unit * 1.5, // match button
    position: 'relative',
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
  cardContent: {
    display: 'flex',
  },
  profileImage: {
    height: 50,
    width: 50,
    marginRight: theme.spacing.unit,
  },
})

const PhotoComments = ({ comments, photo, user, classes, ...props}) => (
  <div className={classes.commentContainer}>
    <div className={classes.meta}>
      <Caption
        editable
        photo_id={photo.id}
        caption={photo.caption}
        user={user}
        handleCaptionUpdated={props.handleCaptionUpdated} />
      <FavoriteButton
        photo_id={photo.id}
        favorites={photo.favorites}
        onSuccess={props.handleFavorite}
        user={user} />
    </div>
  <ul className={classes.commentList}>
    {comments.map(comment => (
      <li className={classes.commentListItem} key={comment.id}>
        <Card className={classes.card}>
          <CardContent className={classes.cardContent}>
            <img
              className={classes.profileImage}
              src={comment.user_profile_photo_url}
              alt="profile photo" />
            <div>
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
      {user.id ?
        <AddComment photo_id={photo.id} handleCommentAdded={props.handleCommentAdded} />
        :
        <Card className={classes.card}>
          <CardContent>
            <Typography variant="body2">
              <TextLink route="signIn">
                Sign in
              </TextLink>
              {' '}to leave a comment
            </Typography>
          </CardContent>
        </Card>
      }
    </li>
  </ul>
  </div>
)

export default withStyles(styles)(PhotoComments)
