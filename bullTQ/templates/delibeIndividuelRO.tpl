
	{* ------------------------------------------------------------------ *}
	{* moitié gauche de l'écran ------------------------------------------*}
	{* ------------------------------------------------------------------ *}
	<div style="margin: 0pt; width: 48%; padding: 0 1em 5em 0; float: left;">
	
		<table style="width:100%;" class="tableauBull">
		<tr>
			<th>Cours</th>
			<th>h</th>
			{foreach from=$listePeriodes key=periode item=nomPeriode}
				<th>{$nomPeriode}</th>
			{/foreach}
		</tr>
		{foreach from=$listeCotes item=type}
			{foreach from=$type item=unCours}
			<tr class="{$unCours.statut}">
				{assign var="nomProf" value=$unCours.nomProf}
				<td>{$unCours.libelle}</td>
				<td>{$unCours.nbheures} h</td>
				{foreach from=$listePeriodes key=periode item=nomPeriode}
					<td class="cote">{$unCours.global.$periode|default:'&nbsp;'}</td>
				{/foreach}
			</tr>
			{/foreach}
			<tr>
				<td colspan="4" style="background-color: #ddd; height: 0.5em"></td>
			</tr>
		{/foreach}
		</table>
		
		<table style="width:100%;" class="tableauBull">
		<tr>
			<th colspan="6">Qualification</th>
		</tr>
		<tr>
			<th>Ev.<br>St.</th>
			<th>Rap.<br>St.</th>
			<th>Ev.<br>St.</th>
			<th>Rap.<br>St.</th>
			<th>Jury</th>
			<th>Total</th>
		</tr>
		<tr style="background-color: #fdd; height:3em">
			<td class="cote evStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E1" 
					value="{$qualification.E1|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E1|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote rapStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E2" 
					value="{$qualification.E2|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E2|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote evStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E3" 
					value="{$qualification.E3|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E3|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote rapStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E4" 
					value="{$qualification.E4|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E4|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote jury">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_JURY" 
					value="{$qualification.JURY|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.JURY|default:'&nbsp;'}
				 {/if}
				</td>
			<td class="cote FinalStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_TOTAL" 
					value="{$qualification.TOTAL|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.TOTAL|default:'&nbsp;'}
				{/if}
				</td>
		</tr>
		
		</table>
	</div>
	
	{* ------------------------------------------------------------------ *}
	{* moitié droite de l'écran ------------------------------------------*}
	{* ------------------------------------------------------------------ *}
	
	<div style="margin: 0pt; width: 48%; padding: 0 1em 5em 0; float: left;">
	{* on passe les périodes en revue *}
	{foreach from=$listePeriodes key=periode item=nomPeriode}
	
		<table class="tableauBull" style="width:100%">
		<tr>
			<th colspan="6">{$nomPeriode}</th>
		</tr>
		<tr>
			<th style="width:16%">&nbsp;</th>
			<th style="width:16%">Stage</th>
			<th style="width:16%">Option</th>
			<th style="width:16%">h</th>
			<th style="width:16%">Global</th>
			<th style="width:16%">h</th>
		</tr>
		{foreach from=$mentions item=uneMention key=num}
		<tr>
			<td class="cote">{$uneMention}</td>
			<td class="cote stage">{assign var='nbh' value=$statStage.$periode.$uneMention.nbheures|default:''}
				{if $nbh > 0}{$nbh} h{else}-{/if}
			</td>
			<td class="cote OG">{assign var='nbc' value=$statOG.$periode.$uneMention.nbCotes|default:''}
				{if $nbc > 0}{$nbc}{else}-{/if}
			</td>
			<td class="cote OG">{assign var='nbh' value=$statOG.$periode.$uneMention.nbheures|default:''} 
				{if $nbh > 0}{$nbh} h{else}-{/if}
			</td>
			<td class="cote FC">{assign var='nbc' value=$statGlobales.$periode.$uneMention.nbCotes|default:''}
				{if $nbc > 0}{$nbc}{else}-{/if}
			</td>
			<td class="cote FC">{assign var='nbh' value=$statGlobales.$periode.$uneMention.nbheures|default:''}
				{if $nbh > 0}{$nbh} h{else}-{/if}
			</td>
		</tr>
		{/foreach}
		<tr>
			<td>Mention départ</td>
			<td class="cote">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-stage_depart-periode_{$periode}" id="stage_depart_{$periode}" 
				value="{$mentionsManuelles.$periode.stage_depart|default:''}">
				{else}
					{$mentionsManuelles.$periode.stage_depart|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input  type="text" size="3" maxlength="4" 
				name="synthese-option_depart-periode_{$periode}" id="option_depart_{$periode}" 
				value="{$mentionsManuelles.$periode.option_depart|default:''}">
				{else}
					{$mentionsManuelles.$periode.option_depart|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-global_depart-periode_{$periode}" id="global_depart_{$periode}" 
				value="{$mentionsManuelles.$periode.global_depart|default:''}">
				{else}
					{$mentionsManuelles.$periode.global_depart|default:'&nbsp;'}
				{/if}
			</td>
		</tr>
		<tr>
			<td>Echec</td>
			{assign var='nb' value=$statStage.$periode.nbEchecs|default:''}
			<td class="cote{if $nb > 0} echec{/if}">
				{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
			{assign var='nb' value=$statOG.$periode.nbEchecs|default:''}
			<td class="cote{if $nb > 0} echec{/if}">
				{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
			{assign var='nbh' value=$statOG.$periode.nbheuresEchecs|default:''}
			<td class="cote{if $nbh > 0} echec{/if}">
				{if $nbh > 0}{$nbh} h{else}&nbsp;{/if}</td>
			{assign var='nb' value=$statGlobales.$periode.nbEchecs|default:''}
			<td class="cote{if $nb > 0} echec{/if}">
				{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
			{assign var='nbh' value=$statGlobales.$periode.nbheuresEchecs|default:''}
			<td class="cote{if $nbh > 0} echec{/if}">
				{if $nbh > 0}{$nbh} h{else}&nbsp;{/if}</td>
		</tr>
		<tr>
			<td>Mention finale</td>
			<td class="cote">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-stage_final-periode_{$periode}" id="stage_final_{$periode}" 
				value="{$mentionsManuelles.$periode.stage_final|default:''}">
				{else}
					{$mentionsManuelles.$periode.stage_final|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-option_final-periode_{$periode}" id="option_final_{$periode}" 
				value="{$mentionsManuelles.$periode.option_final|default:''}">
				{else}
					{$mentionsManuelles.$periode.option_final|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-global_final-periode_{$periode}" id="global_final_{$periode}" 
				value="{$mentionsManuelles.$periode.global_final|default:''}">
				{else}
					{$mentionsManuelles.$periode.global_final|default:'&nbsp;'}
				{/if}
			</td>
		</tr>
		</table>

	{/foreach}
	</div>
