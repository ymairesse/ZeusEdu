<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		<select name="coursGrp" id="coursGrp" class="form-control input-sm">
			<option value="">Cours</option>
			{foreach from=$listeCours key=k item=unCours}
			<option value="{$k}" {if $k == $coursGrp} selected="selected" {/if}>
				{if isset($unCours.nomCours)} [{$unCours.nomCours}] {/if} {$unCours.statut} {$unCours.nbheures}h {$unCours.libelle} - {$unCours.annee} ({$k})
			</option>
			{/foreach}
		</select>
		<button type="submit" class="btn btn-primary btn-sm">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}">

	</form>

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#coursGrp").change(function() {
			$("#wait").show();
			$.blockUI();
			$("#formSelecteur").submit();
		})
	})
</script>
