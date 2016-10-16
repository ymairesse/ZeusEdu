<div class="container">
	{assign var=bull value=$bulletin-1}
	<div class="alert alert-danger alert-dismissable">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		<h3>Pondération des périodes</h3>
		<p><img src="images/sorryDave.png" alt="Sorry Dave" style="float:left; padding: 0 2em 0 0"><strong>I'm sorry, Dave. I'm afraid I can't do that.</strong></p>
		<p>Il n'y a pas de pondération au bulletin pour le cours <strong>{$listeCours.$coursGrp.libelle} ({$coursGrp})</strong> et
			<br> pour la période <strong>{$bulletin} ({$NOMSPERIODES.$bull})</strong></p>
		<p>Vous pouvez corriger cela là: <a href="index.php?action=gestionBaremes&amp;mode=voir">Gérer les pondérations</a></p>

		</p>
	</div>
</div>
