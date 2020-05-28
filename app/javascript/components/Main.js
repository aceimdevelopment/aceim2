import React, {useRef} from 'react'
import MainTitle from './Home/MainTitle'
import MainText from './Home/MainText'

class Main extends React.Component {
  render() {
    return (
    	<div>
      		<MainTitle />
      		<MainText />
    	</div>
    );
  }
}
export default Main