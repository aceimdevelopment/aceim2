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


// function displayModal(name) {
// 	$(name).modal();
// }

document.addEventListener("turbolinks:load", () => {
	$('[data-toggle="tooltip"]').tooltip();
	$('[data-toggle="popover"]').popover();
	$("#updatePersonalData").modal({ keyboard: false, backdrop: 'static' });
	$("#AlertPaymentUnread").modal({ keyboard: false, backdrop: 'static' });

	$(".diplayModalBtn").on('click', function() {
		let idModal = $(this).attr('idModal');
		$(`#${idModal}`).modal();

	});


	$('.onlyOneCharacter').on('input', function(evt) {
		var node = $(this);
	});

	$('.upcase').on('input', function(evt) {
		var node = $(this);
		node.val(node.val().toUpperCase());
	});


	$('.onlyNumbers').on('input', function(evt) {
		var node = $(this);
		node.val(node.val().replace(/[^0-9]/g, ''));
	});

	$('.confirmBtn').on('click', function() {
		let ele = $(this);
		let url = ele.attr('url');
		let descUser = ele.attr('desc_user');
		let descInscrip = ele.attr('desc_inscrip');

		let textConfirm = `<b>¿Confirma que deseas completar la preinscripcion de ${descUser} en el curso: ${descInscrip} y de que acepta la siguiente normativa ?</b></br></br>`

		let normative = "<p>1.  Es obligatorio leer con detenimiento toda la información suministrada en el mensaje de inicio y en el módulo introductorio de su aula en <b style='color:red' >CANVAS</b>. Si tienen alguna duda sobre <b style='color:blue' >ACEIM</b> o <b style='color:red' >CANVAS</b>,  o presentan algún inconveniente con el programa en general, deben contactar de inmediato a su instructor o a <b>FUNDEIM</b> por el correo <a href='mailto:fundeimucv@gmail.com'> fundeimucv@gmail.com</a>.</p>"
		normative += "<p>2.  La participación de los estudiantes en las actividades del foro es obligatoria y será tomada como asistencia a clase. La ausencia en el foro por 3 semanas, no necesariamente de manera consecutiva, tendrá como consecuencia la pérdida del curso por inasistencia.</p>"
		normative += "<p>3.  La calificación mínima aprobatoria es de 15 puntos. La evaluación será continua y dinámica. Encontrará mayor información en el cronograma del curso incluido en el módulo introductorio del nivel.</p>"
		normative += "<p>4.  El programa <b>ONLINE</b> consta de solo actividades asíncronas, es decir, no serán clases en vivo,  para que cada estudiante pueda organizarse y buscar el tiempo y la conexión para seguir formándose a su ritmo y en el horario de su preferencia; sin embargo, cada estudiante debe completar dos clases por semana, además de realizar las tareas asignadas y los exámenes semanales programados.</p>"

		$('#confirmDialog #content').html(textConfirm + normative);

		$('#confirmDialog #confirmLink').attr('href', url);
		$('#confirmDialog').modal();

	})
})


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