<h4>Derniers backups</h4>

<div class="table-responsive">
	
	<table class="table table-striped table-hover table-condensed" style="margin:auto">
		<thead>
		<tr>
			<th style="width:20em">Nom du fichier</th>
			<th style="width:12em">Date</th>
			<th style="width:6em">Taille</th>
			<th>Effacer</th>
		</tr>
		</thead>
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
				<button type="btn btn-default" class="btnDelete" data-filename="{$unFichier.fileName}">
					<i class="fa fa-times" style="color:red" title="Effacer le fichier"></i>
				</button>
				<a href="index.php?action=backup&amp;mode=delete&amp;fileName={$unFichier.fileName}">
				
				</a>
			</td>
		</tr>
		{/foreach}
	</table>

</div>


<div id="myModal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" aria-labeldby="modal-title">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="modal-title">Confirmation</h4>
			</div>

			<div class="modal-body text-warning">
				<p>Voulez-vous vraiment effacer le fichier <span id="nomFichier"></span> ?</p>
				<p>Attention, l'effacement est définitif.</p>
			</div>

			<div class="modal-footer">
				<form name="delBackup" id="delBackup" method="POST" action="index.php">
					<input type="hidden" name="fileName" id="fileName" value="">
					<input type="hidden" name="action" value="backup">
					<input type="hidden" name="mode" value="delete">
					<div class="btn-group pull-right">
						<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
						<button type="submit" class="btn btn-primary">Effacer</button>
					</div>
				</form>
			</div>

		</div>
	</div>

</div>




<script type="text/javascript">
	
	$(document).ready(function(){
		
		$(".btnDelete").click(function(){
			var fileName = $(this).data('filename');
			$("#nomFichier").text(fileName);
			$("#fileName").val(fileName);
			$("#myModal").modal('show');
			})
		
		})
	
</script>