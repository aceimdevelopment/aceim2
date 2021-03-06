import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import FormLogin from './FormLogin'
import Button from 'react-bootstrap/Button';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
// import { faCoffee } from '@fortawesome/free-solid-svg-icons';
// import LogoAceim from 'images/logo_aceim.png';
// import LogoEIM from 'images/logo_eim.png';
// import LogoEIMBlue from 'images/logo_eim_blue.png';
// import LogoEIMWhite from 'images/logo_eim_white.png';

class NavBarMainLogin extends React.Component {
	render() {
		return (
			<Navbar expand="lg" className='color-bg-nav' fixed='top'>
				<Navbar.Brand href="https://fundeim.com" className='nav-bar-link text-info'>Fundeim</Navbar.Brand>
				<Navbar.Toggle aria-controls="basic-navbar-nav" />
				<Navbar.Collapse id="basic-navbar-nav">
					<Nav className="mr-auto">
						<Nav.Link href="mailto:fundeimucv@gmail.com" className='nav-bar-link text-muted'>Contáctanos</Nav.Link>
					</Nav>
					<a id='userName' className='text-light mr-2'></a>
					<a className="login-button btn btn-outline-secondary" rel="nofollow" data-method="delete" href="/users/sign_out">Salir</a>
				</Navbar.Collapse>
			</Navbar>

		);
	}
}

export default NavBarMainLogin
