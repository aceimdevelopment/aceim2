import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import Button from 'react-bootstrap/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCoffee } from '@fortawesome/free-solid-svg-icons';
class LogoutButton extends React.Component {
  render () {
    return (
		<Button variant="secondary" href="/users/sign_out" rel="nofollow" data-method="delete">Salir</Button>
    );
  }
}

export default LogoutButton
