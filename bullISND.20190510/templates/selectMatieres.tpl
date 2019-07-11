<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php">
		<label for="cours">Choix de la matière</label>
		<select name="cours" id="cours">
		<option value="">Matière</option>
		{foreach from=$listeCours key=leCours item=details}
			<option value="{$leCours}"{if $cours == $leCours} selected{/if} 
			title="{$details.libelle}">[{$details.cours}] {$details.statut} {$details.libelle|truncate:30} {$details.nbheures}h</option>
		{/foreach}
		</select>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showCoursGrp">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {
	$("#cours").change(function(){
		if ($(this).val() != '') {
			$("#wait").show();
			$("#formSelecteur").submit();
			}
			else return false;
		})

	
})

</script>
