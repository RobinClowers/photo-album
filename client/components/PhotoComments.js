import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Card from '@material-ui/core/Card'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import CardContent from '@material-ui/core/CardContent'
import Popper from '@material-ui/core/Popper'
import Paper from '@material-ui/core/Paper'
import Fade from '@material-ui/core/Fade'
import Caption from 'client/components/Caption'
import AddComment from 'client/components/AddComment'
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
    paddingLeft: theme.spacing.unit * 2,
  },
  caption: {
    paddingTop: theme.spacing.unit * 1.5, // match button
    position: 'relative',
  },
  heartContainer: {
    marginLeft: theme.spacing.unit,
  },
  favoriteCount: {
    paddingLeft: theme.spacing.unit,
    paddingRight: theme.spacing.unit,
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
  cardContent: {
    display: 'flex',
  },
  profileImage: {
    height: 50,
    width: 50,
    marginRight: theme.spacing.unit,
  },
  userFavorite: {
    color: theme.palette.primary.main,
  },
})

const PhotoComments = ({ comments, photo, user, classes, ...props}) => (
  <div className={classes.commentContainer}>
    <div className={classes.meta}>
      <Caption
        photo_id={photo.id}
        caption={photo.caption}
        user={user}
        handleCaptionUpdated={props.handleCaptionUpdated} />
      <div className={classes.heartContainer}>
        <Typography variant="body2" className={classes.favoriteCount}>
          {photo.favorites.count}
        </Typography>
        <IconButton
          className={photo.favorites.current_user_favorite && classes.userFavorite}
          aria-label="Favorite" onClick={props.handleFavorite}>
          <Icon>favorite</Icon>
        </IconButton>
        <Popper
          id={props.showSignInPopper ? 'sign-in-popper' : undefined}
          open={props.showSignInPopper}
          anchorEl={props.signInPopperEl}
          transition>
          {({ TransitionProps }) => (
            <Fade {...TransitionProps} timeout={350}>
              <Card>
                <CardContent>
                  <Typography variant="body2">
                    <TextLink route='signIn'>
                      Sign in
                    </TextLink>
                    {' '}to add a favorite
                  </Typography>
                </CardContent>
              </Card>
            </Fade>
          )}
        </Popper>
      </div>
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
