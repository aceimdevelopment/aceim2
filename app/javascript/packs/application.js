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

		let textConfirm = `<b>¿Confirma que deseas completar la preinscripcion de ${descUser} en ${descInscrip} y de que acepta la normativa expuesta?</b></br>`

		$('#confirmDialog #content #titleConfirmation').html(textConfirm);

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