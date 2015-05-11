<form name="modifVisite" method="POST" action="index.php" class="microForm">
	<input type="hidden" name="action" value="modifier">
	<input type="hidden" name="mode" value="visite">
	<input type="hidden" name="matricule" value="{$matricule}">
	<button class="btn btn-primary pull-right" type="submit" name="submit">Nouvelle visite</button>
	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
</form>

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
			<th style="width:32px">&nbsp;</th>
			<th style="width:32px">&nbsp;</th>
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
		<td data-container="body"
			title="Modifier">
			<form name="modifier" method="POST" action="index.php" class="microForm noborder">
				<input type="hidden" name="consultID" value="{$uneVisite.consultID}">
				<input type="hidden" name="matricule" value="{$eleve.matricule}">
				<input type="hidden" name="classe" value = "{$eleve.classe}">
				<input type="hidden" name="action" value="modifier">
				<input type="hidden" name="mode" value="visite">
				<button type="submit" class="btn btn-default" name="submit">
					<span class="glyphicon glyphicon-edit" style="color:green">	</span>
				</button>
				<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
			</form>
		</td>
		<td data-container="body"
			title="Supprimer">
			<form name="modifier" method="POST" action="index.php" class="microForm noborder">
				<input type="hidden" name="consultID" value="{$uneVisite.consultID}">
				<input type="hidden" name="matricule" value="{$eleve.matricule}">
				<input type="hidden" name="classe" value = "{$eleve.classe}">
				<input type="hidden" name="action" value="supprimer">
				<input type="hidden" name="mode" value="visite">
				<button class="btn btn-default delete" type="submit">
					<span class="glyphicon glyphicon-remove" style="color:red"></span>
				</button>
				<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
			</form>
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