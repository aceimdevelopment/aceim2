import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import FormLogin from './FormLogin'
import Button from 'react-bootstrap/Button';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import axios from 'axios-on-rails'
import LoginButton from './LoginButton';
import LogoutButton from './LogoutButton';


import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
// import { faCoffee } from '@fortawesome/free-solid-svg-icons';
// import LogoAceim from 'images/logo_aceim.png';
// import LogoEIM from 'images/logo_eim.png';
// import LogoEIMBlue from 'images/logo_eim_blue.png';
// import LogoEIMWhite from 'images/logo_eim_white.png';

class NavBarMain extends React.Component {

	checkLoggin(){
		var loggedInUser;
		axios.get('/home/longged_in', { withCredentials: true }).then((response) => {
			
			loggedInUser = response.data
		}).catch(error => {
			console.log("Error: ", error)
		})
		return loggedInUser
	}

	render() {
		let loginButton;
		console.log(this.checkLoggin());

		if (false) {
			loginButton = <LogoutButton />;
		} else {
			loginButton = <LoginButton />;
		}

		return (
			<Navbar expand="lg" className='color-bg-nav' fixed='top'>
				<Navbar.Brand href="https://fundeim.com" className='nav-bar-link text-info'>Fundeim</Navbar.Brand>
				<Navbar.Toggle aria-controls="basic-navbar-nav" />
				<Navbar.Collapse id="basic-navbar-nav">
					<Nav className="mr-auto">
						<Nav.Link href="mailto:fundeimucv@gmail.com" className='nav-bar-link text-muted'>Contáctanos</Nav.Link>
					</Nav>
					<LoginButton />
				</Navbar.Collapse>
			</Navbar>

		);
	}
}

export default NavBarMain
