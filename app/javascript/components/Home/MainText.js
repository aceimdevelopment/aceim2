import React, {useRef} from 'react'
import LogoEIM from 'images/logo_eim.png';
import LogoUCV from 'images/logo_ucv.png';
import LogoFHE from 'images/logo_fhye.jpg';
import Image from 'react-bootstrap/Image'

class MainText extends React.Component {
  render() {
    return (
      <div className='text-center align-middle mt-4' >
      <h5 className=' mb-3'> En FUNDEIM seguimos comprometidos con nuestra pasión: promover y motivar el apredizaje de idiomas extrangeros en nuestro país. </h5>
      <h5 className=' mb-3'> Estamos afinando los detalles del nuevo programa de cursos FUNDEIM ONLINE que consta de 18 clases por idioma y nivel. </h5>
      <h5 className=' mb-3'> Toda la información estará disponible aquí y en nuestra cuenta de twitter <a href="https://twitter.com/Fundeim">@fundeim</a> en los próximos días. </h5>
      <h5 className=' mb-3'> Muy pronto estaremos de nuevo con ustedes. </h5>
      </div>
    );
  }
}
export default MainText