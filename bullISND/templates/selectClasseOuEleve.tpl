<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if $uneClasse == $classe} selected="selected"{/if}>{$uneClasse}</option>
		{/foreach}
		</select>

		{if isset($prevNext) && isset($prevNext.prev)}
			{assign var=matrPrev value=$prevNext.prev}
			<img src="images/left.png" style="position: relative; width:18px; top:4px" alt="<" id="prev" title="Préc: {$listeEleves.$matrPrev.prenom} {$listeEleves.$matrPrev.nom}">
		{/if}
		

		<span id="choixEleve">
			
		{include file='listeEleves.tpl'}
	
		</span>
		
		{if isset($prevNext) && isset($prevNext.next)}
			{assign var=matrNext value=$prevNext.next}
		 <img src="images/right.png" style="position: relative; width:18px; top:4px" alt=">" id="next" title="Suiv: {$listeEleves.$matrNext.prenom} {$listeEleves.$matrNext.nom}">
		{/if}
		
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	{if isset($prevNext)}
		<input type="hidden" name="prev" value="{$prevNext.prev}" id="matrPrev">
		<input type="hidden" name="next" value="{$prevNext.next}" id="matrNext">
	{/if}
	<input type="hidden" name="etape" value="showEleve">
	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if (($("#selectEleve").val() != '') || ($("#selectClasse").val() != '')) {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})
	

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();

		if (classe != '') $("#envoi").show();
		// la fonction listeEleves.inc.php renvoie la liste déroulante
		// des élèves de la classe sélectionnée
		$.post("inc/listeEleves.inc.php",
			{ 'classe': classe },
				function (resultat) {
					$("#choixEleve").html(resultat)
				}
			)
	});

	$("#choixEleve").on("change", "#selectEleve", function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative, le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
			}
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
