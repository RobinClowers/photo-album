export const facebookSignInUrl = () =>
  `${process.env.API_ROOT}/users/auth/facebook?origin=${getReturnUrl()}`

export const adminUrl = `${process.env.API_ROOT}/admin`

export const getReturnUrl = () => global.returnUrl || process.env.FRONT_END_ROOT
export const setReturnUrl = url => {
  if (/\/sign-in/.test(url) || /\/sign-up/.test(url)) {
    return
  }
  global.returnUrl = url
}
