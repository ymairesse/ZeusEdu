<h3 title="{$matricule}">Autorisations de sortie pour {$eleve.prenom} {$eleve.nom} {$eleve.classe}</h3>
<img style="float:right; width:100px; position: relative; top: -60px;" src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo draggable" title="{$eleve.prenom} {$eleve.nom} {$eleve.matricule}">
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
		<th colspan="{$listePeriodes|count}">Périodes</th>
		<th style="width:16px">&nbsp;</th>
	</tr>
	
	{if $listeAutorisations|count > 0}
		{assign var=liste value=$listeAutorisations.$matricule}
		{foreach from=$liste key=dateSQL item=uneAutorisation}
		<tr>
			<td>{$uneAutorisation.educ|default:'&nbsp;'}</td>
			<td>{$uneAutorisation.parent|default:'&nbsp;'}</td>
			<td>{$uneAutorisation.media|default:'&nbsp;'}</td>
			<td>{$uneAutorisation.date|default:'&nbsp;'}</td>
			<td>{$uneAutorisation.heure|default:'&nbsp;'}</td>

			{assign var=date value=$uneAutorisation.date}
			{foreach from=$listePeriodes key=noPeriode item=wtf}
				<td class={$listePresences.$date.$noPeriode.statut|default:'indetermine'}>
					{$noPeriode}
				</td>
			{/foreach}
			<td title="Modifier">
				<form name="edit" method="POST" action="index.php" class="microForm editForm">
					<input type="image" src="../images/edit.png" alt="V">
					<input type="hidden" name="date" value="{$date}">
					<input type="hidden" name="matricule" value="{$eleve.matricule}">
					<input type="hidden" name="classe" value="{$eleve.groupe}">
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="edit">
				</form>
			</td>
		</tr>
		{/foreach}
	{/if}
	
</table>

<h4>Légende</h4>
<table>
	<tr>
	<td style="width:140px;" class="micro indetermine">Présences non prises:</td><td class="indetermine"><img src="images/indetermine.png" alt="indeterminé"></td>
	<td style="width:140px" class="micro present">Présent: </td><td class="present"><img src="images/present.png" alt="présent"></td>
	<td style="width:140px" class="micro absent">Absent: </td><td class="absent"><img src="images/absent.png" alt="absent"></td>
	<td style="width:140px" class="micro sortie">Sortie autorisée: </td><td class="sortie"><img src="images/sortie.png" alt="sortie"></td>
	<td style="width:140px" class="micro signale">Absence signalée: </td><td class="signale"><img src="images/signale.png" alt="signalé"></td>
	<td style="width:140px" class="micro justifie">Absence justifiée: </td><td class="justifie"><img src="images/justifie.png" alt="justifié"></td>
	</tr>
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
