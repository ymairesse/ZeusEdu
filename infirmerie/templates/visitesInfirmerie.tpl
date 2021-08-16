<table class="tableauAdmin table table-striped table-condensed">
	<thead>
		<tr>
			<th>Prof</th>
			<th>Date</th>
			<th>Heure</th>
			<th>Motifs</th>
			<th>Traitements</th>
			<th>A suivre</th>
			<th style="width:32px">&nbsp;</th>
			<th style="width:32px">&nbsp;</th>
		</tr>
	</thead>
{foreach from=$consultEleve key=ID item=uneVisite}
	<tr data-consultid="{$uneVisite.consultID}" {if $uneVisite.consultID == $consultID}class="selected"{/if}>
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
		<td>
			<button type="button" class="btn btn-success btn-xs btn-editVisite"
				data-consultid="{$uneVisite.consultID}"
				data-matricule="{$dataEleve.matricule}"
				{if $noButtons == true}disabled{/if}>
				<span class="fa fa-edit"></span>
			</button>
		</td>
		<td>
			<button type="button" class="btn btn-danger btn-xs btn-delVisite"
				data-consultid="{$uneVisite.consultID}"
				data-matricule="{$dataEleve.matricule}"
				{if $noButtons == true}disabled{/if}>
				<span class="fa fa-times"></span>
			</button>
		</td>
	</tr>
{/foreach}
<tr>
	<td colspan="8">
		<button class="btn btn-primary btn-block" type="button" id="btn-newVisite" data-matricule="{$dataEleve.matricule}">
			Nouvelle visite
		</button>
	</td>
</tr>
</table>


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
