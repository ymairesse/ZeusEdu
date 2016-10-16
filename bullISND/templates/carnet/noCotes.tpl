<div class="container">
	{assign var=bull value=$bulletin-1}
	<div class="alert alert-danger alert-dismissable">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		<h3>Bulletin one click</h3>
		<p><img src="images/sorryDave.png" alt="Sorry Dave" style="float:left; padding: 0 2em 0 0"><strong>I'm sorry, Dave. I'm afraid I can't do that.</strong></p>
		<p>Aucune cote à transférer: le carnet de cotes est vide pour le cours
			<br>
			<strong>{$listeCours.$coursGrp.libelle} ({$coursGrp})</strong> et
			<br>pour la période <strong>{$bulletin} ({$NOMSPERIODES.$bull})</strong></p>
	</div>
</div>
