<!-- Notifications à une classe -->
<div class="tab-pane hidden-print" id="tabs-3">
	{assign var=liste value=$listeNotifications.classes}
	<table class="table table-condensed tableEdit">
		<thead>

			{include file='notification/edit/entete.tpl'}

		</thead>
		{foreach from=$liste key=id item=uneNote}
		{assign var=nId value=$uneNote.id}
		<tr id="tr_{$nId}" data-id="{$nId}" data-type="classe">
			<td style="width:1em">
				<input type="checkbox" class="checkDelete" id="check{$nId}" data-id="{$nId}" data-type="classes">
			</td>
			<td style="width:1em">
				<button type="button" class="btn btn-default btnEdit btn-xs" data-id="{$nId}">
					<i class="fa fa-pencil-square-o fa-lg text-success"></i>
				</button>
			</td>
			<td title="Ajouter / supprimer une PJ" data-container="body">{if isset($listePJ[$id])}<span class="badge addPJ">{$listePJ.$id|count}</span>{else}<span class="badge addPJ">+</span>{/if}</td>
			<td style="width:1em">
				<button type="button" class="btn btn-danger btn-delete btn-xs" data-id="{$nId}" data-type="classes">
					<i class="fa fa-times"></i>
				</button>
			</td>
			<td><span class="debut">{$uneNote.dateDebut}</span></td>
			<td><span class="fin">{$uneNote.dateFin}</span></td>
			<td><span class="objet">{$uneNote.objet}</span></td>
			<td style="width:20%;">
				<span class="destinataire">Classe: {$uneNote.destinataire}</span>
			</td>
			<td>
				{if $uneNote.accuse == 1}
				<meter style="float:left; margin-right:0.5em" title="Cliquer pour voir le détail" data-container="body" class="showAccuse" value="{$listeAccuses.$nId|count|default:0}" min="0" max="{$listeAttendus.classes.$nId}" data-id="{$nId}"></meter>
				<span class="discret">{$listeAccuses.$nId|count|default:0}/{$listeAttendus.classes.$nId}</span>
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
				<button class="btn btn-warning delModal" type="button" data-type="classes">
					<i class="fa fa-times text-danger"></i> Effacer
				</button>
				{else}
				<p class="avertissement">Aucune notification dans cette catégorie</p>
				{/if}
			</th>
		</tr>
	</table>
</div>
