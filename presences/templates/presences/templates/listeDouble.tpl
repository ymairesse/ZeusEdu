{foreach from=$listeDouble key=i item=liste}

<table class="table-condensed table-hover tableauPresences" id="tableauPresences{$i}">

	<thead {if $i == 1}class="hidden-sm hidden-xs"{/if}>
		<tr>
			<th style="width:5em" class="hidden-sm hidden-xs">&nbsp;</th>
			<th style="width:230px">&nbsp;</th>
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
			<th style="width:30px" class="hidden-sm hidden-xs"><strong class="ordre">{$noOrdre}</strong> {$unEleve.classe|default:'&nbsp;'}</th>
			{assign var=noOrdre value=$noOrdre+1}
			<td style="width:230px"
				{if $photosVis == 'visible'}
				class="pop"
				data-toggle="popover"
				data-content="<img src='../photos/{$unEleve.photo}.jpg' alt='{$unEleve.matricule|default:'Pas de photo'}' style='width:100px'>"
				data-html="true"
				data-container="body"
				{/if}>
				{assign var=statut value=$listePr.$periode.statut|default:'indetermine'}
				<button class="btn btn-large btn-block nomEleve {$statut} clip"
						id="nomEleve-{$matricule}"
						data-matricule="{$matricule}"
						data-statut="{$statut}"
						type="button">
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
	<tfoot {if $i == 0}class="hidden-sm hidden-xs"{/if}>
		<tr>
			<th style="width:30px" class="hidden-sm hidden-xs">&nbsp;</th>
			<th style="width:230px">&nbsp;</th>
		{foreach from=$lesPeriodes item=noPeriode}
			<th class="trash {if $noPeriode != $periode} disabled{/if}"
				data-periode="{$noPeriode}">
				<i class="fa fa-trash"></i>
			</th>
		{/foreach}
		</tr>
	</tfoot>
</table>

{/foreach}
