<div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" action="index.php" method="POST" role="form" class="form-inline">
		<div class="form-group">
			<label for="niveaux">Niveau d'étude</label>
			<select class="form-control" name="niveau">
				<option value="">Niveau</option>
				{foreach from=$listeNiveaux item=unNiveau}
					<option value="{$unNiveau}"{if isset($niveau) && $unNiveau == $niveau} selected{/if}>{$unNiveau}e année</option>
				{/foreach}
			</select>
		</div>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="partager">
	<input type="hidden" name="mode" value="parNiveau">

	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$("#corpsPage").hide();
	})



})

</script>
