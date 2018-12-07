import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import Card from '@material-ui/core/Card'
import CardContent from '@material-ui/core/CardContent'

const styles = theme => ({
  commentContainer: {
    alignItems: 'center',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    listStyleType: 'none',
    paddingInlineStart: 0,
    marginTop: theme.spacing.unit,
  },
  commentListItem: {
    display: 'flex',
    marginBottom: theme.spacing.unit,
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

const PhotoComments = ({ comments, classes }) => (
  <ul className={classes.commentContainer}>
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
  </ul>
)

export default withStyles(styles)(PhotoComments)
