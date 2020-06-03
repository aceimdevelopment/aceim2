import React, {useRef} from 'react'
import LogoAceim2 from 'images/logo_aceim2.png';
import Image from 'react-bootstrap/Image'

class LoginTitle extends React.Component {
  render(content) {
    return (
		  <div>
        <h1 className='logo-name'>
          <Image src={LogoAceim2} />
        </h1>
        {content}
      </div>
    );
  }
}
export default LoginTitle