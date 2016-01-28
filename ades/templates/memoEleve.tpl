{assign var=memo value=$memoEleve.proprio}
{assign var=idProprio value=$memo|key}
{assign var=leMemo value=$memo.$idProprio}

<div class="row">

	<div class="col-md-10 col-sm-12">
	
		<form name="padEleve" id="padEleve" method="POST" action="index.php" class="form-vertical" role="form">
			<input type="hidden" name="classe" value="{$classe}">
			<input type="hidden" name="matricule" value="{$matricule}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="savePad">
			<button class="btn btn-primary pull-right hidden-print" type="Submit" name="submit"><span class="glyphicon glyphicon-floppy-disk"></span> Enregistrer</button>
			{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
			<input type="hidden" class="onglet" name="onglet" value="{$onglet|default:0}">
			<hr>
			<textarea name="texte_{$idProprio}" id="texte_{$idProprio}" rows="20" class="ckeditor form-control" placeholder="Frappez votre texte ici">{$leMemo.texte}</textarea>
		</form>
	</div>  <!-- col-md-... -->
	
	<div class="col-md-2 col-sm-12 hidden-print">
		
		<img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" class="photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">
		
	</div>  <!-- col-md-... -->

</div>  <!-- row -->

<script type="text/javascript">

$(document).ready(function(){

	$("#padEleve").submit(function(){
		window.onbeforeunload = function(){};
		$.blockUI();
		$("#wait").show();
		})
	
})

</script>
