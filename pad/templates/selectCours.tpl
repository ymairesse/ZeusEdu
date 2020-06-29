<div id="selecteur" class="noprint" style="clear:both" class="form-inline">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		<div class="input-group">
			<select name="coursGrp" id="coursGrp" class="form-control">
			<option value="">Cours</option>
			{foreach from=$listeCours key=k item=unCours}
				<option value="{$k}"{if isset($coursGrp) && ($k == $coursGrp)} selected="selected"{/if}>
					{if ($unCours.nomCours != '')} [{$unCours.nomCours}] {/if}
					{$unCours.statut} {$unCours.nbheures}h {$unCours.libelle} - {$unCours.annee} ({$k})
				</option>
			{/foreach}
			</select>
		</div>
		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}" id="mode">
		{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#formSelecteur").submit(function(){

		if ($("#coursGrp").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})

	$("#coursGrp").change(function(){
		if ($("#coursGrp").val() != '') {
			$("#formSelecteur").submit();
			}
		})
	})

</script>
