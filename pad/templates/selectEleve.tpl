<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" action="index.php" method="POST">
		{if isset($cours)}
			<label for="selectEleve" title="{$cours}">
			{if $listeCours.$cours.nomCours != ''}
				{$listeCours.$cours.nomCours}
				{else}
				{$listeCours.$cours.statut} {$listeCours.$cours.libelle} {$listeCours.$cours.nbheures}h {$cours}
			{/if}
			</label>
		{/if}
		
		{if isset($listeEleves)}
			{include file="listeEleves.tpl"}
		{/if}

	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="cours" value="{$cours}">

	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	if ($("#selectEleve").val() > 0)
		$("#resultat").show();

	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$("#corpsPage").hide();
	})

	$("#selectEleve").change(function(){
		if ($(this).val() > 0)
			$("#formSelecteur").submit()
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
{/literal}
</script>
