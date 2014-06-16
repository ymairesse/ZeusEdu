<table class="tableauAdmin">
	{foreach from=$listeCours key=unCours item=detailsCours}
		<tr>
			<th colspan="2">{$detailsCours.libelle} [{$unCours}]</th>
		</tr>
			{foreach from=$detailsCours.coursGrp item=coursGrp}
			<tr>
				<td>{$coursGrp}</td>
				<td style="width:1em; text-align: center">
					{if isset($nbCotesExtCoursGrp.$coursGrp)} <span title="{$nbCotesExtCoursGrp.$coursGrp} cote(s) déjà fournie(s)">{$nbCotesExtCoursGrp.$coursGrp}</span>
					{else}
					<span class="suppr" style="cursor:pointer" title="supprimer {$coursGrp}"><img src="../images/suppr.png" alt="suppr"></span>
					{/if}
				</td>
			</tr>
			{/foreach}
	{/foreach}	
</table>