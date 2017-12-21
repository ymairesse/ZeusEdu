<div id="selecteur" class="noprint" style="clear:both">
	
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

	<select name="niveau" id="niveau" class="form-control input-sm">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)}selected{/if}>
			{$unNiveau}{if $unNiveau == 1}ère{else}ème{/if}
			</option>
		{/foreach}
	</select>

	<select id="periode" name="periode" class="form-control input-sm">
		{foreach from=$listePeriodes key=i item=unePeriode}
			<option value="{$unePeriode}"{if $unePeriode == $periode} selected{/if}>{$unePeriode} - {$nomsPeriodes.$i}</option>
		{/foreach}
	</select>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="show">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#niveau").change(function(){
		if ($('#periode').val() != '')
			$("#formSelecteur").submit();
		})

	$('#periode').change(function(){
		if ($('#niveau').val() != '')
			$("#formSelecteur").submit();
	})

	$("#formSelecteur").submit(function(){
		if (($("#niveau").val() != "") && ($('#periode').val() != '')) {
			$("#wait").show();
			$("#corpsPage").hide();
			}
			else return false;
	})

})

</script>
