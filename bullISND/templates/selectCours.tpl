<div id="selecteur" class="noprint" style="clear:both">
<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="coursGrp" id="coursGrp">
		<option value="">Cours</option>
		{foreach from=$listeCours key=k item=unCours}
			<option value="{$k}"{if $k == $coursGrp} selected="selected"{/if}>
				{if ($unCours.nomCours != '')} {$unCours.nomCours}
				{else}
				{$unCours.statut} {$unCours.nbheures}h {$unCours.libelle} - {$unCours.annee} ({$k})
				{/if}
			</option>
		{/foreach}
	</select>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode|default:'voir'}">
	{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready(function(){
	$("#coursGrp").change(function(){
		$("#wait").show();
		$("#formSelecteur").submit();
		})
	})
{/literal}
</script>
