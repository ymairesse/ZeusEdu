<div class="container-fluid">

	<h3>Paramètres du bulletin</h3>

	<form id="formParametres">
		{* présentation en deux colonnes *}
		{assign var=moitie value=$listeConfig|count/2}
		{assign var=n value=0}
		<div class="row">
			<div class="col-md-6 col-sm-12">
		{foreach from=$listeConfig key=config item=data}
		{if $n >= $moitie}
			</div>

			<div class="col-md-6 col-sm-12">
			{assign var=n value = -10000}
		{/if}
		<div class="form-group">
			<label for="{$config}">{$data.label} [{$config}]</label>
			<input type="text" maxlength="{$data.size}" name="{$config}" id="{$config}" value="{$data.valeur|escape}" class="form-control">
			<div class="help-block">{$data.signification} <span style="float:right">{$data.domaine}</span></div>
		</div>
		{assign var=n value=$n+1}
		{/foreach}
			</div>  <!-- col-md-... -->

		</div>  <!-- row -->

		<div class="btn-group pull-right">
			<button type="reset" class="btn btn-default">Annuler</button>
			<button type="button" id="btn-saveConfig" class="btn btn-primary">Enregistrer</button>
		</div>

		<div class="clearfix"></div>

	</form>

</div>

<script type="text/javascript">
	
	$(document).ready(function(){

		$('#btn-saveConfig').click(function(){
			var formulaire = $('#formParametres').serialize();
			$.post('inc/admin/saveParametres.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				bootbox.alert({
					title: 'Enregistrement', 
					message: resultat + ' enregistrement(s) réalisé(s)'
				})
			})
		})

	})
</script>

