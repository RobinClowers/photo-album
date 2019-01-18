class LayoutOffset {
  constructor(offset) {
    this.offset = offset
    this.state = {
      firstRowTop: undefined,
      currentRowTop: undefined,
      currentHeightOffset: undefined,
      rowHasCaption: false,
      currentRow: [],
    }
  }

  calculate(dimensions, photo) {
    const {
      firstRowTop,
      currentRowTop,
      currentHeightOffset,
      rowHasCaption,
      currentRow,
    } = this.state
    const hasCaption = rowHasCaption || !!photo.caption

    if (firstRowTop === undefined) {
      // First call sets the top row, current row and offset
      this.state = {
        firstRowTop: dimensions.top,
        currentRowTop: dimensions.top,
        currentHeightOffset: 0,
        rowHasCaption: !!photo.caption,
        currentRow: [dimensions],
      }
    } else if (dimensions.top == firstRowTop) {
      // First row item
      this.state = {
        ...this.state,
        rowHasCaption: hasCaption,
        currentRow: [...currentRow, dimensions],
      }
    } else if (dimensions.top != currentRowTop) {
      // First item in a new row
      if (!this.state.rowHasCaption) {
        // Remove extra space from previous row
        currentRow.forEach(dim => {
          dim.height = dim.imageHeight
        })
      }
      const rowOffset = rowHasCaption ? this.offset : 0
      this.state = {
        ...this.state,
        currentRowTop: dimensions.top,
        currentHeightOffset: currentHeightOffset + rowOffset,
        rowHasCaption: !!photo.caption,
        currentRow: [dimensions],
      }
    } else {
      // Additional item in row
      this.state = {
        ...this.state,
        currentRowTop: dimensions.top,
        rowHasCaption: hasCaption,
        currentRow: [...currentRow, dimensions],
      }
    }
    dimensions.top = dimensions.top + this.state.currentHeightOffset
    dimensions.imageHeight = dimensions.height
    dimensions.height = dimensions.height + this.offset
    return { dimensions, photo }
  }
}

export default LayoutOffset
