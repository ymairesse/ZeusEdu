<div class="container">
	
	<div class="row">
		
		<form name="form1" method="post" action="index.php" class="form-vertical" role="form">
		
			<div class="col-md-4 col-sm-12">

				<div class="notice">A priori, tout se passe bien. Veuillez vérifier les informations suivantes.<br>Vous pouvez désélectionner les tables qui doivent être conservées.</div>

			</div>
		
			<div class="col-md-6 col-sm-12">
				
				<h4>Les tables suivantes seront traitées:</h4>
				<div style="height: 8em; overflow: auto">
				{foreach from=$listeTables item=uneTable}
					<input type="checkbox" value="1" name="table#{$uneTable}" checked="checked">{$uneTable} <br>
				{/foreach}
				</div>

			</div>

			<div class="col-md-2 col-sm-12">
				
				<input name="table" value="{$table}" type="hidden">
				<input name="action" value="{$action}" type="hidden">
				<input name="mode" value="{$mode}" type="hidden">
				<div class="btn-group-vertical">
					<button class="btn btn-primary" name="submit" type="submit">Confirmer</button>
					<a href="index.php" type="button" class="btn btn-default">Annuler</a>
				</div>
				
			</div>  <!-- col-md-... -->

			<div class="clearfix"></div>
			
		</form>
		

	</div>  <!-- row -->
	

</div>  <!-- container -->