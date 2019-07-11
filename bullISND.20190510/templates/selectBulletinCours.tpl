<div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		<label for="bulletin">Bulletin n° </label>
		<select name="bulletin" id="bulletin" class="form-control input-sm">
		{section name=boucleBulletin start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.boucleBulletin.index}"
					{if isset($bulletin) && $smarty.section.boucleBulletin.index == $bulletin} selected="selected"{/if}>
				{$smarty.section.boucleBulletin.index}</option>
		{/section}
	</select>

	<select name="coursGrp" id="coursGrp" class="form-control input-sm">
		<option value="">Cours</option>
		{if isset($listeCours)}
		{foreach from=$listeCours key=unCoursGrp item=unCours}
			<option value="{$unCoursGrp}"{if isset($coursGrp) && ($unCoursGrp == $coursGrp)} selected{/if}>
				{$unCours.statut} {$unCours.nbheures}h - {if ($unCours.nomCours != '')} [{$unCours.nomCours}] {/if}
				{$unCours.libelle} {$unCours.annee} ({$unCours.coursGrp})</option>
		{/foreach}
		{/if}
	</select>

	<label for="tri">Ordre</label>
	<select name="tri" id="tri" class="form-control input-sm">
		<option value="alpha"{if $tri == 'alpha'} selected="selected"{/if}>Alphabétique</option>
		<option value="classes"{if $tri == 'classes'} selected="selected"{/if}>Par classes</option>
	</select>

	{* si un cours est sélectionné, on présente le bouton OK *}
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showCotes">
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
