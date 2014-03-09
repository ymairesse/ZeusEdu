<div id="body">
	<h3>Liste des absences du {$date}</h3>
	<table class="tableauAdmin">
		<tr>
			<th>&nbsp;</th>
			<th>Classe</th>
			<th>Matricule</th>
			<th>Nom</th>
			<th colspan="{$listePeriodes|count}">Absences</th>
		</tr>

		{foreach from=$listeAbsences key=matricule item=unEleve name=boucle}
		<tr>
		<td>{$smarty.foreach.boucle.iteration}</td>
		<td>{$unEleve.classe}</td>
		<td>{$matricule}</td>
		<td class="tooltip"><span class="tip"><img src="../photos/{$unEleve.photo}.jpg" alt="{$matricule}" style="width:100px"></span>{$unEleve.nom} {$unEleve.prenom}</td>
		{foreach from=$listePeriodes key=laPeriode item=wtf}
			{if isset($unEleve.periodes) && in_array($laPeriode, array_keys($unEleve.periodes))}
				<td class="absent" title="{$unEleve.periodes.$laPeriode.heure} par {$unEleve.periodes.$laPeriode.educ}">
					<span  style="border:1px solid red">{$laPeriode}</span> {$unEleve.periodes.$laPeriode.educ} </td>
				{else}
				<td class="present">{$laPeriode}</td>
			{/if}
		{/foreach}
		</tr>
		{/foreach}
	</table>
	<strong>{$listeAbsences|count} absence(s)</strong>
</div>


<script type="text/javascript">
	$(document).ready(function(){
	
	$(".tableauAdmin tr").hover(
		function() {
			$(this).addClass('mev')
			},
		function() {
			$(this).removeClass('mev')
			}
		)
		
	})
	
</script>