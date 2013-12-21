<h2>Ecole: {$detailsEcole.nomEcole}</h2>
<h3>{$detailsEcole.adresse} {$detailsEcole.cpostal} {$detailsEcole.commune}</h3>
<table class="tableauAdmin">
	<tr>
		<th>
			<p style="clear:both; padding-top: 2em;">Nom de l'élève</p>
		</th>
		{foreach from=$listeCoursEleves key=cours item=unCours}
			<th title="[{$cours}]| {$unCours.libelle}">
				<img src="imagesCours/{$cours}.png" ><br />{$unCours.nbheures}h {$unCours.statut}
			</th>
		{/foreach}
	</tr>
	{foreach from=$listeEleves key=matricule item=unEleve}
	<tr>
		<td class="tooltip">
			<div class="tip"><img src="../photos/{$unEleve.photo}.jpg" alt="{$matricule}" style="width:100px"></div>
			{$unEleve.identite|truncate:25:'...'}
		</td>
		{foreach from=$listeCoursEleves key=cours item=unCours}
			{if isset($listeSituations.$matricule.$cours.sit100)}
				<td{if isset($listeSituations.$matricule.$cours)} 
					class="mention{$listeSituations.$matricule.$cours.mention}"
					title="{$cours}"
					{/if}>
				{$listeSituations.$matricule.$cours.sit100|default:'&nbsp;'}
				</td>
				{else}
				<td>&nbsp;</td>
			{/if}
		{/foreach}
	</tr>
	{/foreach}

</table>


<table>
<tr>
	<td colspan="6">Code de couleurs</td>
</tr>
<tr>
	<td class="mentionI">< 50</td>
	<td class="mentionF">50</td>
	<td class="mentionS">60</td>
	<td class="mentionAB">65</td>
	<td class="mentionB">70</td>
	<td class="mentionTB">> 80</td>
</tr>
</table>

