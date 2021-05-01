<div id="selecteur" class="noprint">

	<div id="formSelecteur" class="form-inline">

		{if $mode == 'speed'}<span title="Justification rapide">&nbsp;<i class="fa fa-bolt fa-lg"></i>&nbsp;</span>{/if}

		<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève" class="form-control">
		<input type="hidden" name="mode" id="mode" value="{$mode|default:'normal'}">

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

	</div>
</div>


<script type="text/javascript">

	$(document).ready(function(){

		$("#selectClasse").change(function(){
			// on a choisi une classe dans la liste déroulante
			var classe = $(this).val();
			// la fonction listeEleves.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
			$.post('inc/listeEleves.inc.php',{
				classe: classe
				}, function (resultat){
					$("#choixEleve").html(resultat);
					}
				)
			});

		$("#choixEleve").on('change', '#selectEleve', function(){
			var matricule = $(this).val();
			var mode = $('#mode').val();

			var periodeFrom = (mode == 'speed') ? $('#periodeFrom').val() : undefined;
			var periodeTo = (mode == 'speed') ? $('#periodeTo').val() : undefined;
			var dateFrom = (mode == 'speed') ? $('#dateFrom').val() : undefined;
			var dateTo = (mode == 'speed') ? $('#dateTo').val() : undefined;
			var justification = (mode == 'speed') ? $('#selectJustification').val() : undefined;

			if (matricule != '') {
				$.post('inc/absences/getFormJustification.inc.php', {
					matricule: matricule,
					mode: mode,
					periodeFrom: periodeFrom,
					periodeTo: periodeTo,
					dateFrom: dateFrom,
					dateTo: dateTo,
					justification: justification,
				}, function(resultat){
					$('#formulaireJustif').html(resultat);
				})
				$.post('inc/absences/getListeAbsencesEleve.inc.php', {
					matricule: matricule
				}, function(resultat){
					$('#listeAbsences').html(resultat)
				})

			}
		})

		$("#nom").typeahead({
		    minLength: 2,
			afterSelect: function(item) {
				$.ajax({
					url: 'inc/searchMatricule.php',
					type: 'POST',
					data: 'nomPrenomClasse=' + item,
					dataType: 'text',
					async: true,
					success: function(matricule) {
						if (matricule != '') {
							$.post('inc/absences/getFormJustification.inc.php', {
								matricule: matricule,
								mode: $('#mode').val(),
							}, function(resultat){
								$('#formulaireJustif').html(resultat);
							})
							$.post('inc/absences/getListeAbsencesEleve.inc.php', {
								matricule: matricule
							}, function(resultat){
								$('#listeAbsences').html(resultat)
							})
							$.post('inc/absences/getClasseEleve.inc.php', {
								matricule: matricule
							}, function(classe){
								$('#selectClasse').val(classe);
							})
							$.post('inc/absences/getListeEleves.inc.php', {
								matricule: matricule
							}, function(listeEleves){
								$('#choixEleve').html(listeEleves);
							})
						}
					}
				})
			},
		    source: function(query, process) {
		        $.ajax({
		            url: 'inc/searchNom.php',
		            type: 'POST',
		            data: 'query=' + query,
		            dataType: 'JSON',
		            async: true,
		            success: function(data) {
		                process(data);
		            }
		        })
		    }
		})

	})

</script>
