<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

	<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève">
	<input type="hidden" name="matricule" id="matricule" value="{$matricule|default:''}">

		<select name="classe" id="selectClasse">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
			{/foreach}
		</select>

		{if isset($prevNext.prev)}
			{assign var=matrPrev value=$prevNext.prev}
			<button class="btn btn-default btn-xs" id="prev" title="Précédent: {$listeEleves.$matrPrev.prenom} {$listeEleves.$matrPrev.nom}">
				<i class="fa fa-chevron-left"></i>
			</button>
		{/if}

		<span id="choixEleve">
			{if isset($listeEleves)}
			{include file="selecteurs/listeEleves.tpl"}
			{/if}
		</span>

		{if isset($prevNext.next)}
			{assign var=matrNext value=$prevNext.next}
			<button class="btn btn-default btn-xs" id="next" title="Suivant: {$listeEleves.$matrNext.prenom} {$listeEleves.$matrNext.nom}">
				<i class="fa fa-chevron-right"></i>
			 </button>
		{/if}

		{if isset($prevNext)}
			<input type="hidden" name="prev" value="{$prevNext.prev}" id="matrPrev">
			<input type="hidden" name="next" value="{$prevNext.next}" id="matrNext">
		{/if}

		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:Null}">

		<input type="hidden" name="etape" value="showEleve">
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$('#formSelecteur').submit(function(){
		if (($("#matricule").val() > 0) || ($("#selectEleve").val() != '')) {
			$('#wait').show();
			$.blockUI();
			}
		})

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		$("#action").val('parClasses');
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
			$("#action").val('parEleve');
			$("#matricule").val(matricule);
			$('#formSelecteur').submit();
			}
			else {
				$("#matricule").val('');
				$("#action").val('parClasses');
				$("#prev, #next").fadeOut();
				}
		})

	$('#prev').click(function(){
		var matrPrev = $("#matrPrev").val();
		$('#matricule').val(matrPrev);
		$('#selectEleve').val(matrPrev);
		$('#formSelecteur').submit();
	})

	$('#next').click(function(){
		var matrNext = $("#matrNext").val();
		$('#matricule').val(matrNext);
		$("#selectEleve").val(matrNext);
		$('#formSelecteur').submit();
	})

	$('#nom').keydown(function(e){
		if (e.which >= 65) {
			$('#matricule').val('');
			$('#selectEleve').fadeOut().val('');
			$('#choixEleve').html('');
			$('#selectClasse').val('');
			$('#prev, #next').fadeOut();
			$('#matrPrev, #matrNext').val('');
		}
		})

	$("#nom").typeahead({
		minLength: 2,
		hint: true,
		highlight: true,
		afterSelect: function(item){
			$.ajax({
				url: 'inc/searchMatricule.php',
				type: 'POST',
				data: 'query=' + item,
				dataType: 'text',
				async: true,
				success: function(data){
					if (data != '') {
						$("#matricule").val(data);
						$("#formSelecteur").submit();
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
