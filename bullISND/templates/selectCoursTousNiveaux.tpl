<div id="selecteur" class="noprint" style="clear:both">
<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="cours" id="cours">
		<option value="">Cours</option>
		{foreach from=$listeCours key=k item=unCours}
			<option value="{$k}"{if $k eq $cours} selected{/if}>
				{if ($unCours.nomCours != '')} {$unCours.nomCours}
				{else}
				{$unCours.niveau} {$unCours.statut} {$unCours.nbheures}h {$unCours.libelle} - {$unCours.annee} ({$k})
				{/if}
			</option>
		{/foreach}
	</select>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready(function(){
	$("#cours").change(function(){
		$("#wait").show();
		$("#formSelecteur").submit();
		})
	})
{/literal}
</script>
