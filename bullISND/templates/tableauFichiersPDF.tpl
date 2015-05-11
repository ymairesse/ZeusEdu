<div class="container">
	
		<h3 style="clear:both">Liste des fichiers PDF disponibles</h3>
		
		{if isset($listeFichiers) && (count($listeFichiers) > 0)}
		
			<form name="gestPDF" id="gestPDF" action="index.php" method="POST" role="form">
				
			<button type="submit" class="btn btn-primary pull-right" id="delete">Effacer la sélection</button>
			<button type="reset" class="btn btn-default pull-right">Annuler</button>
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="{$etape}">
				
			<table class="table table-striped table-condensed">
				<thead>
				<tr>
					<th style="width:20em">Nom du fichier</th>
					<th style="width:12em">Date</th>
					<th style="width:6em">Taille</th>
					<th id="checkAll" style="color:red"><span class="glyphicon glyphicon-check" style="font-size:1.5em;"></span> Sélectionner tous les fichiers</th>
				</tr>
				</thead>
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


</div>  <!-- container -->

<script type="text/javascript">
	
$(document).ready(function(){
	
	$(".checkAll").click(function(){
		var checked = $(this).attr("checked");
		var id = $(this).attr("id");
		$("."+id).attr("checked", checked);
	})

	
	$("#checkAll").click(function(){
		$(".delete").trigger("click");
		})

	$("#delete").click(function(){
		
		})
	
})
	
</script>
