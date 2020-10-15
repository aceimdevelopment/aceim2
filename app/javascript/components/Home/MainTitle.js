import React, {useRef} from 'react'
import LogoEIM from 'images/logo_eim.png';
import LogoUCV from 'images/logo_ucv.png';
import LogoFHE from 'images/logo_fhye.png';
import Banner from 'images/banner_logos_dark.png';
import Image from 'react-bootstrap/Image'

class MainTitle extends React.Component {
  render() {
    return (
		<div className='text-center text-info'>

      <Image src={Banner} width='70%' className='align-items-center justify-content-center' rounded />

      <h5 className=' mb-0'> Universidad Central de Venezuela </h5>
      <h5 className=' mb-0'> Facultad de Humanidades y Educación</h5>
      <h5 className=' mb-0'> Escuela de Idiomas Modernos</h5>
      <h5 className=' mb-0'> FUNDEIM </h5>
      <br/>
      {/*<a className="mr-2 btn btn-success" href="/users/sign_up">¡Regístrate!</a>*/}
      {/*<a className="ml-2 btn btn-primary" href="/users/sign_in">Ingresar</a>*/}
      </div>
    );
  }
}
export default MainTitle