<div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<div class="form-group">
			<label for="bulletin">Bulletin n°</label>
			<select name="bulletin" id="bulletin" class="form-control">
			{foreach from=$listeBulletins item=noBulletin}
				<option value="{$noBulletin}" {if isset($bulletin) && $noBulletin == $bulletin}selected{/if}>
					{$noBulletin}
				</option>
			{/foreach}
			</select>
		</div>

		<div class="form-group">

		<select name="coursGrp" id="coursGrp" class="form-control">
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
	{if isset($coursGrp)}<button type="submit" class="btn btn-primary">OK</button>{/if}
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
