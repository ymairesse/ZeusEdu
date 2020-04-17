<div id="selecteur" class="selecteur noprint" style="clear:both">

<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

	<select name="coursGrp" id="coursGrp" class="form-control input-sm">
		<option value="">Cours</option>
		<option value="synoptique"{if isset($coursGrp) && $coursGrp == 'synoptique'} selected{/if}>Vue synoptique (tous les cours)</option>
		{foreach from=$listeCours key=unCoursGrp item=unCours}
			<option value="{$unCoursGrp}"{if isset($coursGrp) && ($unCoursGrp == $coursGrp)} selected="selected"{/if}>
				{if isset($unCours.nomCours) && ($unCours.nomCours != '')} [{$unCours.nomCours}] {/if}
				{$unCours.statut} {$unCours.nbheures}h {$unCours.libelle} - {$unCours.annee} ({$unCoursGrp})
			</option>
		{/foreach}
	</select>

	<button type="submit" class="btn btn-primary btn-sm">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode|default:'voir'}">
	<input type="hidden" name="etape" value="show">
	<input type="hidden" name="type" value="coursGrp">

</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#coursGrp").change(function(){
		$("#wait").show();
		$.blockUI();
		$("#formSelecteur").submit();
		})
})

</script>
