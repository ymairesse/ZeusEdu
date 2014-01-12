<h3>Liste des utilisateurs du module</h3>
<form name="addUser" id="addUser" method="POST" action="index.php" calss="microForm">
	<select name="acronyme" id="selectProf">
		<option value="">Sélectionner un utilisateur</option>
		{foreach from=$listeProfs key=cetAcronyme item=prof}
		<option value="{$cetAcronyme}">{$prof.nom} {$prof.prenom} [{$cetAcronyme}]</option>
		{/foreach}
	</select>
	
	<select name="statut" id="statut">
		<option value="">Sélectionner un statut</option>
		{foreach from=$listeStatuts key=status item=statut}
		<option value="{$status}">{$statut}</option>
		{/foreach}
	</select>
	
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="users">
	<input type="hidden" name="etape" value="addUser">
	<input type="submit" name="submit" value="OK">

</form>
<table class="tableauAdmin">
	<tr>
	<th>Nom</th>
	<th style="width:14em">Statut</th>
	<th style="width:3em">&nbsp;</th>
	</tr>

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
			<input type="submit" name="submit" value="OK">
			<input type="hidden" name="acronyme" value="{$cetAcronyme}">
			<input type="hidden" name="action" value="admin">
			<input type="hidden" name="mode" value="users">
			<input type="hidden" name="etape" value="editUser">
			</form>
			{else}
			&nbsp;
			{/if}
		</td>
		<td>
			{if $cetAcronyme != $acronyme}
			{* il n'est pas possible de changer son propre statut: précaution!! *}
			<form name="formDelete" class="microForm formDelete" action="index.php" method="POST">
				<input type="hidden" name="acronyme" value="{$cetAcronyme}">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="mode" value="users">
				<input type="hidden" name="etape" value="delUser">
				<input type="image" src="images/suppr.png" alt="X" class="btnX" name="submit" title="Supprimer cet utilisateur">
			</form>
			{else}
				&nbsp;
			{/if}
		</td>		
	</tr>
{/foreach}
</table>


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

