import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import Button from 'react-bootstrap/Button';
import Image from 'react-bootstrap/Image'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCoffee } from '@fortawesome/free-solid-svg-icons';
import LogoAceim from 'images/logo_aceim.png';
import LogoEIM from 'images/logo_eim.png';
import LogoEIMBlue from 'images/logo_eim_blue.png';
import LogoEIMWhite from 'images/logo_eim_white.png';

class Header extends React.Component {
  render () {
	// const largo = useRef(null);
	// const ancho = useRef(null);

    return (
      <React.Fragment>
		<Button>
			<span><i className="fa fa-camera-retro"></i></span>
			<FontAwesomeIcon icon={faCoffee} />
			Hello Gente!
			<img src={LogoEIMBlue} width='100px' />
			<img src={LogoEIMWhite} width='100px' />
		</Button>
		<Image src={LogoEIM} width='100px' rounded />
      	<h1>Encabezado</h1>
{/*		<input type='text' ref={largo} />
		<input type='text' ref={ancho} />*/}
      </React.Fragment>
    );
  }
}

export default Header
