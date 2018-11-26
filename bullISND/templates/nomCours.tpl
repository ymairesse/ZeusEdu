<div class="container">

	<h3>Attribuer un nom personnel à vos cours</h3>

	<form name="nomCours" action="index.php" method="POST" id="nomCours" role="form" class="form-vertical">

		<div class="row">
		<button type="submit" class="btn btn-primary pull-right" tabIndex="{$tabIndex}">Enregistrer</button>
		<button type="reset" class="btn btn-default pull-right">Annuler</button>
		</div>
	{assign var=moitie value=$listeCours|count/2}
	{assign var=n value=0}

	{assign var=tabIndex value=1}
	<div class="row">

	{foreach from=$listeCours key=coursGrp item=data}

			{* remplacement de l'espace possible dans le nom du cours par un caractère ~ *}
			{assign var=coursGrpPROT value=$coursGrp|replace:' ':'~'}

			<div class="col-md-6 col-sm-12">

				<div class="form-group">
					<label for="field_{$coursGrpPROT}" {if ($data.virtuel == 1)}style="color:green" title="Cours virtuel"{/if}>
						{$data.libelle} {$data.classes} {$coursGrp}
					</label>
					<input tabIndex="{$tabIndex}" type="text" maxlength="40" name="field_{$coursGrpPROT}" id="field_{$coursGrpPROT}" value="{$data.nomCours}" class="form-control">
					<div class="help-block">Dénomination personnelle pour le cours {$coursGrp}</div>
				</div>

			</div>  <!-- col-md-.. -->

		{assign var=tabIndex value=$tabIndex+1}
		{assign var=n value=$n+1}

	{/foreach}

	</div>  <!-- row -->

	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$("input").tabEnter();
	})

</script>
