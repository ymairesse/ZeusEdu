<div id="tabsAttitudes">

<ul class="nav nav-tabs{if $periode == $bulletin} active{/if}">
	{foreach from=$attitudes key=periode item=data}
	<li{if $periode == $bulletin} class="active"{/if}><a data-toggle="tab" href="#tabsAttitude-{$periode}">{$periode}</a></li>	
	{/foreach}
</ul>

<div class="tab-content">

{foreach from=$attitudes key=periode item=data}
	{assign var=data value=$data.$matricule}
	<div id="tabsAttitude-{$periode}" class="tab-pane fade in{if $periode == $bulletin} active{/if}">
		
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
</div>  <!-- tab-content -->
</div>
