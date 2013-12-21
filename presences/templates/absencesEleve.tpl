<h3>Absences de {$nomEleve} {$classe}</h3>
<table class="tableauAdmin">
	<tr>
		<th>Date</th>
		<th>Périodes</th>
		<th>Cours</th>
		<th>Professeur</th>
	</tr>
{foreach from=$listeAbsences key=date item=absence}
	<tr>
		<td>{$date}</td>
		<td>

			
		</td>
	</tr>
{/foreach}
</table>