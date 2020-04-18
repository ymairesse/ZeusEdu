<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		<div class="form-group">
			<label for="niveau">Niveau</label>
			<select name="niveau" id="selectNiveau" class="form-control input-sm">
				<option value="">Niveau</option>
				{foreach from=$listeNiveaux item=unNiveau}
					<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>
					{$unNiveau}{if $unNiveau == 1}ères{else}èmes{/if}
				</option>
				{/foreach}
			</select>
		</div>
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="show">
	<input type="hidden" name="type" id="type" value="niveau">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {


	$("#formSelecteur").submit(function(){
		if ($("#niveau").val() != "") {
			$("#wait").show();
			$("#corpsPage").hide();
			}
			else return false;
	})

})

</script>
