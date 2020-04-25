<div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		<div class="input-group">
			<label for="bulletin">Bulletin n°</label>
			<select name="bulletin" id="bulletin" class="form-control-inline>
			{section name=boucleBulletin loop=$nbBulletins+1}
			<option value="{$smarty.section.boucleBulletin.index}"
					{if isset($bulletin) && $smarty.section.boucleBulletin.index == $bulletin}selected{/if}>
				{$smarty.section.boucleBulletin.index}</option>
			{/section}
			</select>
		</div>

		<div class="input-group">

		<select name="coursGrp" id="coursGrp" class="form-control-inline">
			<option value="">Cours</option>
			{if isset($listeCours)}
			{foreach from=$listeCours key=unCoursGrp item=unCours}
				<option value="{$unCoursGrp}"{if isset($coursGrp) && ($unCoursGrp == $coursGrp)} selected{/if}>
					{$unCours.statut} {$unCours.nbheures}h - {$unCours.libelle} {$unCours.annee} ({$unCours.coursGrp})</option>
			{/foreach}
			{/if}
		</select>
		</div>

	{* si un cours est sélectionné, on présente le bouton OK *}
	{if isset($coursGrp)}<button type="submit" class="btn btn-primary btn-xs">OK</button>{/if}
	<input type="hidden" name="action" value="{$action}">

	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {
	$("#formSelecteur").submit(function(){
		if ($("#coursGrp").val() == '')
			return false;
		else {
			$("#wait").show();
			$.blockUI();
			$("#corpsPage").hide();
			}
		})

	$("#coursGrp").change(function(){
	if ($(this).val() != '')
		$("#formSelecteur").submit()
		else $("#envoi").hide();
	})

	$("#bulletin").change(function(){
		if ($("#coursGrp").val() != '')
				$("#formSelecteur").submit();
				else $("#envoi").hide();
	})
})

</script>
