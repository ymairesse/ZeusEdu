<div id="selecteur" class="noprint">

	<form id="formSelecteur" class="form-inline">

		<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève" class="form-control input-sm">

		<div class="form-group">
			<select name="classe" id="selectClasse" class="form-control input-sm">
				<option value="">Classe</option>
				{foreach from=$listeClasses item=uneClasse}
					<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
				{/foreach}
			</select>
		</div>

		<span id="choixEleve">
			{include file="selecteurs/listeEleves.tpl"}
		</span>

		<button type="button" class="btn btn-primary btn-sm" id="envoi">OK</button>
		<span id="ajaxLoader" class="hidden pull-right">
			<img src="images/ajax-loader.gif" alt="loading" class="img-responsive">
		</span>

	</form>
</div>

<script type="text/javascript">

	var classe = Cookies.get('classe');
	var matricule = Cookies.get('matricule');

	function showEleve(matricule) {
	$.post('inc/eleves/generateFicheEleve.inc.php', {
		matricule: matricule
		},
	function(resultat){
		$("#ficheEleve").show().html(resultat);
		})
	}

$(document).ready (function() {

	$('#nom').val('');

	if (matricule != undefined) {
		showEleve(matricule);
	}

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		Cookies.set('classe', classe, { expires: 7 });
		// la fonction listeEleves.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
		$.post('inc/listeEleves.inc.php',{
			classe: classe,
			matricule: matricule
			},
			function (resultat){
				$("#resultat").html(resultat);
				}
			)
		});

	$("#envoi").click(function(){
		var matricule = $('#selectEleve').val();
		if (matricule > 0)
			showEleve(matricule);
	})

	$('#choixEleve').on('change','#selectEleve', function(){
		var matricule = $(this).val();
		Cookies.set('matricule', matricule, { expires: 7 });
		if (matricule > 0) {
			showEleve(matricule);
			}
		})

	$("#nom").typeahead({
		minLength: 2,
		afterSelect: function(item){
			$.ajax({
				url: 'inc/searchMatricule.php',
				type: 'POST',
				data: 'nomPrenomClasse=' + item,
				dataType: 'text',
				async: true,
				success: function(matricule){
					if (matricule != '') {
						Cookies.set('matricule', matricule, { expires: 7 });
						// générer la fiche de l'élève
						$.post('inc/eleves/generateFicheEleve.inc.php', {
							matricule: matricule
							},
						function(resultat){
							$('#ficheEleve').show().html(resultat);
							$.post('inc/eleves/getListeElevesClasse.inc.php', {
								matricule: matricule
							}, function (resultat){
								$('#choixEleve').html(resultat);
								$.post('inc/eleves/getClasse4eleve.inc.php', {
									matricule: matricule
								}, function(groupe){
									$('#selectClasse').val(groupe);
									Cookies.set('classe', groupe);
								});
							})
							});

						}
					}
				})
			},
		source: function(query, process){
			$.ajax({
				url: 'inc/searchNom.php',
				type: 'POST',
				data: 'query=' + query,
				dataType: 'JSON',
				async: true,
				success: function (data) {
					$("#matricule").val('');
					process(data);
					}
				}
				)
			}
		})
	})

</script>
