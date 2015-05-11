<div id="tabsAttitudes">
<ul>
	{foreach from=$attitudes key=periode item=data}
	<li style="font-size:0.7em;"><a href="#tabs-{$periode}">{$periode}</a></li>	
	{/foreach}
</ul>
{foreach from=$attitudes key=periode item=data}
	{assign var=data value=$data.$matricule}
	<div id="tabs-{$periode}">
		<div class="table-responsive">
			<table class="table table-condensed table-striped">
				<tr style="text-align:center">
					<th class="micro">&nbsp;</th>
					{foreach from=$data key=coursGrp item=attitudes}
						{assign var=posMoins value=$coursGrp|strpos:'-'}
						{assign var=cours value=$coursGrp|substr:0:$posMoins}
			
						<th class="micro" data-container="body" title="{$listeProfsCoursGrp.$coursGrp|default:''}">{$cours}</th>
					{/foreach}
				</tr>
				
				<tr style="text-align:center">
					<th>Respect des autres</th>
					{foreach from=$data key=coursGrp item=attitudes}
						<td {if $attitudes.att1 == 'N'}class='echec'{/if}>{$attitudes.att1}</td>
					{/foreach}
				</tr>
				
				<tr style="text-align:center">
					<th>Respect des consignes</th>
					{foreach from=$data key=coursGrp item=attitudes}
						<td {if $attitudes.att2 == 'N'}class='echec'{/if}>{$attitudes.att2}</td>
					{/foreach}
				</tr>
				
				<tr style="text-align:center">
					<th>Volonté de progresser</th>
					{foreach from=$data key=coursGrp item=attitudes}
						<td {if $attitudes.att3 == 'N'}class='echec'{/if}>{$attitudes.att3}</td>
					{/foreach}
				</tr>
				
				<tr style="text-align:center">
					<th>Ordre et soin</th>
					{foreach from=$data key=coursGrp item=attitudes}
						<td {if $attitudes.att4 == 'N'}class='echec'{/if}>{$attitudes.att4}</td>
					{/foreach}
				</tr>
				
			</table>
	</div>
	</div>
{/foreach}
</div>
