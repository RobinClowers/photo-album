import React from 'react'
import renderer from 'react-test-renderer'
import Index from 'client/pages/index'
import albumIndexJson from 'client/test/support/json/albumIndex'

describe('index page', () => {
  it('matches snapshot', () => {
    const component = renderer.create(<Index {...albumIndexJson} emailConfirmed={false} />)
    const tree = component.toJSON()
    expect(tree).toMatchSnapshot()
  })
})
