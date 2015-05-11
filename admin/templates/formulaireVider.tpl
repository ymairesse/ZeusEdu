<div class="container">

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<form method="POST" action="index.php" class="form-vertical" role="form">
				<div class="alert alert-danger">
					<p>La table "{$table}" va être vidée: veuillez confirmer<p>
				</div>				
				<div class="btn-group pull-right">
					<a type="button" class="btn btn-default" href="index.php">Annuler</a>
					<button type="submit" class="btn btn-primary" name="mode">Confirmer</button>		
				</div>
				<input name="table" value="{$table}" type="hidden">
				<input name="action" value="{$action}" type="hidden">
				<input name="mode" value="Confirmer" type="hidden">
			</form>

		</div>  <!-- col-md-.. -->
		
		<div class="col-md-6 col-sm-12">
			<div class="notice">
				<p>Attention, l'effacement du contenu de la table est définitif.</p>
			</div>

		</div>  <!-- col-md... -->
		
	</div>  <!-- row -->

	<h4>Contenu actuel de la table <strong>"{$table}"</strong></h4>
	
	<div class="table-responsive">
		
	<table class="table table-condensed table-striped">
		<thead>
		<tr>
		{foreach from=$entete item=element}
			<th>{$element.Field}</th>
		{/foreach}		
		</tr>
		</thead>
		{foreach from=$tableau item=ligne}
			<tr>{strip}
				{foreach from=$ligne item=element}
					<td>{$element|default:'&nbsp;'}</td>
				{/foreach}
				{/strip}
			</tr>
		{/foreach}
	</table>
	
	</div>

</div>  <!-- container -->