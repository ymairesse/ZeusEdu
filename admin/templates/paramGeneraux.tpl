<h3>Paramètres généraux</h3>
<form name="formParametres" id="formParametres" method="POST" action="index.php">
	<label for="ecole">École</label>
	<input type="text" size="30" name="ECOLE" id="ecole" value="{$parametres.ECOLE.valeur}"><span class="micro">{$parametres.ECOLE.signification	}</span><br>
	
	<label for="adresse">Adresse</label>
	<input type="text" size="45" name="ADRESSE" id="adresse" value="{$parametres.ADRESSE.valeur}"><span class="micro">{$parametres.ADRESSE.signification	}</span><br>
	
	<label for="ville">CP & Ville</label>
	<input type="text" size="45" name="VILLE" id="ville" value="{$parametres.VILLE.valeur}"><span class="micro">{$parametres.VILLE.signification	}</span><br>
	
	<label for="adresse">Téléphone</label>
	<input type="text" size="20" name="TELEPHONE" id="adresse" value="{$parametres.TELEPHONE.valeur}"><span class="micro">{$parametres.TELEPHONE.signification	}</span><br>
	
	<label for="siteweb">Site web</label>
	<input type="text" size="45" name="SITEWEB" id="siteweb" value="{$parametres.SITEWEB.valeur}"><span class="micro">{$parametres.SITEWEB.signification	}</span><br>
	
	<label for="anScol">Année scolaire</label>
	<input type="text" size="12" name="ANNEESCOLAIRE" id="anScol" value="{$parametres.ANNEESCOLAIRE.valeur}"><span class="micro">{$parametres.ANNEESCOLAIRE.signification	}</span><br>
	
	<label for="nbPeriodes">Nombre de périodes</label>
	<input type="text" size="2" name="NBPERIODES" id="nbPeriodes" value="{$parametres.NBPERIODES.valeur}"><span class="micro">{$parametres.NBPERIODES.signification}</span><br>
	
	<label for="nomPeriodes">Noms des périodes</label>
	<input type="text" size="30" name="NOMSPERIODES" id="imageSize" value="{$parametres.NOMSPERIODES.valeur}"><span class="micro">{$parametres.NOMSPERIODES.signification}</span><br>
	
	<label for="enCours">Période en cours</label>
	<input type="text" size="2" name="PERIODEENCOURS" id="enCours" value="{$parametres.PERIODEENCOURS.valeur}"><span class="micro">{$parametres.PERIODEENCOURS.signification}</span><br>
	
	<label for="niveaux">Niveaux d'études</label>
	<input type="text" size="12" name="LISTENIVEAUX" id="niveaux" value="{$parametres.LISTENIVEAUX.valeur}"><span class="micro">{$parametres.LISTENIVEAUX.signification}</span><br>
	
	<label for="sections">Sections</label>
	<input type="text" size="12" name="SECTIONS" id="sections" value="{$parametres.SECTIONS.valeur}"><span class="micro">{$parametres.SECTIONS.signification}</span><br>
	
	<label for="delibes">Périodes de délibés</label>
	<input type="text" size="20" name="PERIODESDELIBES" id="delibes" value="{$parametres.PERIODESDELIBES.valeur}"><span class="micro">{$parametres.PERIODESDELIBES.signification}</span><br>
	
	<label for="coteabs">Mentions d'absence</label>
	<input type="text" size="20" maxlength="40" name="COTEABS" id="coteabs" value="{$parametres.COTEABS.valeur}"><span class="micro">{$parametres.COTEABS.signification}</span><br>
	<label for="cotenulle">Mentions nulles</label>
	<input type="text" size="20" maxlength="40" name="COTENULLE" id="cotenulle" value="{$parametres.COTENULLE.valeur}"><span class="micro">{$parametres.COTENULLE.signification}</span><br>
	
	<label for="enCours">Images</label>
	<input type="text" size="9" name="MAXIMAGESIZE" id="imageSize" value="{$parametres.MAXIMAGESIZE.valeur}"><span class="micro">{$parametres.MAXIMAGESIZE.signification}</span><br>
	<label for="direction">Direction</label>
	<input type="text" size="30" name="DIRECTION" id="direction" value="{$parametres.DIRECTION.valeur}"><span class="micro">{$parametres.DIRECTION.signification}</span><br>
	
	<hr>
	<input type="submit" name="submit" value="Enregistrer">
	<input type="reset" name="reset" value="Annuler">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="save">
</form>
