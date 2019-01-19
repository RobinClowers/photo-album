import React from 'react'
import ShallowRenderer from 'react-test-renderer/shallow'
import Index from 'client/pages/index'
import albumIndexJson from 'client/test/support/json/albumIndex'

describe('index page', () => {
  it('matches snapshot', () => {
    const renderer = new ShallowRenderer()
    const result = renderer.render(<Index {...albumIndexJson} emailConfirmed={false} />)
    expect(result).toMatchSnapshot()
  })
})
