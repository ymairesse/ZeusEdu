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
				{assign var=situation value=$syntheseCotes.$bulletin.$coursGrp|default:Null}
				<td class="cote mention{$situation.mention|trim:'+'|default:''} pop"
					{if isset($commentairesProfs.$matricule.$coursGrp.$bulletin)}
						data-container="body"
						data-original-title="{$listeProfsCoursGrp.$coursGrp}: {$listeCoursGrp.$coursGrp.libelle}"
						data-content="{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'no comment'}"
						data-html="true"
						data-placement="top"
					{/if}>
				{if isset($situation.sitDelibe) && ($situation.sitDelibe != '')}
					<span class="micro">Délibé </span>
					<strong>{$situation.sitDelibe|default:''}
						{if isset($situation.attributDelibe)}
							{if $situation.attributDelibe == 'degre'}
							²
							{elseif $situation.attributDelibe == 'externe'}
							<i class="fa fa-graduation-cap"></i>
							{elseif $situation.attributDelibe == 'magique'}
							<i class="fa fa-magic"></i>
							{elseif $situation.attributDelibe == 'star'}
							*
							{else}

							{/if}
						{/if}
					</strong><br>
				{/if}

				{if isset($situation.pourcent) && ($situation.pourcent != '')}
				{$situation.situation|default:''}/{$situation.maxSituation|default:''}<br>
				<span class="micro">={$situation.pourcent|default:''}</span>
				{/if}
				 </td>
			{/foreach}
			<td class="cote"><strong>{$mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin|default:'&nbsp;'}</strong></td>
		</tr>
		{/foreach}
	</table>

</div>

{include file="tableauMentions.tpl"}
