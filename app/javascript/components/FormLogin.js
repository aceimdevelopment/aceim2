import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import Button from 'react-bootstrap/Button';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';
import Image from 'react-bootstrap/Image'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCoffee } from '@fortawesome/free-solid-svg-icons';
import LogoAceim from 'images/logo_aceim.png';

class FormLogin extends React.Component {
  render () {
	// const largo = useRef(null);
	// const ancho = useRef(null);
    return (
      <React.Fragment>
		<Form inline>
				<FormControl type="text" placeholder="Correo Electrónico" autoFocus className="mr-sm-2" />
			<FormControl type="text" placeholder="Contraseña" className="mr-sm-2" />
			<Button>Entrar</Button>
		</Form>
{/*		<input type='text' ref={largo} />
		<input type='text' ref={ancho} />*/}
      </React.Fragment>
    );
  }
}

export default FormLogin
