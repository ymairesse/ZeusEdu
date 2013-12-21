<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.prenom} {$eleve.nom}" 
		title="{$eleve.prenom} {$eleve.nom}" id="photo" style="width:150px; float:right;" class="photoEleve" />
<h2 title="{$eleve.matricule}">{$eleve.nom} {$eleve.prenom}: {$eleve.groupe}</h2>
<div id="accordion" style="width:auto; margin-right: 160px;">
	<h3>Coordonnées de l'élève</h3>
	<div>
	<p><label>Classe</label> {$eleve.classe}
	{if $eleve.classe != $eleve.groupe} - <small>{$eleve.groupe}{/if} [Titulaire(s): {", "|implode:$titulaires}]</small> </p> 
	<p><label>Date de naissance</label> {$eleve.DateNaiss}
	<small>[Âge approx. {$age.Y} ans {if !($age.m == 0)}{$age.m} mois{/if}
		{if !($age.d == 0)}{$age.d} jour(s){/if}]</small></p>
	<p><label>Comm. de naiss.</label>{$eleve.commNaissance|default:'-'}</p>
	<p><label>Adresse</label>{$eleve.adresseEleve}</p>
	<p><label>Code Postal</label>{$eleve.cpostEleve}</p>
	<p><label>Commune</label>{$eleve.localiteEleve}</p>
	</div>
	<h3>Coordonnées de la personne responsable</h3>
	<div>
		<ul>
			<li><label>Responsable</label>&nbsp;{$eleve.nomResp}</li>
			<li><label>e-mail</label>&nbsp;<a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></li>
			<li><label>Téléphone</label>&nbsp;{$eleve.telephone1}</li>
			<li><label>GSM</label>&nbsp;{$eleve.telephone2}</li>
			<li><label>Téléphone bis</label>&nbsp;{$eleve.telephone3}</li>
			<li><label>Adresse</label>{$eleve.adresseResp}</li>
			<li><label>Code Postal</label>{$eleve.cpostResp} <label>Commune</label>{$eleve.localiteResp}</li>
		</ul>
	</div>
	<h3>Coordonnées du père de l'élève</h3>
	<div>
		<ul>
			<li><label>Nom</label>{$eleve.nomPere}</li>
			<li><label>e-mail</label><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></li>
			<li><label>Téléphone</label>{$eleve.telPere}</li>
			<li><label>GSM</label>{$eleve.gsmPere}</li>
		</ul>
	</div>
	<h3>Coordonnées de la mère de l'élève</h3>
		<div>
		<ul>
			<li><label>Nom</label>{$eleve.nomMere}</li>
			<li><label>e-mail</label><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></li>
			<li><label>Téléphone</label>{$eleve.telMere}</li>
			<li><label>GSM</label>{$eleve.gsmMere}</li>
		</ul>
		</div>
</div>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$("#accordion").accordion();
	})
	{/literal}
</script>