<strong>{$dateFr}</strong>
<div class="clearfix"></div>

{assign var=noOrdre value=1}
{* répartition des élèves dans deux colonnes sur les écrans larges; sinon, les deux tableaux seront superposés *}
{assign var=nbCol1 value=round($listeEleves|count / 2)}
{assign var=listeDouble value=array($listeEleves|array_slice:0:$nbCol1:true, $listeEleves|array_slice:$nbCol1:Null:true)}

{foreach from=$listeDouble key=i item=liste}

<div class="col-lg-6 col-md-12" style="padding:0">

<table class="table table-condensed tableauPresences" id="tableauPresences{$i}" style="margin:0;">

	<thead {if $i > 0}class="hidden-md hidden-sm hidden-xs"{/if}>
		<tr>
			<th style="width:30px" class="hidden-md">&nbsp;</th>
			<th style="width:240px">&nbsp;</th>
			{foreach from=$lesPeriodes item=noPeriode}
			<th class="horloge {if $noPeriode == $periode}ouvert{else}ferme{/if}"
				data-periode="{$noPeriode}">
				<i class="fa {if $noPeriode == $periode}fa-clock-o{else}fa-circle-thin{/if}"></i>
			</th>
			{/foreach}
		</tr>
	</thead>

	{foreach from=$liste key=matricule item=unEleve}
		{assign var=listePr value=$listePresences.$matricule}
		<tr>
			<th style="width:30px" class="hidden-md">
				<strong class="ordre">{$noOrdre}</strong> {$unEleve.classe|default:'&nbsp;'}
			</th>
			{assign var=noOrdre value=$noOrdre+1}
			<td style="width:240px">
				{assign var=statut value=$listePr.$periode.statut|default:'indetermine'}
				<button class="btn btn-large btn-block nomEleve {$statut} clip"
						id="nomEleve-{$matricule}"
						data-matricule="{$matricule}"
						data-statut="{$statut}"
						type="button"
						{if $photosVis == 'visible'}
						data-toggle="popover"
						data-trigger="hover"
						data-html="true"
						data-content="<img src='../photos/{$unEleve.photo}.jpg' style='width:100px'><br><small>{$matricule}</small>"
						title="{$unEleve.nom|cat:' '|cat:$unEleve.prenom|truncate:20:'...'}"
						{/if}>

					<span class="visible-xs">{$unEleve.nom|truncate:10:'..'} {$unEleve.prenom|truncate:10:'.'}</span>
					<span class="visible-sm visible-md visible-lg">{$unEleve.nom|truncate:20:'...'|default:'&nbsp;'} {$unEleve.prenom|default:'&nbsp;'}</span>

				</button>
			</td>

			{* on passe les différentes périodes existantes en revue *}
			{foreach from=$lesPeriodes item=noPeriode}
				{assign var=statut value=$listePr.$noPeriode.statut|default:''}
				{assign var=color value=$listeJustifications.$statut.color|default:'#000'}
				{assign var=background value=$listeJustifications.$statut.background|default:'#fff'}
				<td class="{if $noPeriode==$periode} now{else} notNow{/if} {$statut}
					{if (!in_array($statut, array_keys($justifications)))} lock{/if}"
					id="lock-{$matricule}_periode-{$noPeriode}"
					style="color:{$color}; background:{$background}"
					data-statut="{$statut}"
					data-periode="{$noPeriode}"
					data-matricule="{$matricule}"
					title="{$listePr.$noPeriode.educ}"
					data-container="body">

					{if (in_array($statut, array_keys($justifications)))}
						<strong>{$noPeriode}</strong>
						{else}
						<span class="glyphicon glyphicon-lock" title="{$listeJustifications.$statut.libelle|default:'Absence déjà signalée'}"></span>
					{/if}

					{if ($noPeriode == $periode)}
						<input type="hidden"
							value="{$statut}"
							name="matr-{$matricule}"
							class="cb"
							id="matr-{$matricule}"
							{if (!in_array($statut, array_keys($justifications)))}
								disabled
							{/if}>
					{/if}
				</td>
			{/foreach}  {* $lesPeriodes *}
		</tr>
	{/foreach}  {* $liste *}

	<!-- ouuuupsss... pour réinitialiser la prise de présences de cette période -->
	<tfoot {if $i < 1}class="hidden-md hidden-sm hidden-xs"{/if}>
		<tr>
			<th style="width:30px" class="hidden-md">&nbsp;</th>
			<th style="max-width:240px">&nbsp;</th>
		{foreach from=$lesPeriodes item=noPeriode}
			<th class="trash {if $noPeriode != $periode} disabled{/if}"
				data-periode="{$noPeriode}">
				<i class="fa fa-trash"></i>
			</th>
		{/foreach}
		</tr>
	</tfoot>
</table>

</div>  <!-- col-md... -->

{/foreach}  {* $listeDouble *}

<script type="text/javascript">

	$(document).ready(function(){
		$('*[data-toggle="popover"]').popover();
	})

</script>
