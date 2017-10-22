<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		Bulletin n° <select name="bulletin" id="bulletin" class="form-control input-sm">
		{section name=boucleBulletin start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.boucleBulletin.index}" {if $smarty.section.boucleBulletin.index == $bulletin}selected{/if}>{$smarty.section.boucleBulletin.index}</option>
		{/section}
	</select>
	Année:
	<select name="niveau" id="niveau" class="form-control input-sm">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if $unNiveau eq $niveau} selected{/if}>{$unNiveau}</option>
		{/foreach}
	</select>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showNiveau">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {
	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$.blockUI();
		})
	})

</script>
