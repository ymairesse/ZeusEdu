<h3>Mots de passe élèves</h3>
<form name="complexite" id="complexite" action="index.php" method="POST">
	<p>Choix de la longueur des mots de passe: entre 3 et 12 caractères</p>
	<label for="longueur">Longueur</label>
	<input type="text" name="longueur" id="longueur" size="3" maxlenght="2">
	<input type="submit" name="submit" value="Enregistrer">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="save">
</form>


<script type="text/javascript">

	$(document).ready(function(){

		$( "#complexite" ).validate({
			rules: {
				longueur: {
					required: true,
					min: 3,
					max: 12
				}
			},
		errorElement: "span"
		});
	})

</script>
