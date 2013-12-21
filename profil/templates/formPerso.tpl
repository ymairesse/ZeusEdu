<script type="text/javascript" src="../js/jquery.form.js"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script type="text/javascript">
{literal}
$(document).ready (function() {
    // sera appelé au démarrage et à l'arrêt d'une fonction Ajax
    $().ajaxStart($.blockUI).ajaxStop($.unblockUI);
    
    $("#formPerso").validate({ })
    
    // selectionner le premier champ du formulaire
    $("input:visible:enabled:first").select();
})
{/literal}
</script>
<form method="post" action="index.php" name="form1" autocomplete="off" id="formPerso">
	<fieldset style="clear:both"><legend>Informations Personnelles</legend>
		<div class="blocGauche">
			<p><label>Nom d'utilisateur</label> <strong>{$identite.acronyme}</strong>
			<input type="hidden" name="acronyme" value="{$identite.acronyme}"></p>
			<p><label>Nom</label>{$identite.nom}
			<input type="hidden" name="nom" value="{$identite.nom}"></p>
			<p><label>Prénom</label>{$identite.prenom}
			<input type="hidden" name="prenom" value="{$identite.prenom}"></p>
			<p><label>Sexe:</label>{if $identite.sexe =="M"}M{else}F{/if}
			<input type="hidden" name="sexe" value="{$identite.sexe}"></p>
		</div>
		<div class="blocDroit">
			<p>
				<label class="email required" for="mail">Mail*</label>
				<input maxlength="40" size="15" name="mail" id="mail" value="{$identite.mail}">
			</p>
			<p>
				<label for="telephone">Téléphone*</label>
				<input maxlength="40" size="15" name="telephone" id="telephone" value="{$identite.telephone}">
			</p>
			<p>
				<label for="GSM">GSM*</label>
				<input maxlength="40" size="15" name="GSM" id="GSM" value="{$identite.GSM}">
			</p>
		</div>
	</fieldset>
	<fieldset style="clear:both">
		<legend>Domicile</legend>
			<p>
			<label for="adresse">Adresse</label>
			<input maxlength="40" size="30" name="adresse" id="adresse" value="{$identite.adresse}">
			</p>
			<p>
			<label for="codePostal">Code Postal*</label>
			<input maxlength="6" size="6" name="codePostal" id="codePostal" value="{$identite.codePostal}">
			</p>
			<p>
			<label for="commune">Commune*</label>
			<input maxlength="40" size="30" name="commune" id="commune" value="{$identite.commune}">
			</p>
			<p>
			<label for="pays">Pays*</label>
			<input maxlength="10" size="10" name="pays" id="pays" value="{$identite.pays}">
			</p>
	</fieldset>
	<div style="clear:both; text-align:center">
	<input name="action" type="hidden" value="perso">
	<input name="mode" class="submit" value="Enregistrer" type="submit" style="clear:both">
    <input name="reset" value="Annuler" type="reset">
    </div>
	</form>

