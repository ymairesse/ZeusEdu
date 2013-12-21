<fieldset><legend>Informations Professionnelles</legend>
	<form method="post" action="inc/savePerso.php" name="form1" autocomplete="off" id="formPerso">
        <p>
        <label class="etiquette">Titulaire de:</label>
        [ <strong>{$identite.titulaire}</strong> ]
        </p>
        <p>
        <label class="etiquette" for="mdp">Mot de passe:</label>
        <input maxlength="12" size="12" name="mdp" id="mdp" type="password">
        </p>
        <label class="etiquette" for="mdp2">Confirmation:</label>
        <input maxlength="12" size="12" name="mdp2" id="mdp2" type="password">
        </p>
    <input name="mode" class="submit" value="Modifier" type="submit">
    <input name="reset" value="Annuler" type="reset">
    </form>		
</fieldset>
