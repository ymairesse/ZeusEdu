{assign var=bull value=$bulletin-1}
<div id="messageErreur" title="Bulletin one click" style="display:none">
	<p>Aucune cote à transférer: le carnet de cotes est vide pour le cours <br>
	<strong>{$listeCours.$coursGrp.libelle} ({$coursGrp})</strong> et <br>
	pour la période <strong>{$bulletin} ({$NOMSPERIODES.$bull})</strong></p>
</div>
<div style="height:5000px"><!-- hauteur suffisante pour remplir l'écran de haut en bas -->
</div>
