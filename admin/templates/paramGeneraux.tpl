<div class="container">

	<h3>Paramètres généraux</h3>

	<form name="formParametres" id="formParametres" method="POST" action="index.php" role="form" class="form-vertical">
		{* présentation en deux colonnes *}
		{assign var=moitie value=$parametres|count/2}
		{assign var=n value=0}
		<div class="row">
			<div class="col-md-6 col-sm-12">
		{foreach from=$parametres key=parametre item=data}
		{if $n >= $moitie}
			</div>

			<div class="col-md-6 col-sm-12">
			{assign var=n value = -10000}
		{/if}
		<div class="form-group">
			<label for="{$parametre}">{$data.label} [{$parametre}]</label>
			<input type="text" maxlength="{$data.size}" name="{$parametre}" id="{$parametre}" value="{$data.valeur|escape}" class="form-control">
			<div class="help-block">{$data.signification}</div>
		</div>
		{assign var=n value=$n+1}
		{/foreach}
			</div>  <!-- col-md-... -->

		</div>  <!-- row -->

		<div class="btn-group pull-right">
			<button type="reset" class="btn btn-default">Annuler</button>
			<button type="submit" class="btn btn-primary">Enregistrer</button>
		</div>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="save">
	</form>

</div>
