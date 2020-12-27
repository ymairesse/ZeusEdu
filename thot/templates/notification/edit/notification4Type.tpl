<table class="table table-condensed tableEdit">
	<thead>

		{include file='notification/edit/entete.tpl'}

	</thead>
	<tbody>

	{foreach from=$liste item=uneNote}

	{assign var=nId value=$uneNote.id}
	<tr id="tr_{$nId}" data-id="{$nId}" data-type="{$type}" {if isset($listeNotifId) && in_array($nId, $listeNotifId)} class="selected"{/if}>
		<td style="width:1em">
			<input type="checkbox" class="checkDelete" id="check{$nId}" data-id="{$nId}" data-type="{$type}">
		</td>
		<td style="width:1em" class="pop" data-content="Modifier cette annonce" data-container="body">
			<button type="button" class="btn btn-default btnEdit btn-xs pop" data-id="{$nId}" data-type="{$type}">
				<i class="fa fa-pencil-square-o fa-lg text-success"	></i>
			</button>
		</td>
		<td>
			<span data-content="{$listePJ.$nId|count|default:0} PJ" class="badge pop">{$listePJ.$nId|count|default:0}</span>
		</td>
		<td style="width:1em">
			<button type="button" class="btn btn-danger btn-delete btn-xs" data-id="{$nId}" data-type="{$type}">
				<i class="fa fa-times"></i>
			</button>
		</td>
		<td>{$uneNote.dateEnvoi}</td>
		<td><span class="debut">{$uneNote.dateDebut}</span></td>
		<td><span class="fin">{$uneNote.dateFin}</span></td>
		<td><span class="objet">{$uneNote.objet}</span></td>
		<td style="width:20%;">
			<span class="destinataire">
				{if $uneNote.type == 'eleves'}
				{$uneNote.nom} {$uneNote.prenom} {$uneNote.groupe}
				{else}
				{$uneNote.destinataire}
				{/if}
			</span>
		</td>
		<td>
			{if $uneNote.accuse == 1}
			<meter style="float:left; margin-right:0.5em" title="Cliquer pour voir le détail" data-container="body" class="showAccuse" value="{$listeAccuses.$nId|count|default:0}" min="0" max="{$listeAttendus.$type.$nId}" data-id="{$nId}"></meter>
			<span class="discret">{$listeAccuses.$nId|count|default:0}/{$listeAttendus.{$type}.$nId}</span>
			{else}N/A
			{/if}
		</td>
		<td title="mail envoyé" data-container="body">{if $uneNote.mail == 1}<i class="fa fa-envelope fa-lg text-success"></i>{else}&nbsp;{/if}</td>
		<td title="Note permanente" data-container="body">{if $uneNote.freeze == 1}<i class="fa fa-thumb-tack fa-lg text-success"></i>{else}&nbsp;{/if}</td>
	</tr>
	{/foreach}
	</tbody>

	<tfoot>
		<tr>
			<th colspan="10">
				{if $liste|@count > 0}
				<div class="checkbox pull-left">
  					<label><input type="checkbox" class="selectAll">Sélectionner <i class="fa fa-arrow-left"></i></label>&nbsp;
				</div>

				<button class="btn btn-warning delModal" type="button" data-type="{$type}">
					<i class="fa fa-times text-danger"></i> Effacer
				</button>
				{else}
					<p class="avertissement">Aucune annonce dans cette catégorie</p>
				{/if}
			</th>
		</tr>
	</tfoot>
</table>
