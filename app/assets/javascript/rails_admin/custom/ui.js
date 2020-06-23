//= require "toastr"
//= require_tree .

$(document).ready(function() {
	$('[rel="tooltip"]').tooltip()
	$('.tooltip-btn').tooltip()
});

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