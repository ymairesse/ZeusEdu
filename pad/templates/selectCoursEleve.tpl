<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<div class="input-group">
			<select name="coursGrp" id="selectCoursGrp" class="form-control-inline form-control">
				<option value="">Sélection d'un cours</option>
				{foreach from=$listeCoursGrp key=unCoursGrp item=data}
					<option value="{$unCoursGrp}"{if isset($coursGrp) && ($unCoursGrp == $coursGrp)} selected{/if}>
					{if $data.nomCours != ''}{$data.nomCours} || {else}{$data.libelle}{/if} {$data.statut} {$unCoursGrp} {$data.nbheures}h
					</option>
				{/foreach}
			</select>
		</div>

		<span id="choixEleve">

		{include file='listeEleves.tpl'}

		</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" id="action" value="{$action}">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
		})


	$("#selectCoursGrp").change(function(){
		// on a choisi une classe dans la liste déroulante
		var coursGrp = $(this).val();
		// if (classe != '') $("#envoi").show();
		// la fonction listeElevesCoursGrp.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
		$.post("inc/listeElevesCoursGrp.inc.php",{
			'coursGrp': coursGrp
			},
			function (resultat){
				$('#choixEleve').html(resultat)
				}
			)
		});

	$("#choixEleve").on("change", "#selectEleve", function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative, le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
			}
			else $("#envoi").hide();
		})

	$("#prev").click(function(){
		var matrPrev = $("#matrPrev").val();
		$("#selectEleve").val(matrPrev);
		$("#formSelecteur").submit();
		})

	$("#next").click(function(){
		var matrNext = $("#matrNext").val();
		$("#selectEleve").val(matrNext);
		$("#formSelecteur").submit();
		})
})

</script>
