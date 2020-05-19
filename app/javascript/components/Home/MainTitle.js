import React, {useRef} from 'react'
import LogoEIM from 'images/logo_eim.png';
import LogoUCV from 'images/logo_ucv.png';
import LogoFHE from 'images/logo_fhye.jpg';
import Image from 'react-bootstrap/Image'

class MainTitle extends React.Component {
  render() {
    return (
		<div className='text-center text-info py-5 align-middle'>
		<Image src={LogoUCV} width='100px' className='float-left m-3' rounded />
		<Image src={LogoFHE} width='100px' className='float-right m-3' rounded />
		<Image src={LogoEIM} rounded className='m-3'/>
        <h1> Universidad Central de Venezuela </h1>
        <h1> Facultad de Humanidad y Educación </h1>
        <h1> Escuela de Idiomas </h1>
        <h1> FUNDEIM </h1>
      </div>
    );
  }
}
export default MainTitle