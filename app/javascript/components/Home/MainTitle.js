import React, {useRef} from 'react'
import LogoEIM from 'images/logo_eim.png';
import LogoUCV from 'images/logo_ucv.png';
import LogoFHE from 'images/logo_fhye.png';
import Image from 'react-bootstrap/Image'

class MainTitle extends React.Component {
  render() {
    return (
		<div className='text-center text-info pt-4 align-middle'>
		  <Image src={LogoUCV} width='100px' className='float-left m-5' rounded />
		  <Image src={LogoFHE} width='100px' className='float-right m-5' rounded />
		  <Image src={LogoEIM} rounded className='mt-5 mb-3'/>
      <h5 className=' mb-0'> Universidad Central de Venezuela </h5>
      <h5 className=' mb-0'> Facultad de Humanidad y Educación</h5>
      <h5 className=' mb-0'> Escuela de Idiomas </h5>
      <h5 className=' mb-0'> FUNDEIM </h5>
      <br/>
      {/*<a className="mr-2 btn btn-success" href="/users/sign_up">¡Regístrate!</a>*/}
      <a className="ml-2 btn btn-primary" href="/users/sign_in">Ingresa</a>
      <br/>
      </div>
    );
  }
}
export default MainTitle