<div class="table-responsive">
	
	<table class="table table-condensed">
		<tr>
			<th>&nbsp;</th>
			{foreach from=$listeCoursGrp key=coursGrp item=data}
				<th class="pop"
					data-container="body" 
					data-original-title="{$data.libelle}"
					data-html="true"
					data-content="{$listeProfsCoursGrp.$coursGrp}"
					data-placement="top">
					{$data.cours}<br>{$data.nbheures}h {$data.statut}
				</th>
			{/foreach}
			<th>Mentions</th>
		</tr>
		
		{foreach from=$listePeriodes key=periode item=bulletin}
		<tr>
			<th>{$periode+1}</th>
			{foreach from=$listeCoursGrp key=coursGrp item=data}		
				<td class="cote mention{$syntheseCotes.$bulletin.$coursGrp.mention|trim:'+'|default:''} pop"
					{if isset($commentairesProfs.$matricule.$coursGrp.$bulletin)}
						data-container="body" 
						data-original-title="{$listeProfsCoursGrp.$coursGrp}: {$listeCoursGrp.$coursGrp.libelle}"
						data-content="{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'no comment'}"
						data-html="true"
						data-placement="top"
					{/if}>
				{if isset($syntheseCotes.$bulletin.$coursGrp.sitDelibe) && ($syntheseCotes.$bulletin.$coursGrp.sitDelibe != '')}
					<span class="micro">Délibé </span>
					<strong>{$syntheseCotes.$bulletin.$coursGrp.sitDelibe|default:''}</strong><br>
				{/if}
				
				{if isset($syntheseCotes.$bulletin.$coursGrp.pourcent) && ($syntheseCotes.$bulletin.$coursGrp.pourcent != '')}
				{$syntheseCotes.$bulletin.$coursGrp.situation|default:''}/{$syntheseCotes.$bulletin.$coursGrp.maxSituation|default:''}<br>
				<span class="micro">={$syntheseCotes.$bulletin.$coursGrp.pourcent|default:''}</span>
				{/if}
				 </td>
			{/foreach}
			<td class="cote"><strong>{$mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin|default:'&nbsp;'}</strong></td> 
		</tr>
		{/foreach}
	</table>

</div>

{include file="tableauMentions.tpl"}
