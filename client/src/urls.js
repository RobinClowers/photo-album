export const adminUrl = `${process.env.API_ROOT}/admin`

export const getReturnUrl = () => global.returnUrl || '/'
export const setReturnUrl = url => {
  if (/\/sign-in/.test(url) || /\/sign-up/.test(url)) {
    return
  }
  global.returnUrl = url
}
