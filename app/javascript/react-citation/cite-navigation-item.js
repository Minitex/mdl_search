import React from 'react'

export default class CiteNavigationItem extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    const { active, setActiveItem, label } = this.props      
    return (
      <li role="presentation" className={active}>
        <a onClick={setActiveItem} href="#">{label}</a>
      </li>
    )
  }

}

const propTypes = {
  label: React.PropTypes.string.isRequired,
  setActiveItem: React.PropTypes.func.isRequired,
  class_name: React.PropTypes.string
}

CiteNavigationItem.propTypes = propTypes