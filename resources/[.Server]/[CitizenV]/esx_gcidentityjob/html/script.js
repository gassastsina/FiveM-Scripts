GUIAction = {
    closeGui () {
        $('#identity').css("display", "none");
        $('#register').css("display", "none");
        $("#cursor").css("display", "none");
    },
    openGuiIdentity (data) {
        data = data || {}
        if (data.job_name !== undefined && data.job_name !== 'unemployed') {
            $('#identity').css('background-image', "url('img/card_" + data.job_name + ".png')")

            if (data.job_name == 'lumberjack' || data.job_name == 'miner' || data.job_name == 'tailor') {
            	$('#identity').css('background-image', "url('img/card_interim.png')")
			    $('#nom').css('font-family', "'seguiemj', sans-serif")
		        $('#prenom').css('font-family', "'seguiemj', sans-serif")
		        $('#job').css('font-family', "'seguiemj', sans-serif")
		        $('#phone').css('font-family', "'seguiemj', sans-serif")

	            $('#prenom').css('top', 212)
	            $('#prenom').css('left', 495)
	            $('#prenom').css('color', 'initial')

	            $('#nom').css('top', 281)
	            $('#nom').css('left', 495)
	            $('#nom').css('color', 'initial')

	            $('#phone').css('top', 366)
	            $('#phone').css('left', 496)
	            $('#phone').css('color', 'initial')
	            data.grade 	= ''
		        data.matricule = ''
            }else {	
		        if (data.grade_num !== undefined && (data.job_name == 'police' || data.job_name == 'fisherman' || data.job_name == 'lospolloshermanos')) {
		            $('#identity').css('background-image', "url('img/card_" + data.job_name + "_" + data.grade_num + ".png')")

		            if (data.job_name == 'police') {
			            $('#nom').css('top', 462)
			            $('#nom').css('left', 325)
			            $('#nom').css('text-align', "center")
			            $('#nom').css('line-height', "18px")
			            $('#nom').css('font-size', 18)
			            $('#nom').css('font-family', "'SegoePrint', sans-serif")
		            	$('#nom').css('color', 'initial')
			            data.prenom = ''
			            data.job 	= ''
			            data.grade 	= ''
			            data.phone 	= ''
			        
			        }else if (data.job_name == 'fisherman') {
			            $('#prenom').css('top', 202)
			            $('#prenom').css('left', 537)
			            $('#prenom').css('line-height', "30px")
			            $('#prenom').css('font-size', 22)
			            $('#prenom').css('font-family', "'ChapazaItalic', sans-serif")
			            $('#prenom').css('color', 'initial')

			            $('#nom').css('top', 284)
			            $('#nom').css('left', 537)
			            $('#nom').css('line-height', "30px")
			            $('#nom').css('font-size', 22)
			            $('#nom').css('font-family', "'ChapazaItalic', sans-serif")
			            $('#nom').css('color', 'initial')
			            
			            $('#phone').css('top', 390)
			            $('#phone').css('left', 537)
			            $('#phone').css('line-height', "30px")
			            $('#phone').css('font-size', 22)
			            $('#phone').css('font-family', "'ChapazaItalic', sans-serif")
			            $('#phone').css('color', 'initial')
			            data.job 	= ''
			            data.grade 	= ''
			            data.matricule = ''

			        }else if (data.job_name == 'lospolloshermanos') {
			            $('#nom').css('top', 202)
			            $('#nom').css('left', 460)
			            $('#nom').css('text-align', "left")
			            $('#nom').css('line-height', "80px")
			            $('#nom').css('font-size', 70)
			            $('#nom').css('font-family', "'PlaketteSerialBold', sans-serif")
		            	$('#nom').css('color', 'red')

			            $('#prenom').css('top', 120)
			            $('#prenom').css('left', 390)
			            $('#prenom').css('line-height', "110px")
			            $('#prenom').css('font-size', 70)
			            $('#prenom').css('font-family', "'PlaketteSerialBold', sans-serif")
			            $('#prenom').css('color', 'red')
			            data.job 	= ''
			            data.grade 	= ''
			            data.phone 	= ''
			            data.matricule = ''
			        
			        }
		        }
		        
		        if (data.job_name == "ambulance") {
		        	data.nom 	= data.prenom + " " + data.nom
		            $('#nom').css('top', 350)
		            $('#nom').css('left', 50)
		            $('#nom').css('line-height', "130px")
		            $('#nom').css('font-size', 40)
		            $('#nom').css('font-family', "'Neue Haas Grotesk Text Pro Bold', sans-serif")
		            $('#nom').css('color', 'white')

		            $('#grade').css('top', 270)
		            $('#grade').css('left', 50)
		            $('#grade').css('line-height', "130px")
		            $('#grade').css('font-size', 40)
		            $('#grade').css('font-family', "'Neue Haas Grotesk Text Pro Bold', sans-serif")
		            $('#grade').css('color', 'white')
		            data.prenom = ''
		            data.job 	= ''
		            data.phone 	= ''
		            data.matricule = ''
		        
		        }else if (data.job_name == "reporter") {
			        $('#nom').css('font-family', "'CalifornianFBRegular', sans-serif")
			        $('#prenom').css('font-family', "'CalifornianFBRegular', sans-serif")
			        $('#grade').css('font-family', "'CalifornianFBRegular', sans-serif")
			        $('#phone').css('font-family', "'CalifornianFBRegular', sans-serif")
			        data.job 	= ''
		            data.matricule = ''
		        
		        }else if (data.job_name == "slaughterer") {
			        $('#nom').css('font-family', "'BerlinSansFBRegular', sans-serif")
			        $('#prenom').css('font-family', "'BerlinSansFBRegular', sans-serif")
			        $('#grade').css('font-family', "'BerlinSansFBRegular', sans-serif")
			        $('#phone').css('font-family', "'BerlinSansFBRegular', sans-serif")
			        data.job 	= ''
		            data.matricule = ''
		        
		        }else if (data.job_name == "mecano") {
			        $('#nom').css('font-family', "'FranklinGothicDemiCondRegular', sans-serif")
			        $('#prenom').css('font-family', "'FranklinGothicDemiCondRegular', sans-serif")
			        $('#grade').css('font-family', "'FranklinGothicDemiCondRegular', sans-serif")
			        $('#phone').css('font-family', "'FranklinGothicDemiCondRegular', sans-serif")
			        data.job 	= ''
		            data.matricule = ''
		        
		        }else if (data.job_name == "sap") {
			        $('#nom').css('font-family', "'ErasDemi', sans-serif")
			        $('#prenom').css('font-family', "'ErasDemi', sans-serif")
			        $('#grade').css('font-family', "'ErasDemi', sans-serif")
			        $('#phone').css('font-family', "'ErasDemi', sans-serif")
			        data.job 	= ''
		            data.matricule = ''
		        
		        }else if (data.job_name == "rad") {
			        $('#nom').css('font-family', "'Flottflott', sans-serif")
			        $('#prenom').css('font-family', "'Flottflott', sans-serif")
			        $('#grade').css('font-family', "'Flottflott', sans-serif")
			        $('#phone').css('font-family', "'Flottflott', sans-serif")

		            $('#prenom').css('top', 192)
		            $('#prenom').css('left', 602)
		            $('#prenom').css('color', 'white')

		            $('#nom').css('top', 276)
		            $('#nom').css('left', 602)
		            $('#nom').css('color', 'white')

		            $('#phone').css('top', 417)
		            $('#phone').css('left', 65)
		            $('#phone').css('color', 'white')

		            $('#grade').css('top', 411)
		            $('#grade').css('left', 574)
		            $('#grade').css('color', 'white')
			        data.job 	= ''
		            data.matricule = ''
		        }
		    }
        }
        ['nom', 'prenom', 'job', 'grade', 'phone', 'matricule'].forEach(k => {
            $('#'+k).text(data[k] || '')
        })

        $('#identity').css("display", "block");
    }
}

window.addEventListener('message', function (event){
    let method = event.data.method
    if (GUIAction[method] !== undefined) {
        GUIAction[method](event.data.data)
    }
})



//
// Gestion de la souris
//
$(document).ready(function(){
    var documentWidth = document.documentElement.clientWidth
    var documentHeight = document.documentElement.clientHeight
    var cursor = $('#cursor')
    cursorX = documentWidth / 2
    cursorY = documentHeight / 2
    cursor.css('left', cursorX)
    cursor.css('top', cursorY)
    $(document).mousemove( function (event) {
        cursorX = event.pageX
        cursorY = event.pageY
        cursor.css('left', cursorX + 1)
        cursor.css('top', cursorY + 1)
    })
})