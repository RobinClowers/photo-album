if window.location.hash == '#_=_'
  if history.replaceState
    history.replaceState(null, null, window.location.href.split('#')[0])
  else
    window.location.hash = ''
