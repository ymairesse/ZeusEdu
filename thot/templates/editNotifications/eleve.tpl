<!-- Notifications à un élève -->
<div class="tab-pane active hidden-print" id="tabs-1">
	{assign var=liste value=$listeNotifications.eleves}
	<table class="table table-condensed tableEdit">
		<thead>

			{include file='editNotifications/entete.tpl'}

		</thead>
		{foreach from=$liste item=uneNote}
		{assign var=matricule value=$uneNote.destinataire}
		{assign var=nId value=$uneNote.id}
		<tr id="tr_{$nId}">
			<td style="width:1em">
				<input type="checkbox" class="checkDelete" id="check{$nId}" data-id="{$nId}" data-type="eleves">
			</td>
			<td style="width:1em">
				<button type="button" class="btn btn-default btnEdit btn-xs" data-id="{$nId}">
					<i class="fa fa-pencil-square-o fa-lg text-success"></i>
				</button>
			</td>
			<td style="width:1em">
				<button type="button" class="btn btn-danger btn-delete btn-xs" data-id="{$nId}" data-type="eleves">
					<i class="fa fa-times"></i>
				</button>
			</td>
			<td><span class="debut">{$uneNote.dateDebut}</span></td>
			<td><span class="fin">{$uneNote.dateFin}</span></td>
			<td><span class="objet">{$uneNote.objet}</span></td>
			<td style="width:20%;">
				<span class="destinataire">
					{$detailsEleves.$matricule.prenom} {$detailsEleves.$matricule.nom}: {$detailsEleves.$matricule.classe} <i class="fa fa-circle-thin pull-right urgence{$uneNote.urgence}" title="Niveau d'urgence {$uneNote.urgence}"></i>
				</span>
			</td>
			<td>
				{if isset($statsAccuses.$nId)}
				<meter title="Cliquer pour voir le détail" data-container="body" class="showAccuse" value="{$statsAccuses.$nId.confirme}" min="0" max="{$statsAccuses.$nId.count}" data-id="{$nId}"></meter>
				<span class="discret">{$statsAccuses.$nId.confirme}/{$statsAccuses.$nId.count}</span>
				{else}N/A
				{/if}
			</td>
			<td title="mail envoyé" data-container="body">{if $uneNote.mail == 1}<i class="fa fa-envelope fa-lg text-success"></i>{else}&nbsp;{/if}</td>
			<td title="Note permanente" data-container="body">{if $uneNote.freeze == 1}<i class="fa fa-thumb-tack fa-lg text-success"></i>{else}&nbsp;{/if}</td>
		</tr>
		{/foreach}

		<tr>
			<th colspan="5">
				{if $liste|@count > 0}
				<input type="checkbox" class="selectAll"> Sélectionner <i class="fa fa-arrow-left"></i>
				<button class="btn btn-warning delModal" type="button" data-type="eleves">
					<i class="fa fa-times text-danger"></i> Effacer
				</button>
				{else} Aucune notification à un niveau d'études {/if}
			</th>
		</tr>
	</table>
</div>
