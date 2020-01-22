<div id="selecteur" class="noprint" style="clear:both">
	
	<form name="formSelecteur" id="formSelecteur" action="index.php" method="POST" role="form" class="form-inline">
		{if isset($coursGrp)}
			<div class="input-group">
				<label for="selectEleve">
				{if $listeCours.$coursGrp.nomCours != ''}
					{$listeCours.$coursGrp.nomCours} || {$coursGrp} {$listeCours.$coursGrp.nbheures}h 
					{else}
					{$listeCours.$coursGrp.statut} {$listeCours.$coursGrp.libelle} {$listeCours.$coursGrp.nbheures}h {$coursGrp}
				{/if}
				</label>
			{/if}
			
			{if isset($listeEleves)}
				{include file="listeEleves.tpl"}
			{/if}
		</div>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">

	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

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

</script>
