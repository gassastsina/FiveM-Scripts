$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			if (event.data.enable) {
				$(".dialog").css("display", "block");
			}else{
				$(".dialog").css("display", "none");
			}
			//document.body.style.display = event.data.enable ? "block" : "none";
		}else if(event.data.type == "display_natif") {
			if (event.data.enable) {
				$(".arriveNatif").css("display", "block");
				$("#cursor").css("display", "block");
			}else{
				$(".arriveNatif").css("display", "none");
				$("#cursor").css("display", "none");
			}
		}else if(event.data.type == "display_plane") {
			if (event.data.enable) {
				$(".arriveAvion").css("display", "block");
				$("#cursor").css("display", "block");
			}else{
				$(".arriveAvion").css("display", "none");
				$("#cursor").css("display", "none");
			}
		}else if(event.data.type == "display_boat") {
			if (event.data.enable) {
				$(".arriveBateau").css("display", "block");
				$("#cursor").css("display", "block");
			}else{
				$(".arriveBateau").css("display", "none");
				$("#cursor").css("display", "none");
			}
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) { // Escape key
			$.post('http://esx_identity/escape', JSON.stringify({}));
		}
	};
	
	$("#register").submit(function(e) {
		e.preventDefault(); // Prevent form from submitting
		
		// Verify date
		var date = $("#dateofbirth").val();
		var dateCheck = new Date($("#dateofbirth").val());
		if (dateCheck == "Invalid Date") {
			date == "invalid";
		}
		$.post('http://esx_identity/register', JSON.stringify({
			firstname: $("#firstname").val(),
			lastname: $("#lastname").val(),
			dateofbirth: date,
			sex: $("input[type='radio'][name='sex']:checked").val(),
			height: $("#height").val()
		}));
	});
});
