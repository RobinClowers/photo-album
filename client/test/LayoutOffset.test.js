import LayoutOffset from 'client/src/LayoutOffset'

test('LayoutOffset does nothing for a single row', () => {
  const layout = new LayoutOffset(13)
  const photo = { caption: false }
  const first = {
    top: 10,
    left: 10,
    height: 300,
    width: 400,
  }
  const second = {
    top: 10,
    left: 420,
    height: 300,
    width: 400,
  }
  expect(layout.calculate(first, photo)).toEqual({ dimensions: first, photo })
  expect(layout.calculate(second, photo)).toEqual({ dimensions: second, photo })
})

test('LayoutOffset adds an offset for a row with at least one comment', () => {
  const layout = new LayoutOffset(13)
  const { dimensions: first } = layout.calculate({
      top: 10,
      left: 10,
      height: 300,
      width: 400,
    },
    { caption: true })
  expect(first.top).toEqual(10)
  layout.calculate({
      top: 10,
      left: 10,
      height: 300,
      width: 400,
    },
    { caption: true })
  const { dimensions: third } = layout.calculate({
      top: 320,
      left: 420,
      height: 300,
      width: 400,
    },
    { caption: true })
  expect(third.top).toEqual(333)
})

test('LayoutOffset does not add an offset for a row with no comments', () => {
  const layout = new LayoutOffset(13)
  const { dimensions: first } = layout.calculate({
      top: 10,
      left: 10,
      height: 300,
      width: 400,
    },
    { caption: false })
  expect(first.top).toEqual(10)
  const { dimensions: second } = layout.calculate({
      top: 320,
      left: 10,
      height: 300,
      width: 400,
    },
    { caption: true })
  expect(second.top).toEqual(320)
})

test('LayoutOffset does not add an offset for a row with no comments', () => {
  const layout = new LayoutOffset(13)
  const { dimensions: first } = layout.calculate({
      top: 10,
      left: 10,
      height: 300,
      width: 400,
    },
    { caption: false })
  expect(first.top).toEqual(10)
  const { dimensions: second } = layout.calculate({
      top: 320,
      left: 420,
      height: 300,
      width: 400,
    },
    { caption: true })
  expect(second.top).toEqual(320)
})
