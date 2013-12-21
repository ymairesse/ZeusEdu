<form name="modifMedical" id="modifMedical" method="POST" action="index.php">
	<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>
	
	<a href="index.php?action=parEleve&amp;classe={$eleve.classe}&amp;matricule={$eleve.matricule}&amp;etape=showEleve" class="fauxBouton">
	Retour</a>
	
	<p><label>Méd. traitant</label><input type="text" name="medecin" maxlength="30" size="20" value="{$medicEleve.medecin}" id="medecin">
	<label>Télephone</label><input type="text" name="telMedecin" value="{$medicEleve.telMedecin}" maxlength="20" id="telMedecin"></p>
	<h3>Situation personnelle</h3>
	<p><img src="../photos/{$eleve.matricule}.jpg" class="photo draggable" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" 
			id="photo" style="width:100px"> </p>
	
	<p><label>Situation Famille</label><br /><textarea name="sitFamiliale" id="sitFamiliale" rows="3" cols="60">{$medicEleve.sitFamiliale}</textarea></p>
	<p><label>Anamnèse</label><br /><textarea rows="2" cols="60" name="anamnese" id="anamnese">{$medicEleve.anamnese}</textarea></p>
	<h3>Particularités</h3>
	<p><label>Médicales</label><br /><textarea rows="3" cols="60" name="medical" id="medical">{$medicEleve.medical}</textarea></p>
	<p><label>Traitement</label><br /><textarea rows="2" cols="30" name="traitement" id="traitement">{$medicEleve.traitement}</textarea></p>
	<p><label>Psy</label><br /><textarea rows="2" cols="30" name="psy" id="psy">{$medicEleve.psy}</textarea></p>
	<input type="hidden" name="matricule" value="{$eleve.matricule}">
	<input type="hidden" name="classe" value="{$eleve.classe}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input style="float:right" type="submit" name="submit" value="Enregistrer">
	<input style="float:right" type="reset" name="Annuler" value="Annuler">	
</form>

<script type="text/javascript">
{literal}
	$("document").ready(function(){
		$("#modifMedical").submit(function(){
			$("#wait").show();
		})
{/literal}
})
</script>