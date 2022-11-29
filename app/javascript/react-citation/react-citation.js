import React from 'react';
import PropTypes from 'prop-types';
import ActiveItem from './active-item';

import CiteNavigation from './cite-navigation';
import Details from './cite-details';
import Citation from './cite-citation';
import Download from './cite-download';
import Transcript from './cite-transcript';

class ReactCitation extends React.Component {

  constructor(props) {
    super(props);
    this._viewer = this._viewer.bind(this);
  }

  _viewer() {
    const item = this.props.getActiveItem();
    switch (item.type) {
      case 'details':
        return <Details fields={item.fields} />;
      case 'citation':
        return <Citation fields={item.fields} />;
      case 'download':
        return <Download fields={item.fields} />;
      case 'transcript':
        return <Transcript transcript={item.transcript} />;
      default:
        return <div>No Viewer Avaialable for type: {item.type}</div>;
    }
  }

  render() {
    const type = this.props.getActiveItem().type;
    return (
      <div>
        <CiteNavigation {...this.props} />
        <div className={`cite-${type}`}>
          {this._viewer()}
        </div>
      </div>
    );
  }
}

const propTypes = {
  items: PropTypes.array.isRequired,
  getActiveItem: PropTypes.func.isRequired,
};

ReactCitation.propTypes = propTypes;

export default ActiveItem(ReactCitation);
