{* Permet de sélectionner un niveau d'étude puis un cours parmi ceux qui sont donnés à ce niveau*} {* demande une $listeNiveaux; la liste des cours est chargée en arrière-plan en fonction du niveau sélectionné *}

<div id="selecteur" class="noprint" style="clear:both" role="form" class="form-inline">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="niveau" id="niveau">
			<option value="">Niveau</option>
			{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}" {if isset($niveau) && ($unNiveau eq $niveau)}selected{/if}>{$unNiveau}</option>
			{/foreach}
		</select>
		<button type="submit" class="btn btn-primary btn-xs">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="show">
	</form>
</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#formSelecteur").submit(function() {
			if ($("#niveau").val() != "") {
				$("#wait").show();
				$("#corpsPage").hide();
			} else return false;
		})

		$("#niveau").change(function() {
			$("#formSelecteur").submit();
		})

	})
</script>
