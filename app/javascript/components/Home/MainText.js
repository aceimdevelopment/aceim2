import React, {useRef} from 'react'
class MainText extends React.Component {
  render() {
    return (
      <div className='text-center align-middle m-3 p-3' >
      <h5 className=' mb-3'> En FUNDEIM seguimos comprometidos con nuestra pasión: promover y motivar el aprendizaje de idiomas extranjeros en nuestro país. </h5>
      <h5 className=' mb-3'> Cada nivel consta de 12 clases, que deberán ser completadas a un ritmo de 2 clases como mínimo por semana para que cada nivel dura seis semanas.La evaluación es continua y está repartida a lo largo de todo el nivel para ir acompañando el progreso de nuestros estudiantes y brindarles el mayor apoyo posible. </h5>
      <h5 className=' mb-3'> Nuestro programa ONLINE consta de solo actividades asíncronas, es decir, no serán clases en vivo, para que cada estudiante pueda organizarse y buscar el tiempo y la conexión para seguir formándose a su ritmo y en el horario de su preferencia. </h5>
      <h5 className=' mb-3'> Toda la información estará disponible aquí y en nuestra cuenta de twitter <a href="https://twitter.com/Fundeim">@fundeim</a>. </h5>
      </div>
    );
  }
}
export default MainText