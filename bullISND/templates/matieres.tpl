<h3>Action sur les cours</h3>

<table class="tableauBull">
	<tr>
		<th>Cours</th>
		<th>Libellé</th>
		<th>Statut</th>
		<th>Cadre</th>
		<th>Professeur</th>
		<th>Nombre d'élèves</th>
		<th>Action</th>
	</tr>
{foreach from=$listeCoursGrp key=coursGrp item=data}
	<tr>
		<td>{$coursGrp}</td>
		<td>{$data.libelle}</td>
		<td>{$data.statut}</td>
		<td>{$data.cadre}</td>
		<td>{$data.nomProf} ({$data.acronyme})</td>
		<td>{$data.nbEleves}</td>
		<td>&nbsp;</td>
	</tr>
{/foreach}
</table>