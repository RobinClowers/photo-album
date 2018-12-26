export const facebookSignInUrl = () =>
  `${process.env.API_SCHEME}://${process.env.API_HOST}/users/auth/facebook?origin=${getReturnUrl()}`

export const adminUrl = `${process.env.API_SCHEME}://${process.env.API_HOST}/admin`

export const getReturnUrl = () => global.returnUrl || process.env.ROOT_URL
export const setReturnUrl = url => {
  if (/\/sign-in/.test(url) || /\/sign-up/.test(url)) {
    return
  }
  global.returnUrl = url
}
