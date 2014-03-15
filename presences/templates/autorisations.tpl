<h3>Autorisations de sortie pour {$eleve.prenom} {$eleve.nom} {$eleve.classe}</h3>
<form name="newAutorisation" id="newAutorisation" action="index.php" method="POST">
	<input type="submit" name="submit" class="fauxBouton" value="Nouvelle autorisation">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="newAutorisation">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="classe" value="{$classe}">
</form>
<table class="tableauAdmin">
	<tr>
		<th>Noté par</th>
		<th>Demandé par</th>
		<th>Via (média)</th>
		<th>Date</th>
		<th>Heure</th>
		<th style="width:16px">&nbsp;</th>
		<th style="width:16px">&nbsp;</th>
	</tr>
	{foreach from=$listeAutorisations item=uneAutorisation}
	<tr>
		<td>{$uneAutorisation.educ|default:'&nbsp;'}</td>
		<td>{$uneAutorisation.parent|default:'&nbsp;'}</td>
		<td>{$uneAutorisation.media|default:'&nbsp;'}</td>
		<td>{$uneAutorisation.date|default:'&nbsp;'}</td>
		<td>{$uneAutorisation.heure|default:'&nbsp;'}</td>
		<td title="Modifier">
			<form name="edit" method="POST" action="index.php" class="microForm editForm">
				<input type="image" src="../images/edit.png" alt="V">
				<input type="hidden" name="id" value="{$uneAutorisation.id}">
				<input type="hidden" name="matricule" value="{$eleve.matricule}">
				<input type="hidden" name="classe" value="{$eleve.groupe}">
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="edit">
			</form>
		</td>
		<td title="Supprimer">
			<form name="del" method="POST" action="index.php" class="microForm delForm">
				<input type="image" src="../images/suppr.png" alt="X">
				<input type="hidden" name="matricule" value="{$eleve.matricule}">
				<input type="hidden" name="classe" value="{$eleve.groupe}">
				<input type="hidden" name="id" value="{$uneAutorisation.id}">
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="del">
			</form>
	</tr>
	{/foreach}
</table>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$(".delForm").submit(function(){
			if (!(confirm("Voulez-vous vraiment supprimer cet item?"))) {
				return false
			}
			})
		})
	{/literal}
</script>
