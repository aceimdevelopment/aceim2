import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import Modal from 'react-bootstrap/Modal'
import Button from 'react-bootstrap/Button';

class ModalCustom extends React.Component {
  render () {
    return (
      <React.Fragment>
        <Modal.Dialog>
          <h1>Encabezado</h1>
          <p>{this.props.content}</p>
        </Modal.Dialog>

        <Button variant="primary" onClick={document.getElementsByClassName('modal')[0].style.display = 'block'}>
          Launch demo modal
        </Button>

        <Modal className='modal'>
          <Modal.Header closeButton>
            <Modal.Title>Modal heading</Modal.Title>
          </Modal.Header>
          <Modal.Body>Woohoo, you're reading this text in a modal!</Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={document.getElementById('modal').style.display = 'none'} >
              Close
            </Button>
          </Modal.Footer>
        </Modal>

      </React.Fragment>
    );
  }
}

export default ModalCustom
