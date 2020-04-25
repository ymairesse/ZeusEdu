<div class="table-responsive">
<table class="tableauAdmin table table-striped table-condensed">
	<thead>
		<tr>
			<th>Prof</th>
			<th>Date</th>
			<th>Heure</th>
			<th>Motifs</th>
			<th>Traitements</th>
			<th>A suivre</th>
		</tr>
	</thead>
{foreach from=$consultEleve key=ID item=uneVisite}
	<tr>
		<td>{$uneVisite.acronyme|default:'&nbsp;'}</td>
		<td>{$uneVisite.date|default:'&nbsp;'}</td>
		<td>{$uneVisite.heure|default:'&nbsp;'|truncate:5:''}</td>
		<td class="popover-eleve"
			data-original-title="Motif"
			data-container="body"
			data-html="true"
			data-placement="top"
			data-content="{$uneVisite.motif}">
			{$uneVisite.motif|truncate:70:"..."|default:'&nbsp;'}
		</td>
		<td class="popover-eleve"
			data-original-title="Traitement"
			data-container="body"
			data-html="true"
			data-placement="top"
			data-content="{$uneVisite.traitement}">
			{$uneVisite.traitement|truncate:40:"..."|default:'&nbsp;'}
		</td>
		<td class="popover-eleve"
			data-original-title="Suivi"
			data-container="body"
			data-html="true"
			data-placement="left"
			data-placement="top"
			data-content="{$uneVisite.aSuivre}">
			{$uneVisite.aSuivre|truncate:30:"..."|default:'&nbsp;'}
		</td>

	</tr>
{/foreach}
</table>

</div>  <!-- table-responsive -->

<script type="text/javascript">

	$(document).ready(function(){

	$(".popover-eleve").mouseover(function(){
		$(this).popover('show');
		})
	$(".popover-eleve").mouseout(function(){
		$(this).popover('hide');
		})

	})

</script>
