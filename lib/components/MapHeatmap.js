import PropTypes from 'prop-types';
import React from 'react';

import {ViewPropTypes} from 'react-native';

import decorateMapComponent, {
	SUPPORTED,
	USES_DEFAULT_IMPLEMENTATION,
} from './decorateMapComponent';

const propTypes = {
	...ViewPropTypes,
	points: PropTypes.arrayOf(
		PropTypes.shape({
			latitude: PropTypes.number.isRequired,
			longitude: PropTypes.number.isRequired,
			weight: PropTypes.number,
		})
	),
	radius: PropTypes.number,
	gradient: PropTypes.shape({
		colors: PropTypes.arrayOf(PropTypes.string),
		values: PropTypes.arrayOf(PropTypes.number),
	}),
	opacity: PropTypes.number,
};

const defaultProps = {
	points: [],
};

class MapHeatmap extends React.Component {
	getSanitizedPoints = () =>
		this.props.points.map(point => ({weight: 1, ...point}));

	render() {
		const AIRMapHeatmap = this.getAirComponent();
		return (
			<AIRMapHeatmap
				points={this.getSanitizedPoints()}
				radius={this.props.radius}
				gradient={this.props.gradient}
				opacity={this.props.opacity}
			/>
		);
	}
}

MapHeatmap.propTypes = propTypes;
MapHeatmap.defaultProps = defaultProps;

export default decorateMapComponent(MapHeatmap, {
	componentType: 'Heatmap',
	providers: {
		google: {
			ios: SUPPORTED,
			android: USES_DEFAULT_IMPLEMENTATION,
		},
	},
});
