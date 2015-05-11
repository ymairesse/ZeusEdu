<div class="container">
	
<fieldset style="clear:both">
	<legend>Importation des données de la table <strong>{$table}</strong></legend>
	
	<div class="row">
		
		<div class="col-md-4 col-sm-12">
		
			<form method="POST" action="index.php" id="formImport" name="formImport" enctype="multipart/form-data" class="form-vertical">
				<div class="btn-group-vertical">
					<span class="btn btn-default btn-file">
						<span>Sélectionner un fichier</span><input name="{$CSVfile}" type="file" id="nomFichierCSV">
					</span>
					<button class="btn btn-primary" type="submit">Envoyer</button>
				</div>
				<input name="table" value="{$table}" type="hidden">
				<input name="action" value="{$action}" type="hidden">
				<input name="mode" value="{$mode}" type="hidden">
			</form>
				
		</div>  <!-- col-md-... -->	
		
		<div class="col-md-8 col-sm-12">
			<div class="notice">
				<p>Veuillez sélectionner le fichier .csv correspondant</p>
				<p>Champs attendus (dans l'ordre)</p>
					<ul>
						{foreach from=$champs item=unChamp}
							<li><span style="width:15em; float:left; display:block">{$unChamp.Field}</span>
								{if $unChamp.Comment} -> <span  style="color:blue" class="micro">{$unChamp.Comment}</span>{/if}</li>
						{/foreach}
					</ul>
				<p>Dans le fichier .CSV, les champs sont séparés par des virgules (,) et sont entourés par des guillemets doubles (").</p>
				<p>Le fichier .CSV doit être encodé en UTF-8.</p>
				<p>Il est important de vérifier la cohérence entre les données envoyées et les données attendues.</p>
			</div>
		</div>


	</div>  <!-- row -->

</fieldset>

</div>  <!-- container -->

<script type="text/javascript">
	
$(document).on('change', '.btn-file :file', function() {
    var input = $(this),
        numFiles = input.get(0).files ? input.get(0).files.length : 1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
});	
	

$(document).ready(function(){
	
	$('.btn-file :file').on('fileselect', function(event, numFiles, label) {
        $(".btn-file span").text(label);
		});	
	
	
	$("#formImport").submit(function(){
		$("#wait").show();
		$.blockUI();
		})
	})

</script>