import React from 'react'
import CiteNavigationItem from './cite-navigation-item'

export default class CiteNavigation extends React.Component {
  constructor(props) {
    super(props)
    this.active_class = this.active_class.bind(this)
    this.active_index = this.active_index.bind(this)
  }

  active_index() {
    return this.props.getActiveItemIndex()
  }

  active_class(i) {
    return (this.active_index() == i) ? 'active' : ''
  }

  render() {
    const { items, class_name, setActiveItem, getActiveItem } = this.props
    let active_class = this.active_class
    return (<ul className={'citation-navigation ' + class_name}>
              {items.map(function(item, i) {
                return (
                  <CiteNavigationItem label={item.label}
                                      key={i}
                                      active={active_class(i)}
                                      setActiveItem={setActiveItem.bind(this, i)} />
                )
              })}
            </ul>)
  }
}

const propTypes = {
  items: React.PropTypes.array.isRequired,
  setActiveItem: React.PropTypes.func.isRequired,
  getActiveItemIndex: React.PropTypes.func.isRequired,
  class_name: React.PropTypes.string
}

CiteNavigation.defaultProps = {
  class_name: 'nav nav-pills'
}

CiteNavigation.propTypes = propTypes