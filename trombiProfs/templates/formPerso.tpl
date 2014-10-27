<div id="accordion">
<h2 style="clear:both; font-size:1.5em; font-weight:bold">Informations Personnelles</h2>
<div>
	<div class="blocGauche">
	<div id="photo">
	{if isset($photo)}
	<img src="../photosProfs/{$photo}.jpg" class="photo" width="150px" />
	{else}
		{if $prof.sexe == 'M'}
		<img src="../images/profMasculin.png" title="{$prof.prenom} n'a pas (encore) souhaité envoyer sa photo" alt"photo">
			{else}
			<img src="../images/profFeminin.png" title="{$prof.prenom} n'a pas (encore) souhaité envoyer sa photo" alt"photo">
		{/if}
	{/if}

	</div>
		<p><span class="etiquette">Abréviation: </span><strong>{$prof.acronyme}</strong></p>
		<p><span class="etiquette">Nom: </span><strong>{$prof.nom}</strong></p>
		<p><span class="etiquette">Prénom: </span><strong>{$prof.prenom}</strong></p>
		<div class="notice">La photo aussi est modifiable dans votre "profil"</div>
	</div>
	<div class="blocDroit">
		<p><span class="etiquette">Mail: </span><strong><a href="mailto:{$prof.mail}">{$prof.mail|default:'--'}</a></strong></p>
		<p><span class="etiquette">Téléphone: </span> <strong>{$prof.telephone|default:'--'}</strong></p>
		<p><span class="etiquette">GSM: </span><strong>{$prof.GSM|default:'--'}</strong></p>
	</div>
</div>

<h2 style="clear:both; font-size:1.5em; font-weight:bold">Informations Professionnelles</h2>
	<div>
	<p><label for="titulaire">Titulaire de: </label><strong>{", "|implode:$titulaire|default:'-'}</strong></p>
	<h3>Liste des cours</h3>
		<table class="tableauAdmin">
			<tr>
				<th>Année</th>
				<th>Nom du cours</th>
				<th>Statut</th>
				<th>Nombre d'heures</th>
				<th>Abréviation</th>
			</tr>
		{foreach from=$cours item=unCours}
			<tr>
				<td>{$unCours.annee}e</td>
				<td>{$unCours.libelle}</td>
				<td>{$unCours.statut}</td>
				<td>{$unCours.nbheures}h</td>
				<td>{$unCours.coursGrp}</td>
			</tr>
		{/foreach}
		</table>
	</div>

<h2 style="clear:both; font-size:1.5em; font-weight:bold">Domicile</h2>
	<div>
	{if isset($prof->identite.adresse) || isset($prof->identite.commune)}
		<div style="float:right; width:500px; height:200px" id="map"></div>
	{/if}

	<p><span class="etiquette">Adresse:</span><strong>{$prof.adresse|default:'--'}</strong></p>
	<p><span class="etiquette">Code postal:</span><strong>{$prof.codePostal|default:'--'}</strong></p>
	<p><span class="etiquette">Commune:</span><strong>{$prof.commune|default:'--'}</strong></p>
	<p><span class="etiquette">Pays:</span><strong>{$prof.pays|default:'--'}</strong></p>
</div>	

</div> <!-- accordion -->

<script type="text/javascript">
	{literal}
	$(document).ready(function(){

	$("#accordion").accordion();
	})
		
	{/literal}
</script>
