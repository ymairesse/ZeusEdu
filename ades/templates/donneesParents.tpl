<ul class="detailsEleve">
	<li>Coordonnées de la personne responsable
		<ul>
			<li><label>Responsable</label>{$eleve.nomResp}</li>
			<li><label>e-mail</label>&nbsp;<a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></li>
			<li><label>Téléphone</label>&nbsp;{$eleve.telephone1}</li>
			<li><label>GSM</label>&nbsp;{$eleve.telephone2}</li>
			<li><label>Téléphone bis</label>&nbsp;{$eleve.telephone3}</li>
			<li><label>Adresse</label>{$eleve.adresseResp}</li>
			<li><label>Code Postal</label>{$eleve.cpostResp} <label>Commune</label>{$eleve.localiteResp}</li>
		</ul>
	</li>
	<li>Coordonnées du père de l'élève
		<ul>
			<li><label>Nom</label>{$eleve.nomPere}</li>
			<li><label>e-mail</label><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></li>
			<li><label>Téléphone</label>{$eleve.telPere}</li>
			<li><label>GSM</label>{$eleve.gsmPere}</li>
		</ul>
	</li>
	<li>Coordonnées de la mère de l'élève
		<ul>
			<li><label>Nom</label>{$eleve.nomMere}</li>
			<li><label>e-mail</label><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></li>
			<li><label>Téléphone</label>{$eleve.telMere}</li>
			<li><label>GSM</label>{$eleve.gsmMere}</li>
		</ul>
	</li>
</ul>