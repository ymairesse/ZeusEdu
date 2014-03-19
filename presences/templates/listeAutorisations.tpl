<h3>Liste des autorisations de sortie du {$dateDebut}{if $dateFin != ''} au {$dateFin}{/if}</h3>

{foreach from=$listeAutorisations key=date item=unEleve }
{if ($listeAutorisations|@count) > 1}
	<h4>Le {$date}</h4>
{/if}
<table class="tableauAdmin">
	<tr>
		<th>Matricule</th>
		<th>Heure</th>
		<th>Nom</th>
		<th>Prénom</th>
		<th>Classe</th>
		<th>Par</th>
		<th style="width:16px" class="noprint">&nbsp;</th>
		<th style="width:16px" class="noprint">&nbsp;</th>
	</tr>

	{foreach from=$unEleve key=matricule item=cetEleve}
		{foreach from=$cetEleve key=heure item=eleve}
		<tr>
			<td>{$eleve.matricule}</td>
			<td>{$eleve.heure}</td>
			<td>{$eleve.nom}</td>
			<td>{$eleve.prenom}</td>
			<td>{$eleve.groupe}</td>
			<td>{$eleve.educ}</td>
			<td class="noprint">
				<form class="microForm editForm noprint" action="index.php" method="POST" name="edit">
					<input type="image" alt="V" src="../images/edit.png" autocomplete="off">
					<input type="hidden" value="{$eleve.id}" name="id" autocomplete="off">
					<input type="hidden" value="{$eleve.matricule}" name="matricule" autocomplete="off">
					<input type="hidden" value="{$eleve.groupe}" name="classe" autocomplete="off">
					<input type="hidden" value="autorisations" name="action" autocomplete="off">
					<input type="hidden" value="edit" name="mode" autocomplete="off">
				</form>
			</td>
			<td class="noprint">
				<form class="microForm delForm noprint" action="index.php" method="POST" name="del">
					<input type="image" alt="X" src="../images/suppr.png" autocomplete="off">
					<input type="hidden" value="{$eleve.id}" name="id" autocomplete="off">
					<input type="hidden" value="{$eleve.matricule}" name="matricule" autocomplete="off">
					<input type="hidden" value="{$eleve.groupe}" name="classe" autocomplete="off">
					<input type="hidden" value="autorisations" name="action" autocomplete="off">
					<input type="hidden" value="del" name="mode" autocomplete="off">
				</form>
				
			</td>
		</tr>
		{/foreach}
	{/foreach}

</table>

{/foreach}

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