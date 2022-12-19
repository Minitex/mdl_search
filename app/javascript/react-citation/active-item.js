import React from 'react'
import Immutable from 'immutable'

// TODO: Split this out as a separate react component and add as a dependency

export default function activeItem(WrappedComponent) {
  return class ActiveItem extends React.Component {
    constructor(props) {
      super(props)
      this.state = { items: this.props.items }
      this._bindInit()
    }

    _bindInit() {
      this.getActiveItem = this.getActiveItem.bind(this)
      this.setActiveItem = this.setActiveItem.bind(this)
      this.getActiveItemIndex = this.getActiveItemIndex.bind(this)
      this._hasFocus = this._hasFocus.bind(this)
      this._updateFocus = this._updateFocus.bind(this)
      this._immutableAssets = this._immutableAssets.bind(this)
      this._unFocused = this._unFocused.bind(this)
      this._handlers = this._handlers.bind(this)
    }

    setActiveItem(i, e) {
      if (typeof (e) != 'undefined') {
        e.preventDefault()
      }
      this.setState({ items: this._updateFocus(this._unFocused(), i, true).toJS() })
    }

    getActiveItem() {
      return this.state.items.find(this._hasFocus)
    }

    getActiveItemIndex() {
      return this.state.items.findIndex(this._hasFocus)
    }

    // "private"

    _hasFocus(item) {
      return item.focus == true
    }

    _unFocused() {
      return this._updateFocus(this._immutableAssets(),
        this.getActiveItemIndex(),
        false)
    }

    _updateFocus(list, i, status) {
      return list.update(i, (item) => item.set('focus', status))
    }

    _immutableAssets() {
      return new Immutable.fromJS(this.state.items)
    }

    _handlers() {
      return {
        setActiveItem: this.setActiveItem.bind(this),
        getActiveItem: this.getActiveItem.bind(this),
        getActiveItemIndex: this.getActiveItemIndex.bind(this)
      }
    }

    render() {
      return <WrappedComponent  {...this.props} {...this.state} {...this._handlers()} />
    }
  }
}
