//= require "toastr"
//= require_tree .

$(document).ready(function() {
	$('[rel="tooltip"]').tooltip()
	$('.tooltip-btn').tooltip()
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


function switches(url) {

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
			if (json.type == 'error') {
				obj.prop('checked', !obj[0].checked)
				toastr.error(json.data)
			} else { 
				toastr.success(json.data) 
			}
		},
		error: function(json) {
			console.log(json)
			obj.prop('checked', !obj[0].checked)
			toastr.error(json.data);
		}
	});
}