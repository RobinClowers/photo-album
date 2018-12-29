export const facebookSignInUrl = () =>
  `${process.env.API_ROOT}/users/auth/facebook?origin=${getReturnUrl()}`

export const adminUrl = () => `${process.env.API_ROOT}/admin`

export const getReturnUrl = () => global.returnUrl || process.env.FRONT_END_ROOT
export const setReturnUrl = url => {
  if (/\/sign-in/.test(url) || /\/sign-up/.test(url)) {
    return
  }
  global.returnUrl = url
}

export const indexPath = () => '/'
export const signInPath = () => '/sign-in'
export const signUpPath = () => '/sign-up'
export const changePasswordPath = () => '/account/change-password'
export const forgotPasswordPath = () => '/account/forgot-password'
export const resetPasswordPath = () => '/account/reset-password'
export const albumPath = slug => `/albums/${slug}`
export const photoPath = (slug, filename) => `/albums/${slug}/${filename}`
