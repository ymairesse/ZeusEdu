<h3>Liste des sauvegardes disponibles</h3>
{if isset($confirmDeleteBU)}
<div class="attention">
    <span class="icon">info</span>
    <span class="title">Confirmation</span>
    <span class="texte">Le fichier {$fileName} a été effacé</span>
</div>
{/if}

{if isset($fileName)}
<div class="attention">
	<span class="title">Confirmation</span>
	<span class="texte">Le fichier {$fileName} contient votre dernier backup</span>
	<span class="icon">info</span>
</div>
{/if}

{if isset($listeFichiers)}
<div class="widget w50">
<table class="tableauAdmin" style="">
	<tr>
		<th>Nom du fichier</th>
		<th>Date</th>
		<th>Taille</th>
		<th>Effacer</th>
	</tr>
	{foreach from=$listeFichiers item=unFichier}
	<tr>
		<td><a href="./save/{$unFichier.fileName}" target="_blank">{$unFichier.fileName}</a></td>
		<td>{$unFichier.fileDate|date_format:"%x"}</td>
		<td>
			{if $unFichier.fileSize > (1024*1024)}
			{math|string_format:"%.0f" equation="size / 1024 / 1024" size=$unFichier.fileSize} Mio
			{else}
			{math|string_format:"%.0f" equation="size / 1024" size=$unFichier.fileSize} Kio
			{/if}
		</td>
		<td style="text-align:center">
			<a href="index.php?action=backup&amp;mode=delete&amp;fileName={$unFichier.fileName}" class="delete">
			<img src="../images/suppr.png" alt="supprimer" title="Effacer le fichier">
			</a>
		</td>
	</tr>
	{/foreach}
</table>
</div>
{else}
<div class="attention">
	<sapn class="title">Remarque</sapn>
	<span class="texte">Pas de sauvegarde disponible</span>
</div>
{/if}

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$(".checkAll").click(function(){
			var checked = $(this).attr("checked");
			var id = $(this).attr("id");
			$("."+id).attr("checked", checked);
		})

		$(".delete").click(function(){
			if (!(confirm("Veuillez confirmer l'effacement définitif de ce fichier de sauvegarde")))
				return false;
			})
		
	})
	{/literal}
</script>
