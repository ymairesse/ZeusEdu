<div class="container">
{if $link != ''}
<h2>Création du fichier terminée</h2>
<p> Veuillez cliquer sur le lien pour le télécharger</p>
<span class="link">
	{if $mode == 'bulletinIndividuel'}
		<a href='pdf/{$acronyme}/{$matricule}.pdf'>
			<img class="photoEleve" src="../photos/{$listeElevesClasse.$matricule.photo}.jpg" alt="{$matricule}" style="width:150px">
			{$matricule}.pdf</a>
	{/if}
	{if $mode == 'bulletinClasse'}<a href='pdf/{$acronyme}/{$classe}-{$bulletin}.pdf'>Classe {$classe} Bulletin {$bulletin}</a>{/if}
	{if $mode == 'niveau'}<a href='pdf/{$acronyme}/niveau_{$niveau}-Bulletin_{$bulletin}.zip'>Bulletins Niveau {$niveau}</a>{/if}
</span>
{else}
<h2>Pas de bulletin disponible pour l'élève</h2>
{/if}
</div>