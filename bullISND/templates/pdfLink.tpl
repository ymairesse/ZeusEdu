<div class="container">

<div class="col-md-8 col-xs-12">
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

<div class="col-md-4 col-xs-12">
	<div class="panel panel-info">
		<div class="panel-heading">
			<h4>Accès aux fichiers PDF</h4>
		</div>
		<div class="panel-body">
			<p class="smallNotice">Les fichiers PDF générés ici restent disponibles dans le dossier "{$module}" de votre répertoire personnel <a href="../thot/index.php?action=files&mode=mydocs">dans l'application Thot</a>.</p>
		</div>
	</div>

</div>


</div>
