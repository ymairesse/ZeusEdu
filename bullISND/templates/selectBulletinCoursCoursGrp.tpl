<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		Bulletin n° <select name="bulletin" id="bulletin">
		{section name=bulletins start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.bulletins.index}"
					{if $smarty.section.bulletins.index == $bulletin}selected{/if}>
				{$smarty.section.bulletins.index}
			</option>
		{/section}
		</select>

		<select name="cours" id="cours">
		<option value="">Cours</option>
		{foreach from=$listeCours key=leCours item=details}
			<option value="{$leCours}"{if $cours eq $leCours} selected{/if} 
			title="{$details.libelle}">[{$details.cours}] {$details.statut} {$details.libelle|truncate:30} {$details.nbheures}h</option>
		{/foreach}
		</select>

	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showCoursGrp">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {
	$("#cours").change(function(){
		if ($(this).val() != '') {
			$.blockUI();
			$("#wait").show();
			}
			else return false;
		})

	
})
{/literal}
</script>
