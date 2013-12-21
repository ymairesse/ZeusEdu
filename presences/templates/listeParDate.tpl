<div id="body">
	<h3>Liste des absences du {$date}</h3>
	<table class="tableauAdmin">
		<tr>
			<th>&nbsp;</th>
			<th>Classe</th>
			<th>Nom</th>
			<th colspan="{$listePeriodes|count}">Absences</th>
		</tr>

		{foreach from=$listeAbsences key=matricule item=unEleve name=boucle}
		<tr>
		<td>{$smarty.foreach.boucle.iteration}</td>
		<td>{$unEleve.classe}</td>
		<td class="tooltip"><span class="tip"><img src="../photos/{$unEleve.photo}.jpg" alt="{$matricule}" width="100px"></span>{$unEleve.nom} {$unEleve.prenom}</td>
		{foreach from=$listePeriodes key=laPeriode item=wtf}
			{if isset($unEleve.periodes) && in_array($laPeriode, array_keys($unEleve.periodes))}
				<td class="absent" style="border:1px solid red" title="{$unEleve.periodes.$laPeriode.heure} par {$unEleve.periodes.$laPeriode.educ}">{$laPeriode}</td>
				{else}
				<td class="present">{$laPeriode}</td>
			{/if}
		{/foreach}
		</tr>
		{/foreach}
	</table>
	<strong>{$listeAbsences|count} absence(s)</strong>
</div>