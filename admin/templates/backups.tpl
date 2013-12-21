<h1>Derniers backups admin</h1>
<table class="tableauAdmin" style="margin:auto">
	<tr>
		<th style="width:20em">Nom du fichier</th>
		<th style="width:12em">Date</th>
		<th style="width:6em">Taille</th>
		<th>Effacer</th>
	</tr>
	{foreach from=$listeFichiers item=unFichier}
	<tr>
		<td><a href="./save/{$unFichier.fileName}" target="_blank">{$unFichier.fileName}</a></td>
		<td>{$unFichier.fileDate|date_format:"%x"}</td>
		<td>
			{if $unFichier.fileSize > 1000000}
			{math|string_format:"%.0f" equation="size / 1024 / 1024" size=$unFichier.fileSize} Mio
			{else}
			{math|string_format:"%.0f" equation="size / 1024" size=$unFichier.fileSize} Kio
			{/if}
		</td>
		<td style="text-align:center">
			<a href="index.php?action=backup&amp;mode=delete&amp;fileName={$unFichier.fileName}">
			<img src="../images/suppr.png" alt="supprimer" title="Effacer le fichier">
			</a>
		</td>
	</tr>
	{/foreach}
</table>
