<div class="container">

	<h3>Attribution des tables aux applications</h3>
	
	<form role="form" name="dispatchTables" method="POST" action="index.php" role="form" class="form-vertical">
		
		<div class="col-md-10 col-sm-12">
	
		<div class="table-responsive">
		
		<table class="table table-condensed table-striped">
			<tr>
				<th>Nom de la table</th>
				<th>Application</th>
			</tr>
			{foreach from=$listeAssocTablesEtApplis key=nomTable item=appli}
			<tr{if $appli == Null} class="erreur"{/if}>
				<td>{$nomTable}</td>
				<td>
					<select name="table_{$nomTable}"
					{foreach from=$listeApplis key=cetteAppli item=details}
						<option value="{$cetteAppli}"{if $cetteAppli == $appli} selected="selected"{/if}>{$details.nomLong}</option>
					{/foreach}
					</select>
				</td>
				{/foreach}
			</tr>
		</table>
		
		</div>  <!-- table-responsive -->
		
		</div>  <!-- col-md- -->
		
		<div class="col-md-2 col-sm-12">
			
			<div class="btn-group-vertical">
				<button class="btn btn-primary pull-right" type="submit">Enregistrer</button>
				<button class="btn btn-default pull-right" type="reset">Annuler</button>
			</div>
	
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="{$etape}">
		
		</div>  <!-- col-md-... -->
		
	<div class="clearfix"></div>
	</form>

</div>