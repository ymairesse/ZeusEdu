<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$("#tabs").tabs();
	})
	{/literal}
</script>
<h2>Profil personnel</h2>
<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Informations personnelles</a></li>
		<li><a href="#tabs-2">Domicile</a></li>
		<li><a href="#tabs-3">Mot de passe</a></li>
		<li><a href="#tabs-4">Vos connexions</a></li>
	</ul>

<div id="tabs-1">
	<div class="blocGauche">
		<p><label>Nom d'utilisateur</label><strong> {$identite.acronyme}</strong></p>
		<p><label>Nom</label><strong> {$identite.nom}</strong></p>
		<p><label>Prénom</label><strong> {$identite.prenom}</strong></p>
		<p><label>Sexe</label><strong> {$identite.sexe}</strong></p>

		<p><label>Mail*</label><strong><a href="mailto:{$identite.mail}">{$identite.mail}</a></strong></p>
		<p><label>Téléphone*</label><strong> {$identite.telephone}</strong></p>
		<p><label>GSM*</label><strong> {$identite.GSM}</strong></p>
	</div>
	<div class="blocGauche">
		<p><label>Adresse</label><strong>{$identite.adresse}</strong></p>
		<p><label>Commune</label><strong>{$identite.commune}</strong></p>
		<p><label>Code Postal*</label><strong>{$identite.codePostal}</strong></p>
		<p><label>Pays</label><strong>{$identite.pays}</strong></p>
		<p><a href="index.php?action=perso" class="fauxBouton">Modifier</a></p>
		<p>* = information librement modifiable</p>
	</div>
	<div class="blocDroit">
		<div id="photo">
			<a href="index.php?action=photo" title="Cliquer pour changer la photo" alt="{$identite.acronyme}">
			{if isset($photo)}
			{* ?rand=$smarty.now = astuce pour forcer la mise à jour de l'image après upload *}
			<img src="../photosProfs/{$identite.acronyme}.jpg?rand={$smarty.now}" width="150px"/>
			{else}
				{if $identite.sexe == 'M'}
				<img src="../images/profMasculin.png">
					{else}
					<img src="../images/profFeminin.png">
				{/if}
			{/if}
			</a>
			<br>
			<a class="fauxBouton" href="index.php?action=photo" title="Cliquer pour changer la photo" alt="{$identite.acronyme}">Changer la photo</a>
		</div>
	</div>
<div style="clear:both">&nbsp;</div>
</div>

<div id="tabs-2">
	<p><label>Adresse</label><strong>{$identite.adresse}</strong></p>
	<p><label>Commune</label><strong>{$identite.commune}</strong></p>
	<p><label>Code Postal*</label><strong>{$identite.codePostal}</strong></p>
	<p><label>Pays</label><strong>{$identite.pays}</strong></p>
	<p><a href="index.php?action=perso" class="fauxBouton">Modifier</a></p>
	<p>* = information librement modifiable</p>
</div>
<div id="tabs-3">
	<p><label class="etiquette">Mot de passe*</label><strong> xxxxxx</strong></p>
	<p><a href="index.php?action=mdp" class="fauxBouton">Modifier</a></p>
	<p>* = information librement modifiable</p>
</div>
<div id="tabs-4">
	<fieldset style="clear:both"><legend>Vos connexions</legend>
	<div id="logins">
	<table class="tableauAdmin">
		<tr>
			<th width="100">Date</th>
			<th width="100">Heure</th>
			<th width="150">Adresse IP*</th>
			<th>Hôte</th>
		</tr>
		{foreach from=$logins item=unLogin}
		<tr>
			<td>{$unLogin.date}</td>
			<td>{$unLogin.heure}</td>
			<td>{$unLogin.ip}</td>
			<td>{$unLogin.host}</td>
		</tr>
		{/foreach}
	</table>
	</div>
	<p class="micro">* L'adresse IP est une adresse unique dans le monde, un peu semblable à un numéro de téléphone, et qui identifie une connexion à l'Internet.<br>
	Plusieurs ordinateurs peuvent partager la même adresse IP s'ils sont connectés au même modem (cas d'une école, par exemple).<br>
	Il peut arriver que l'adresse IP qui vous est attribuée change d'un jour à l'autre. Mais le nom du fournisseur d'accès reste fixe si vous gardez le même contrat.</p>
	</fieldset>
</div>

</div>
