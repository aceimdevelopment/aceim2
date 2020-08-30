// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
global.toastr = require("toastr")

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";
import "../stylesheets/application"

document.addEventListener("turbolinks:load", () => {
	$('[data-toggle="tooltip"]').tooltip()
	$('[data-toggle="popover"]').popover()
	$('.confirmBtn').on('click', function() {
		let ele = $(this);
		let url = ele.attr('url');
		let descUser = ele.attr('desc_user');
		let descInscrip = ele.attr('desc_inscrip');

		let textConfirm = `<b>¿Confirma que deseas completar la preinscripcion de ${descUser} en el curso: ${descInscrip} y de que acepta la siguiente normativa ?</b></br></br>`

		let normative = "<p>1.  Es obligatorio leer con detenimiento toda la información suministrada en el mensaje de inicio y en el módulo introductorio de su aula en CANVAS. Si tienen alguna duda sobre ACEIM o CANVAS,  o presentan algún inconveniente con el programa en general, deben contactar de inmediato a su instructor o a FUNDEIM por el correo fundeimucv@gmail.com</p>"
		normative += "<p>2.  La participación de los estudiantes en las actividades del foro es obligatoria y será tomada como asistencia a clase. La ausencia en el foro por 2 semanas, no necesariamente de manera consecutiva, tendrá como consecuencia la pérdida del curso por inasistencia.</p>"
		normative += "<p>3.  La calificación mínima aprobatoria es de 15 puntos. La evaluación será continua y dinámica. Encontrará mayor información en el cronograma del curso incluido en el módulo introductorio del nivel.</p>"
		normative += "<p>4.  El programa ONLINE consta de solo actividades asíncronas, es decir, no serán clases en vivo,  para que cada estudiante pueda organizarse y buscar el tiempo y la conexión para seguir formándose a su ritmo y en el horario de su preferencia; sin embargo, cada estudiante debe completar dos clases por semana, además de realizar las tareas asignadas y los exámenes semanales programados.</p>"

		$('#confirmDialog #content').html(textConfirm + normative);

		$('#confirmDialog #confirmLink').attr('href', url);
		$('#confirmDialog').modal();

	})
})




$(document).ready(function() {
	$('.tooltip-btn').tooltip();
	$("#updatePersonalData").modal({ keyboard: false, backdrop: 'static' });
	$("#AlertPaymentUnread").modal({ keyboard: false, backdrop: 'static' });
	
	$('.onlyOneCharacter').on('input', function(evt) {
		var node = $(this);
		console.log(node.val());
	});

	$('.upcase').on('input', function(evt) {
		var node = $(this);
		node.val(node.val().toUpperCase());
	});


	$('.onlyNumbers').on('input', function(evt) {
		var node = $(this);
		node.val(node.val().replace(/[^0-9]/g, ''));
	});



});


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

require("trix")
require("@rails/actiontext")