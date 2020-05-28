import React, {useRef} from 'react'
import LogoEIM from 'images/logo_eim.png';
import LogoUCV from 'images/logo_ucv.png';
import LogoFHE from 'images/logo_fhye.jpg';
import Image from 'react-bootstrap/Image'

class MainTitle extends React.Component {
  render() {
    return (
		<div className='text-center text-info py-5 align-middle'>
		<Image src={LogoUCV} width='100px' className='float-left m-5' rounded />
		<Image src={LogoFHE} width='100px' className='float-right m-5' rounded />
		<Image src={LogoEIM} rounded className='m-5'/>
        <h3> Universidad Central de Venezuela </h3>
        <h3> Facultad de Humanidad y Educación</h3>
        <h3> Escuela de Idiomas </h3>
        <h3> FUNDEIM </h3>
      </div>
    );
  }
}
export default MainTitle