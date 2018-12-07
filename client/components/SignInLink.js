const facebookSignInUrl = `${process.env.API_SCHEME}://${process.env.API_HOST}/auth/facebook/`

export default ({ className, linkText, additionalText }) => (
  <React.Fragment>
    <a className={className} href={facebookSignInUrl}>
      {linkText}
    </a>
    {additionalText && ` ${additionalText}`}
  </React.Fragment>
)
