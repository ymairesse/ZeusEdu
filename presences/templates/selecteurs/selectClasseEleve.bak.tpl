<div id="selecteur" class="noprint">

	<form id="formSelecteur" class="form-inline">

		<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève" class="form-control">

		
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	// $("#selectClasse").change(function(){
	// 	// on a choisi une classe dans la liste déroulante
	// 	var classe = $(this).val();
	// 	// la fonction listeEleves.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
	// 	$.post("inc/listeEleves.inc.php",{
	// 		classe: classe
	// 		},
	// 		function (resultat){
	// 			$("#choixEleve").html(resultat)
	// 		}
	// 	)
	// });
	//
	// $("#choixEleve").on('change', '#selectEleve', function(){
	// 	var matricule = $(this).val();
	// 	if (matricule != '') {
	// 		$.post('inc/absences/getFormJustification.inc.php', {
	// 			matricule: matricule,
	// 			mode: ''
	// 		}, function(resultat){
	// 			$('#formulaireJustif').html(resultat);
	// 		})
	// 		$.post('inc/absences/getListeAbsencesEleve.inc.php', {
	// 			matricule: matricule
	// 		}, function(resultat){
	// 			$('#listeAbsences').html(resultat)
	// 		})
	// 	}
	// })

	//
	// $("#prev").click(function(){
	// 	var matrPrev = $("#matrPrev").val();
	// 	$("#leMatricule").val(matrPrev);
	// 	$("#selectEleve").val(matrPrev);
	// })
	//
	// $("#next").click(function(){
	// 	var matrNext = $("#matrNext").val();
	// 	$("#leMatricule").val(matrNext);
	// 	$("#selectEleve").val(matrNext);
	// 	// $("#formSelecteur").submit();
	// })

	// $("#nom").typeahead({
    //     minLength: 2,
	// 	afterSelect: function(item) {
	// 		$.ajax({
	// 			url: 'inc/searchMatricule.php',
	// 			type: 'POST',
	// 			data: 'nomPrenomClasse=' + item,
	// 			dataType: 'text',
	// 			async: true,
	// 			success: function(matricule) {
	// 				if (matricule != '') {
	// 					$.post('inc/absences/getFormJustification.inc.php', {
	// 						matricule: matricule,
	// 						mode: ''
	// 					}, function(resultat){
	// 						$('#formulaireJustif').html(resultat);
	// 					})
	// 					$.post('inc/absences/getListeAbsencesEleve.inc.php', {
	// 						matricule: matricule
	// 					}, function(resultat){
	// 						$('#listeAbsences').html(resultat)
	// 					})
	//
	// 				}
	// 			}
	// 		})
	// 	},
    //     source: function(query, process) {
    //         $.ajax({
    //             url: 'inc/searchNom.php',
    //             type: 'POST',
    //             data: 'query=' + query,
    //             dataType: 'JSON',
    //             async: true,
    //             success: function(data) {
    //                 process(data);
    //             }
    //         })
    //     }
    // })

})

</script>
