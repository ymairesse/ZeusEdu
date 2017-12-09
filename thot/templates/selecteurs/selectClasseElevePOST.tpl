<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		<input type="hidden" name="matricule" id="matricule" value="{$matricule|default:''}">

		<select name="classe" id="selectClasse" class="form-control input-sm">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
			{/foreach}
		</select>

		{if isset($prevNext.prev)}
			{assign var=matrPrev value=$prevNext.prev}
			<button class="btn btn-default btn-xs" id="prev" title="Précédent: {$listeEleves.$matrPrev.prenom} {$listeEleves.$matrPrev.nom}">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</button>
		{/if}

		<span id="choixEleve">
			{include file="listeEleves.tpl"}
		</span>

		{if isset($prevNext.next)}
			{assign var=matrNext value=$prevNext.next}
			<button class="btn btn-default btn-xs" id="next" title="Suivant: {$listeEleves.$matrNext.prenom} {$listeEleves.$matrNext.nom}">
				<span class="glyphicon glyphicon-chevron-right"></span>
			 </button>
		{/if}

		{if isset($prevNext)}
			<input type="hidden" name="prev" value="{$prevNext.prev}" id="matrPrev">
			<input type="hidden" name="next" value="{$prevNext.next}" id="matrNext">
		{/if}

		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:Null}">

		<input type="hidden" name="etape" value="{$etape}">
		<input type="hidden" name="type" id="eleveSubjectif" value="{$type}">
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$('#formSelecteur').submit(function(){
		if ($("#selectEleve").val() > 0 || $('#matricule') > 0) {
			$('#wait').show();
			$.blockUI();
			}
			else return false;
		})

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		if (classe != '') {
			$('#next, #prev').hide();
			}
		// la fonction listeEleves.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
		$.post('inc/listeEleves.inc.php',{
			'classe': classe},
				function (resultat){
					$("#choixEleve").html(resultat)
				}
			)
	});

	$('#choixEleve').on('change','#selectEleve', function(){
		var matricule = $(this).val();
		if (matricule > 0) {
			$('#formSelecteur').submit();
			}
			else {
				$("#prev, #next").fadeOut();
				}
		})

	$('#prev').click(function(){
		var matrPrev = $("#matrPrev").val();
		$('#matricule').val(matrPrev);
		$("#selectEleve").val(matrPrev);
		$('#formSelecteur').submit();
	})

	$('#next').click(function(){
		var matrNext = $("#matrNext").val();
		$('#matricule').val(matrNext);
		$("#selectEleve").val(matrNext);
		$('#formSelecteur').submit();
	})

})

</script>
