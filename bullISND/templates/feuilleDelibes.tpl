<h2>Classe: | {$classe} | {$titusClasse|implode:','} -> Période: {$bulletin}</h2>
<table class="tableauAdmin">

	<tr>
		<th style="min-width:35%">
			<div id="notice" class="inv" style="width:65%">Ce document est basé sur les cotes de délibération fournies dans le bulletin. Il ne devient définitif que la veille de la délibération à 17h00</div>
			<p style="clear:both; padding-top: 2em;">Nom de l'élève</p>
		</th>
		
		{foreach from=$listeCours key=cours item=detailsCours}
		<th class="tooltip">
			<span class="tip" style="display:none">{$detailsCours.cours.libelle}<br>{$cours}</span>
			<img src="imagesCours/{$cours}.png" alt="{$cours}"><br>
			{$detailsCours.cours.nbheures}h
		</th>
		{/foreach}
		<th><img src="images/moyenne.png" alt="moyenne"></th>
		<th><img src="images/nbEchecs.png" alt="nombre d'échecs"></th>
		<th><img src="images/heuresEchecs.png" alt="nombre d'heures d'échec"></th>
		<th><img src="images/mentionInit.png" alt="mention Initiale"></th>
		<th><img src="images/mentionFinale.png" alt="mention Finale"></th>
	</tr>

	<!-- fin de l'entête ----------------------------------------------------------------- -->
	
	{foreach from=$listeEleves key=matricule item=unEleve}
	<tr>
		{assign var=nomPrenom value=$unEleve.nom|cat:' '|cat:$unEleve.prenom}
		<td class="tooltip">
			<span class="tip" style="display:none"><img src="../photos/{$matricule}.jpg" alt="{$matricule}" style="width:100px"><br>
			{$nomPrenom|truncate:15:'...'}<br> {$matricule}
			</span>
			{$unEleve.classe} {$nomPrenom|truncate:25:'...'}</td>

		{foreach from=$listeCours key=cours item=detailsCours}
			{assign var=coursGrp value=$listeSituations.$matricule.$cours.coursGrp|default:Null}
			{if isset($coursGrp)}
				<td class="{$listeSituations.$matricule.$cours.statut} {$listeSituations.$matricule.$cours.echec}"
					title="{$coursGrp}|{$listeCours.$cours.$coursGrp.profs|@implode:'<br>'}">
				{$listeSituations.$matricule.$cours.sitDelibe|default:'&nbsp;'}
				</td>
				{else}
				<td class="cote">-</td>
			{/if}
		{/foreach}

		<td class="delibe">{$delibe.$matricule.moyenne|default:'&nbsp;'}</td>
		<td class="delibe"
			{if $delibe.$matricule.nbEchecs >0} title="{$delibe.$matricule.nbEchecs} échec(s) {$delibe.$matricule.nbHeuresEchec}h|{$delibe.$matricule.coursEchec}"
			>
			{$delibe.$matricule.nbEchecs}
			{else}&nbsp;{/if}</td>
		<td class="delibe" {if $delibe.$matricule.nbEchecs > 0} title="{$delibe.$matricule.nbEchecs} échec(s) {$delibe.$matricule.nbHeuresEchec}h|{$delibe.$matricule.coursEchec}">
			{$delibe.$matricule.nbHeuresEchec}h
			{else}&nbsp;{/if}</td>
		<td class="cote delibe">{$delibe.$matricule.mention|default:'&nbsp;'}</td>
		<td class="delibe">{$listeMentions.$matricule.$annee.$bulletin|default:'&nbsp;'}</td> 
	</tr>
	{/foreach} 
</table>
{$listeEleves|@count} élèves

