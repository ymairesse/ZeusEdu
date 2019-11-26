{if $classe != Null && $date != Null}
<div class="container-fluid">

<h3>Feuille de présences pour la classe de <strong>{$classe}</strong> le <strong>{$date}</strong></h3>
<div class="table-responsive">

	<table class="table table-condensed">
		<thead>
		<tr>
			<th style="width:6em">Matricule</th>
			<th style="width:30em">Nom/prénom</th>
			{foreach from=$listePeriodes key=noPeriode item=limitesPeriode}
			<th><strong>{$noPeriode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
			{/foreach}
		</tr>
		</thead>

		{foreach from=$listeEleves key=matricule item=dataEleve}
		<tr>
			<td>{$matricule}</td>
			<td>
				<span style="cursor:pointer" class="popover-eleve" data-toggle="popover" data-content="<img src='../photos/{$dataEleve.photo}.jpg' alt='{$matricule}' style='width:100px'>" data-html="true" data-container="body" data-original-title="{$dataEleve.nom} {$dataEleve.prenom}">
				{$dataEleve.nom} {$dataEleve.prenom}
				</span>
			</td>
			{foreach from=$listePeriodes key=noPeriode item=data}
				{assign var=p value=$listePresences.$matricule.$noPeriode}
				{assign var=statut value=$p.statut}
				{if $statut != 'indetermine'}
					{assign var=titre value=$p.educ|cat:' ['|cat:$p.quand|cat:' à '|cat:$p.heure|cat:']'}
					{else}
					{assign var=titre value='Présences non prises'}
				{/if}
				<td class="pop"
					data-content="{$p.parent|cat:'-'|cat:$p.media}"
					data-html="true"
					data-container="body"
					data-original-title="{$titre}"
					data-placement="top">
					<span style="display:block; width:100%; color:{$statutsAbs.$statut.color|default:'#e00'}; background:{$statutsAbs.$statut.background|default:'#666'}; text-align:center">
						{$statutsAbs.$statut.shortJustif|default:'!!!'}
					</span>
				</td>
			{/foreach}
		</tr>
		{/foreach}
	</table>

</div>

{include file='legendeAbsences.tpl'}
</div>

<script type="text/javascript">
	$(document).ready(function(){

	$(".popover-eleve").mouseenter(function(event){
		$(this).popover('show');
		})

	$(".popover-eleve").mouseout(function(event){
			$(this).popover('hide');
		})

	})

</script>

{/if}
