<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

{assign var=memo value=$memoEleve.proprio}
{assign var=idProprio value=$memo|key}
{assign var=leMemo value=$memo.$idProprio}

<div class="row">

	<div class="col-md-10 col-sm-12">

		<form name="padEleve" id="padEleve" method="POST" action="index.php" class="form-vertical" role="form">
			<input type="hidden" name="matricule" value="{$eleve.matricule}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="savePad">
			<button class="btn btn-primary pull-right hidden-print" type="Submit" name="submit"><span class="glyphicon glyphicon-floppy-disk"></span> Enregistrer</button>
			{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
			<input type="hidden" class="onglet" name="onglet" value="{$onglet|default:0}">
			<hr>
			<textarea name="texte_{$idProprio}" id="memoAdes" rows="20" class="ckeditor form-control" placeholder="Frappez votre texte ici">{$leMemo.texte}</textarea>
		</form>
	</div>  <!-- col-md-... -->

	<div class="col-md-2 col-sm-12 hidden-print">

		<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">

	</div>  <!-- col-md-... -->

</div>  <!-- row -->

<script type="text/javascript">

$(document).ready(function(){

	if(CKEDITOR.instances['memoAdes']){
   		delete CKEDITOR.instances['memoAdes'];
		}
	CKEDITOR.replace('memoAdes');

	$("#padEleve").submit(function(){
		window.onbeforeunload = function(){};
		$.blockUI();
		$("#wait").show();
		})

})

</script>
