<div class="noprint notice">
{if isset($fichierPDF)}
<div class="btn-group pull-right">
	<a type="button" class="btn btn-default btn-sm" href="pdf/{$fichierPDF}.pdf" title="Télécharger les pages au format PDF" target="_blank">
	 	<i class="fa fa-file-pdf-o fa-lg" style="color:red"></i> {$fichierPDF}</a>
	{/if}
	{if isset($fichierCSV)}
	<a type="button" class="btn btn-default btn-sm" href="csv/{$fichierCSV}.csv" title="Télécharger la liste au format CSV (tableur)">
		<i class="fa fa-file-excel-o fa-lg" style="color:green"></i> {$fichierCSV}</a>
	{/if}
</div>
Pour l'impression, préférez la version PDF proposée ci-contre <i class="fa fa-file-pdf-o fa-lg" style="color:red"></i>.<br>
Les listes d'élèves, prêtes pour le tableur <i class="fa fa-file-excel-o fa-lg" style="color:green"></i>, sont aussi disponibles ci-contre (format CSV).
</div>
