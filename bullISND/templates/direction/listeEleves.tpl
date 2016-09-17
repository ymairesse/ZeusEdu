{if isset($listeEleves)}
<table class="table table-condensed table-bordered">
	<thead>
		<tr>
			<th>Nom</th>
			<th><input type="checkbox" id="checkAll"></th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$listeEleves key=matricule item=unEleve}
			<tr>
				<td>{$unEleve.nom} {$unEleve.prenom}</td>
				<td><input type="checkbox" name="eleves[]" class="eleves" value="{$matricule}"></td>
			</tr>
		{/foreach}
	</tbody>

</table>
{/if}
