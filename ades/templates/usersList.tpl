<div class="container">
	
	<div class="row">
		
		<div class="col-md-9 col-sm-6">
			
			<h3>Liste des utilisateurs</h3>
		
			<div class="table-responsive">
				<table class="table table-striped table-condensed table-hover">
					<thead>
						<tr>
						<th>Nom</th>
						<th>Statut</th>
						<th>&nbsp;</th>
						</tr>
					</thead>
				{foreach from=$usersList key=cetAcronyme item=user}
					<tr>
						<td>{$user.nomPrenom}</td>
						<td>
							{if $cetAcronyme != $acronyme}
							{* il n'est pas possible de changer son propre statut: précaution!! *}
							<form name="formStatut" class="microForm" action="index.php" method="POST">
							<select name="statut" id="statut" title="Modifier le statut de l'utilisateur">
								{foreach from=$listeStatuts key=status item=statut}
								<option value="{$status}"{if $status == $user.status} selected="selected"{/if}>{$statut}</option>
								{/foreach}
							</select>
							<button type="submit" class="btn btn-primary btn-sm">OK</button>
							<input type="hidden" name="acronyme" value="{$cetAcronyme}">
							<input type="hidden" name="action" value="{$action}">
							<input type="hidden" name="mode" value="{$mode}">
							<input type="hidden" name="etape" value="editUser">
							</form>
							{else}
							<span class="alert-warning">Vous ne pouvez pas modifier votre propre statut</span>
							{/if}
						</td>
						<td>
							{if $cetAcronyme != $acronyme}
							{* il n'est pas possible de changer son propre statut: précaution!! *}
							<form role="form" name="formDelete" class="microForm formDelete" action="index.php" method="POST">
								<input type="hidden" name="acronyme" value="{$cetAcronyme}">
								<input type="hidden" name="action" value="{$action}">
								<input type="hidden" name="mode" value="{$mode}">
								<input type="hidden" name="etape" value="delUser">
								<button class="btn btn-default btn-sm" type="submit" title="Supprimer cet utilisateur"><span class="glyphicon glyphicon-remove-circle" style="color:red"></span></button>
								
							</form>
							{else}
								&nbsp;
							{/if}
						</td>		
					</tr>
				{/foreach}
				</table>
			
			</div>  <!-- table-responsive -->
			
			</div>   <!-- col-md-... -->
			
			<div class="col-md-3 col-sm-6">
					
		
				<h3>Ajouter un utilisateur</h3>
				<form name="addUser" id="addUser" method="POST" action="index.php" calss="form-vertical" role="form">
					<select name="acronyme" id="selectProf" class="form-control">
						<option value="">Sélectionner un utilisateur</option>
						{foreach from=$listeProfs key=cetAcronyme item=prof}
						<option value="{$cetAcronyme}">{$prof.nom} {$prof.prenom} [{$cetAcronyme}]</option>
						{/foreach}
					</select>
					
					<select name="statut" id="statut" class="form-control">
						<option value="">Sélectionner un statut</option>
						{foreach from=$listeStatuts key=status item=statut}
						<option value="{$status}">{$statut}</option>
						{/foreach}
					</select>
					
					<input type="hidden" name="action" value="admin">
					<input type="hidden" name="mode" value="users">
					<input type="hidden" name="etape" value="addUser">
					<button type="submit" class="btn btn-primary btn-sm">OK</button>
				
				</form>
		
			</div>  <!-- col-md.... -->

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$(".formDelete").submit(function(){
		if (!(confirm("Veuillez confirmer la suppression de cet utilisateur"))) {
			return false;
		}
		})

	$("#addUser").submit(function(){
		var statut = $("#statut").val();
		var user = $("#selectProf").val();
		if ((statut == '') || (user == '')) {
			return false;
		}
	})
	
</script>

