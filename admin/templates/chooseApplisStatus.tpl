<div class="container">
	
	<h3>Activation/désactivation des applications</h3>
	
	<form name="applisSwitch" id="applisSwitch" method="POST" action="index.php" role="form">

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">
		<button class="btn btn-primary pull-right" type="submit">Enregistrer</button>
		<button class="btn btn-default pull-right" type="reset">Annuler</button>
		
	<div class="table-responsive">
	
		<table class="table table-condensed table-striped">
			<thead>
			<tr>
				<th>Application</th>
				<th>Activée</th>
			</tr>
			</thead>
		{foreach from=$listeApplis item=uneAppli}
			<tr>
				<td>{$uneAppli.nomLong}</td>
				<td><input type="checkBox" name="{$uneAppli.nom}"{if $uneAppli.active} checked{/if}></td>
			</tr>
		{/foreach}
		</table>
	
	</div>
	
	</form>

</div>

<script type="text/javascript">

	$(document).ready(function(){
		$("#applisSwitch").submit(function(){
			$.blockUI();
			$("#wait").show();
			})
		})

</script>
