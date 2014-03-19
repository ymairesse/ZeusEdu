<h3>Absences de {$nomEleve} {$classe}</h3>
<table class="tableauAdmin">
	<tr>
		<th>Date</th>
		<th>Périodes / cours / professeur</th>
	</tr>
{foreach from=$listeAbsences key=date item=absence}
	<tr>
		<td>{$date}</td>
		<td>
			<ul class="listeAbsences">
			{foreach from=$listePeriodes key=periode item=bornes}
				{if isset($absence.$periode)}
					<li class="tooltip absent">
						<span class="tip"><h3>{$absence.$periode.prof}</h3>{$absence.$periode.libelle}</span>
						<span class="micro">{$periode} | {$listePeriodes.$periode.debut} {$absence.$periode.educ}</span></li>
					{else}
					<li>{$periode}</li>
				{/if}
			{/foreach}
			</ul>
		</td>
	</tr>
{/foreach}
</table>