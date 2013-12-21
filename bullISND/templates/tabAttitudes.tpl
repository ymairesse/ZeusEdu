<div id="tabsAttitudes" style="display:none;">
<ul>
	{foreach from=$attitudes key=periode item=data}
	<li style="font-size:0.7em;"><a href="#tabs-{$periode}">{$periode}</a></li>	
	{/foreach}
</ul>
{foreach from=$attitudes key=periode item=data}
	{assign var=data value=$data.$matricule}
	<div id="tabs-{$periode}">
	<table style="font-size:0.9em" class="tableauTitu">
		<tr>
		<th class="micro">&nbsp;</th>
		{foreach from=$data key=coursGrp item=attitudes}
			{assign var=debut value=$coursGrp|strpos:':'+1}
			{assign var=cgmin value=$coursGrp|substr:$debut:99}
			{assign var=fin value=$cgmin|strpos:'-'}
			{assign var=cgmin value=$cgmin|substr:0:$fin}
			<th class="micro" title="{$coursGrp}">{$cgmin}</th>
		{/foreach}
		<tr>
		<th>Respect des autres</th>
		{foreach from=$data key=coursGrp item=attitudes}
			<td {if $attitudes.att1 == 'N'}class='echec'{/if} style="text-align:center">{$attitudes.att1}</td>
		{/foreach}
		</tr>
		
		<tr>
		<th>Respect des consignes</th>
		{foreach from=$data key=coursGrp item=attitudes}
			<td {if $attitudes.att2 == 'N'}class='echec'{/if} style="text-align:center">{$attitudes.att2}</td>
		{/foreach}
		</tr>
		
		<tr>
		<th>Volonté de progresser</th>
		{foreach from=$data key=coursGrp item=attitudes}
			<td {if $attitudes.att3 == 'N'}class='echec'{/if} style="text-align:center">{$attitudes.att3}</td>
		{/foreach}
		</tr>
		
		<tr>
		<th>Ordre et soin</th>
		{foreach from=$data key=coursGrp item=attitudes}
			<td {if $attitudes.att4 == 'N'}class='echec'{/if} style="text-align:center">{$attitudes.att4}</td>
		{/foreach}
		</tr>
		
	</table>
	</div>
{/foreach}
</div>
