<div class="noprint notice">
{if isset($fichierPDF)}
<div class="btn-group pull-right">
	<a type="button" class="btn btn-primary btn-sm" href="pdf/{$fichierPDF}.pdf" title="Télécharger les pages au format PDF" target="_blank">
		<img src="../images/pdf.png" alt="PDF">{$fichierPDF}</a>
	{/if}
	{if isset($fichierCSV)}
	<a type="button" class="btn btn-primary btn-sm" href="csv/{$fichierCSV}.csv" title="Télécharger la liste au format CSV (tableur)">
		<img src="../images/tableur.png" alt="tableur">{$fichierCSV}</a>
	{/if}
</div>
Pour l'impression, préférez la version PDF proposée ci-contre <img src="../images/pdf.png" alt="pdf">.<br>
Les listes d'élèves, prêtes pour le tableur <img src="../images/tableur.png" alt="csv">, sont aussi disponibles ci-contre (format CSV).
</div>
