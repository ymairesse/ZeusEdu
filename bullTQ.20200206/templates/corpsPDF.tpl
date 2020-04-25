<div class="container">
	
	<h2>Création du fichier terminée</h2>
	<p> Veuillez cliquer sur le lien pour le télécharger</p>
	<span class="link">
		{if $mode == 'indivPDF'}
			<a href='pdf/{$acronyme}/{$matricule}.pdf'>
				<img class="photoEleve" src="../photos/{$matricule}.jpg" alt="{$matricule}" style="width:150px">
				{$matricule}.pdf</a>
		{/if}
		{if $mode == 'classePDF'}<a href='pdf/{$acronyme}/{$classe}.pdf'>Classe {$classe}</a>{/if}
		{if $mode == 'niveau'}<a href='pdf/{$acronyme}/niveau_{$niveau}.zip'>Bulletins Niveau {$niveau}</a>{/if}
	</span>

</div>  <!-- container -->