<div class="table-responsive">
	
	<table style="font-size:0.8em" class="table table-condensed">
		<tr>
			<th>&nbsp;</th>
			{foreach from=$listeCoursGrp key=coursGrp item=data}
				<th class="pop"
					data-original-title="{$data.libelle}";
					data-content="{$listeProfsCoursGrp.$coursGrp}"
					data-container="body"
					data-html="true"
					data-placement="top">
					{$data.cours} <br>{$data.nbheures}h {$data.statut}
				</th>
			{/foreach}
		</tr>
		<tr>
			<th>TJ</th>
			{foreach from=$listeCoursGrp key=coursGrp item=data}
			<td class="cote mention{$cotesPeriode.$matricule.$coursGrp.form.mention|default:''} pop" 
				data-original-title="{$coursGrp}"
				data-content="{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'No Comment'}" 
				data-container="body"
				data-html="true"
				data-placement="top">
				{if isset($cotesPeriode.$matricule.$coursGrp.form.cote)}
					{$cotesPeriode.$matricule.$coursGrp.form.cote}/{$cotesPeriode.$matricule.$coursGrp.form.max}
					{else}
					&nbsp;
				{/if}
			</td>
			{/foreach}
		</tr>
		<tr>
			<th>Cert</th>
			{foreach from=$listeCoursGrp key=coursGrp item=data}
			<td class="cote mention{$cotesPeriode.$matricule.$coursGrp.cert.mention|default:''} pop"
				data-original-title="{$coursGrp}"
				data-content="{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'No Comment'}"
				data-container="body"
				data-html="true"
				data-placement="top">
				{if isset($cotesPeriode.$matricule.$coursGrp.cert.cote)}
					{$cotesPeriode.$matricule.$coursGrp.cert.cote}/{$cotesPeriode.$matricule.$coursGrp.cert.max}
					{else}
					&nbsp;
				{/if}
			</td>
			{/foreach}		
		</tr>
	</table>

</div>

{include file="tableauMentions.tpl"}

