<div class="ombre noprint">
<div id="pdfcsv" style="float:right">
{if isset($fichierPDF)}
<a href="pdf/{$fichierPDF}.pdf" class="fauxBouton" title="Télécharger les pages au format PDF">
    <img src="../images/pdf.png" alt="PDF">{$fichierPDF}</a>
{/if}
{if isset($fichierCSV)}
<a href="csv/{$fichierCSV}.csv" class="fauxBouton" title="Télécharger la liste au format CSV (tableur)">
    <img src="../images/tableur.png" alt="tableur">{$fichierCSV}</a>
{/if}
</div>
<p style="font-weight: bold;" class="noprint">Pour l'impression, préférez la version PDF proposée ci-contre <img src="../images/pdf.png" alt="pdf">.<br>
Les listes d'élèves, prêtes pour le tableur <img src="../images/tableur.png" alt="csv">, sont aussi disponibles ci-contre (format CSV).</p>
</div>