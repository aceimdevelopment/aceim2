import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import Button from 'react-bootstrap/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCoffee } from '@fortawesome/free-solid-svg-icons';

class LoginButton extends React.Component {
  render () {
    return (
		<Button variant="primary" href="/users/sign_in">Ingresar</Button>
		);
	}
}

export default LoginButton
