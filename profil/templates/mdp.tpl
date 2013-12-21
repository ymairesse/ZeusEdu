<script type="text/javascript">
{literal}
$(document).ready (function() {
    
    $("#formMdp").validate({
        rules: {
            mdp2:   {required: true,
					equalTo:"#mdp",
					minlength: 6,
					maxlength: 12},
			mdp : 	{required: true,
      				minlength: 6,
      				maxlength: 12}
        },
        errorElement: "span"
    })

    // selectionner le premier champ du formulaire
    $("input:visible:enabled:first").select();
})
{/literal}
</script>

<fieldset style="clear:both"><legend>Informations Professionnelles</legend>
	<form method="post" action="index.php" name="form1" id="formMdp" autocomplete="off">
		<p><strong>{$identite.nom} {$identite.prenom}</strong></p>
        <p>
        <label for="mdp">Mot de passe:</label>
        <input maxlength="14" size="12" name="mdp" id="mdp" type="password"> (6 à 12 caractères)
        </p>
        <label for="mdp2">Confirmation:</label>
        <input maxlength="14" size="12" name="mdp2" id="mdp2" type="password">
        </p>
		<p>
    	<input name="mode" class="submit" value="Modifier" type="submit">
    	<input name="reset" value="Annuler" type="reset">
    	<input name="action" value="mdp" type="hidden">
		</p>
    </form>		
</fieldset>
