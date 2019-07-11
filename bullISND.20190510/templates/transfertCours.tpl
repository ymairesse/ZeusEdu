<h3>Transfert d'élèves d'un cours vers un autre</h3>

<form name="transfertCours" id="transfertCours" method="post" action="index.php">
	<div style="float:left">
		<h4>Cours de destination des élèves {$coursDestination}</h4>
		<select name="elevesDestination" id="elevesDestination" size="15">
		{foreach from=$listeElevesDestination key=matricule item=eleve}
		<option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
		{/foreach}
		</select>
	</div>
	
	<div style="float:left; padding-left: 2em">
		<h4>Cours d'origine des élèves {$coursOrigine}</h4>
		<select name="elevesOrigine[]" id="elevesOrigine" size="15" multiple="multiple">
		{foreach from=$listeElevesOrigine key=matricule item=eleve}
		<option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
		{/foreach}
		</select>
		<br>
	<input type="submit" name="envoyer" value="<<< Déplacer" id="envoyer">		
	</div>
	
	<hr style="clear:both">
	<input type="hidden" name="coursOrigine" value="{$coursOrigine}">
	<input type="hidden" name="coursDestination" value="{$coursDestination}">
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="transfertCours">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="niveauOrigine" value="{$niveauOrigine}">
	<input type="hidden" name="niveauDestination" value="{$niveauDestination}">

</form>


<script type="text/javascript">
{literal}
	$("#transfertCours").submit(function(){
		$.blockUI();
		$("#wait").show();
	})

{/literal}

</script>
		
