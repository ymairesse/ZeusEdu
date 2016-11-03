{debug}
<div class="container">
{if $link != ''}
<h2>Création du fichier terminée</h2>
<p> Veuillez cliquer sur le lien pour le télécharger</p>
<span class="link">
	{if $mode == 'bulletinIndividuel'}
		<a href='inc/download.php?type=pfN&amp;f={$link}'>
			<img class="photoEleve" src="../photos/{$listeElevesClasse.$matricule.photo}.jpg" alt="{$matricule}" style="width:150px">
			{$matricule}.pdf</a>
	{/if}
	{if $mode == 'bulletinClasse'}<a href='inc/download.php?type=pfN&amp;f={$link}'>Classe {$classe} Bulletin {$bulletin}</a>{/if}
	{if $mode == 'niveau'}<a href='inc/download.php?type=pfN&amp;f={$link}'>Bulletins Niveau {$niveau}</a>{/if}
</span>
{else}
<h2>Pas de bulletin disponible pour l'élève</h2>
{/if}
</div>
