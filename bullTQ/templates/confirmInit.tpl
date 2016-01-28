<div class="container">
	
<div class="questionImportante">
<fieldset style="clear:both">
	<legend>Effacement définitif</legend>
	<form name="form" id="confirmDel" action="index.php" method="POST">

	<p>Veuille confirmer la réinitialisation définitive de <strong>tous les bulletins</strong>.</p>
	<p>Attention, la décision est irrévocable. Il ne faut plus utiliser cette fonction après le début de l'année scolaire!!!</p>

	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="submit" value="Supprimer" name="OK" id="envoi">
	</form>
</fieldset>
</div>

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$("#confirmDel").submit(function(){
			if (!(confirm("Vous savez ce que vous faites, vous êtes prévenu")))
				return false;
			});
		})

</script>
