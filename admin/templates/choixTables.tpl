<div class="container">

<h3>Choix des tables à sauvegarder</h3>

<form name="applisSwitch" method="POST" action="index.php" role="form">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<button class="btn btn-primary pull-right" type="submit">Sauvegarder</button>
	<button class="btn btn-default pull-right" type="reset">Annuler</button>

	<span title="Sauvegarde complète" style="font-size:1.5em" class="glyphicon glyphicon-check"></span><a href="javascript:void(0)" class="checkTout">Backup complet de la base de données</a>
	
	<div class="row">
		
		{foreach from=$listeTables key=nomAppli item=uneAppli}
			<div class="col-md-6 col-sm-12">
			
				<div class="panel panel-default">
					
					<div class="panel-heading">
						<h3 class="panel-title checkAll" title="Toutes les tables de l'application {$nomAppli}" style="cursor:pointer" id="{$nomAppli}">
							<span class="glyphicon glyphicon-ok" style="font-size:1.5em"></span>Application: {$nomAppli}</h3>
					</div>
				
					<div class="panel-body">
				
						<table class="table table-striped">

							{foreach from=$uneAppli item=uneTable}
							<tr>
								<td>{$uneTable}</td>
								<td title="Sauvegarde de la table"><input type="checkBox" class="{$nomAppli} appli" name="check_{$uneTable}"></td>
							</tr>
							{/foreach}
						</table>
				
					</div>  <!-- body -->
				
				</div>  <!-- panel -->
			
			</div>  <!-- col-md-... -->
			
		{/foreach}
	
	</div>  <!--row -->
	
</form>

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$(".checkAll").click(function(){
			var checked = $(this).attr("checked");
			var id = $(this).attr("id");
			$("."+id).click();
		})
		
		$(".checkTout").click(function(){
			$(".appli").click();
		})
		
	})

</script>