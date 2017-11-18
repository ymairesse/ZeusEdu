<!-- Notifications à un élève -->
<div class="tab-pane active hidden-print" id="tabs-1">
	{assign var=liste value=$listeNotifications.eleves}
	<table class="table table-condensed tableEdit">
		<thead>

			{include file='notification/edit/entete.tpl'}

		</thead>
		{foreach from=$liste item=uneNote}
		{assign var=matricule value=$uneNote.destinataire}
		{assign var=nId value=$uneNote.id}
		<tr id="tr_{$nId}" data-id="{$nId}">
			<td style="width:1em">
				<input type="checkbox" class="checkDelete" id="check{$nId}" data-id="{$nId}" data-type="eleves">
			</td>
			<td style="width:1em">
				<button type="button" class="btn btn-default btnEdit btn-xs pop" data-id="{$nId}" data-type="eleves" data-content="Modifier cette annonce">
					<i class="fa fa-pencil-square-o fa-lg text-success"></i>
				</button>
			</td>
			<td>
				<span data-content="Nombre de PJ" class="badge pop">{$listePJ.$nId|count|default:0}</span>
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
					{$uneNote.detailsEleve.prenom} {$uneNote.detailsEleve.nom}: {$uneNote.detailsEleve.classe}
				</span>
			</td>
			<td>
				{if $uneNote.accuse == 1}
				<meter style="float:left; margin-right:0.5em" title="Cliquer pour voir le détail" data-container="body" class="showAccuse" value="{$listeAccuses.$nId|count|default:0}" min="0" max="{$listeAttendus.eleves.$nId}" data-id="{$nId}"></meter>
				<span class="discret">{$listeAccuses.$nId|count|default:0}/{$listeAttendus.eleves.$nId}</span>
				{else}N/A
				{/if}
			</td>
			<td title="mail envoyé" data-container="body">{if $uneNote.mail == 1}<i class="fa fa-envelope fa-lg text-success"></i>{else}&nbsp;{/if}</td>
			<td title="Note permanente" data-container="body">{if $uneNote.freeze == 1}<i class="fa fa-thumb-tack fa-lg text-success"></i>{else}&nbsp;{/if}</td>
		</tr>
		{/foreach}

		<tr>
			<th colspan="10">
				{if $liste|@count > 0}
				<input type="checkbox" class="selectAll"> Sélectionner <i class="fa fa-arrow-left"></i>
				<button class="btn btn-warning delModal" type="button" data-type="eleves">
					<i class="fa fa-times text-danger"></i> Effacer
				</button>
				{else}
					<p class="avertissement">Aucune annonce dans cette catégorie</p>
				{/if}
			</th>
		</tr>
	</table>
</div>
