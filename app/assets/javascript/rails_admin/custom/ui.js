//= require "toastr"
//= require_tree .

// ready = function() {
// 	if ($('body').attr('data-loaded') == 'T') {
// 		return
// 	}
// 	alert('¡Cargado!');
// }
// $('body').attr('data-loaded', 'T')
// $(document).ready(ready)
// $(document).on('turbolinks:load', ready)


$(document).on('ready pjax:success', function() {
	const queryString = window.location.search;
	// console.log(queryString);
	const urlParams = new URLSearchParams(queryString);
	const outSimulation = urlParams.get('outSimulation')
	// console.log(outSimulation);
	// console.log(sessionStorage);
	// console.log(sessionStorage.getItem('adminSimulation'));
	if (outSimulation == true) { 
		console.log('Sessión Cerrada');
		sessionStorage.setItem('user_id', null);
	}
	$('.onoffswitch').on('click', '.onoffswitch-label', function(event) {
		var checkbox = $(this).prev()[0];
		var alert = checkbox.attributes["alert"].value
		var url = checkbox.attributes["url"].value

		var send = true
		if (alert != 'false' & !checkbox.checked) {
			send = confirm(alert);
		}

		if (send == true) {
			sendData(url);
		} else {
			event.preventDefault()
			event.stopPropagation()
		}
	});

	$('[rel="tooltip"]').tooltip()
	$('.tooltip-btn').tooltip()
	$('.popover').popover()

	$(".diplayModalBtn").on('click', function() {
		var idModal = $(this).attr('idModal');
		$('#' + idModal).modal();

	});

	$('body').append("<div id='message' style='position: fixed;left: 83%;top: 8%;'></div>");
});


function sendForm(id, responseFieldId) {

	var xhr = new XMLHttpRequest();
	var form = document.getElementById(id)
	var formData = new FormData(form);
	xhr.open("POST", form.action);
	xhr.onload = function(event) {
		var resp = JSON.parse(event.target.response)
		// console.log(resp)
		var responseField = document.getElementById(responseFieldId)
		responseField.value = resp.data;
		if (resp.data == 'PI' | parseInt(resp.data) < 15) {
			responseField.className = 'form-control form-control-sm mr-2 alert-danger';
		} else if (parseInt(resp.data) > 14) {
			responseField.className = 'form-control form-control-sm mr-2 alert-success';
		} else { responseField.className = 'form-control form-control-sm mr-2'; }
		toastr.success('Calificación Guardada')

	};
	// or onerror, onabort
	xhr.send(formData);
}

// function setFinalField(id){

// }

// function switches(url, alert=false) {
// 	var send = true
// 	if (alert != false) {
// 		send = confirm(alert);
// 	}

// 	if (send == true){
// 		sendData(url);
// 		console.log(alert)
// 	} else {
// 		// console.log('Pa tras')
// 		// this.preventDefault()
// 		// this.stopPropagation()
// 	}
// }

// ============== trix-file ==============


function getMount(id) {
	let url = `/academic_records/${id}.json`
	$.ajax({
		url: url,
		type: 'GET',
		dataType: 'json',
		success: function(json) {
			$('#amountPaymentReport').val(json.value); 
		},
		error: function(json) {
			console.log(json)
			obj.prop('checked', !obj[0].checked)
			toastr.error(json.data);
		}
	});
}



function sendData(url){
	toastr.options.timeOut = 1500;
	$.ajax({
		url: url,
		type: 'GET',
		dataType: 'json',
		beforeSend: function(xhr) {
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
			// $('#cargando a').html(`Cargando... `);
			// $('#cargando').modal({ keyboard: false, show: true, backdrop: 'static' });
		},
		success: function(json) {
			// obj.prop('checked', !obj[0].checked)
			let elem = $('#message')

			elem.removeClass()

			elem.addClass(`alert alert-${json.type}`)
			elem.html(json.data)

			elem.fadeIn()
			elem.fadeOut(5000)

			toastr.success(json.data);
		},
		error: function(json) {
			console.log(json)
			obj.prop('checked', !obj[0].checked)
			toastr.error(json.data);
		}
	});
}
