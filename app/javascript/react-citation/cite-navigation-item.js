import React from 'react'
import PropTypes from 'prop-types';

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
  label: PropTypes.string.isRequired,
  setActiveItem: PropTypes.func.isRequired,
  class_name: PropTypes.string
}

CiteNavigationItem.propTypes = propTypes
