import React, {useRef} from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
class Header extends React.Component {
  render () {
	// const largo = useRef(null);
	// const ancho = useRef(null);

    return (
      <React.Fragment>
      	<h1>Encabezado</h1>
{/*		<input type='text' ref={largo} />
		<input type='text' ref={ancho} />*/}
      </React.Fragment>
    );
  }
}

export default Header
