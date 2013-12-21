	<h3>{$eleve.nom} {$eleve.prenom}</h3>
	<p><img src="../photos/{$eleve.codeInfo}.jpg" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" id="photo" style="width:200px" /> </p>
	<p><label>Classe</label> {$eleve.classe}<small>{$groupe} [Titulaire(s): {$titulaires}]</small> </p>
	<p><label>Date de naissance</label> {$eleve.DateNaiss} 
	<small>[Âge approx. {$age.annees} ans {if !($age.mois == 0)}{$age.mois} mois{/if} {if !($age.jours == 0)}{$age.jours} jour(s){/if}]</small></p>
	<p><label>Adresse</label>{$eleve.adresseEleve}</p>
	<p><label>Code Postal</label>{$eleve.cpostEleve} <label>Commune</label>{$eleve.localiteEleve}</p>
<ul class="detailsEleve">
	<li>Coordonnées de la personne responsable
		<ul>
			<li><label>Responsable</label>&nbsp;{$eleve.nomResp}</li>
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
			<li><label>e-mail</label>{$eleve.mailPere}</li>
			<li><label>Téléphone</label>{$eleve->telPere}</li>
			<li><label>GSM</label>{$eleve.gsmPere}</li>
		</ul>
	</li>
	<li>Coordonnées de la mère de l'élève
		<ul>
			<li><label>Nom</label>{$eleve.nomMere}</li>
			<li><label>e-mail</label>{$eleve.mailMere}</li>
			<li><label>Téléphone</label>{$eleve->telMere}</li>
			<li><label>GSM</label>{$eleve.gsmMere}</li>
		</ul>
	</li>
</ul>
