<h3 style="clear:both">Liste des fichiers PDF disponibles</h3>
{if isset($confirmDeletePDF)}
<div class="attention">
    <span class="icon">info</span>
    <span class="title">Confirmation</span>
    <span class="texte">Le fichier {$fileName} a été effacé</span>
</div>
{/if}

{if isset($listeFichiers) && (count($listeFichiers) > 0)}

	<form name="gestPDF" id="gestPDF" action="index.php" method="POST">
	<input type="submit" name="Supprimer" value="Effacer">
	<input type="reset" name="reset" value="Annuler">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
		
	<table class="tableauAdmin" style="width:40em; margin:auto">
		<tr>
			<th style="width:20em">Nom du fichier</th>
			<th style="width:12em">Date</th>
			<th style="width:6em">Taille</th>
			<th>Effacer <input type="checkbox" value="" name="wtf" id="checkAll"></th>
		</tr>
		{foreach from=$listeFichiers item=unFichier}
		<tr>
			<td><a href="./pdf/{$acronyme}/{$unFichier.fileName}" target="_blank">{$unFichier.fileName}</a></td>
			<td>{$unFichier.fileDate|date_format:"%x"}</td>
			<td>
				{if $unFichier.fileSize > (1024*1024)}
				{math|string_format:"%.0f" equation="size / 1024 / 1024" size=$unFichier.fileSize} Mio
				{else}
				{math|string_format:"%.0f" equation="size / 1024" size=$unFichier.fileSize} Kio
				{/if}
			</td>
			<td style="text-align:center">
				<input type="checkbox" name="del#{$unFichier.fileName}" class="delete" value="{$unFichier.fileName}" title="Effacer ce fichier">
				</a>
			</td>
		</tr>
		{/foreach}
	</table>
	</form>
{else}
	<div class="attention">
		<sapn class="title">Remarque</sapn>
		<span class="texte">Pas de fichier PDF disponible</span>
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

		
		$("#checkAll").click(function(){
			$(".delete").trigger("click");
			})
		
	})
	{/literal}
</script>
