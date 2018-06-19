<div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		<label for="niveau" class="sr-only">Niveau</label>
		<select name="niveau" id="niveau" class="form-control">
			<option value=''>Niveau</option>
			{foreach from=$listeNiveaux key=clef item=leNiveau}
			<option value="{$leNiveau}"	{if $leNiveau == $niveau}selected{/if}>
				{$leNiveau}
			</option>
			{/foreach}
		</select>

		<span id="choixMatiere">
		{include file='listeMatieres.tpl'}
		</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showMatiere">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#choixMatiere").on("change", "#matiere", function(){
		if ($(this).val() != '') {
			$("#wait").show();
			$("#formSelecteur").submit();
			}
			else return false;
		})

	$("#niveau").change(function(){
		var niveau = $(this).val();
		if (niveau != '') {
			$.post('inc/listeMatieres.inc.php', {
				'niveau':niveau
				},
				function (resultat) {
					$("#choixMatiere").html(resultat)
					}
				)
			}
			else $("#choixMatiere").html('');

	})

	$("#formSelecteur").submit(function(){
		if (($("#niveau").val() == '') || ($("#matiere").val() == '')) {
			return false
		}
		})

})

</script>
