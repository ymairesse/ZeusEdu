{if ($userStatus == admin) || ($userStatus == 'direction')}
<div class="tab-pane table-responsive" id="tabs-5">
    {assign var=liste value=$listeNotifications.ecole}
    <table class="table table-condensed tableEdit">
        <thead>
			<tr>
				<th colspan="3">&nbsp;</th>
				<th style="width:12em">Date de début</th>
				<th style="width:12em">Date de fin</th>
				<th style="width:12em">Objet</th>
				<th>Destinataire</th>
				<th style="width:1em" title="mail envoyé" data-container="body"><i class="fa fa-envelope fa-lg text-success"></i></th>
				<th style="width:1em" title="Accusé de lecture" data-container="body"><i class="fa fa-check fa-lg text-success"></i></th>
				<th style="width:1em" title="Permanent" data-container="body"><i class="fa fa-thumb-tack fa-lg text-success"></i></th>
			</tr>
		</thead>
        <!-- Notifications à l'ensemble de l'école -->
        {foreach from=$liste item=uneNote}
        <tr id="tr_{$uneNote.id}">
            <td style="width:1em">
                <input type="checkbox" class="checkDelete" id="check{$uneNote.id}" data-id="{$uneNote.id}">
            </td>
            <td style="width:1em">
                <button type="button" class="btn btn-default btn-sm btnEdit" data-id="{$uneNote.id}">
                    <i class="fa fa-pencil-square-o fa-lg text-success"></i>
                </button>
            </td>
            <td style="width:1em">
                <button type="button" class="btn btn-danger btn-delete btn-sm" data-id="{$uneNote.id}"><i class="fa fa-times"></i></button>
            </td>
            <td><span class="debut">{$uneNote.dateDebut}</span></td>
			<td><span class="fin">{$uneNote.dateFin}</span></td>
			<td><span class="objet">{$uneNote.objet}</span></td>
            <td style="width:20%;">
                <span class="destinataire">Tous</span>
            </td>
            <td title="mail envoyé" data-container="body">{if $uneNote.mail == 1}<i class="fa fa-envelope fa-lg text-success"></i>{else}&nbsp;{/if}</td>
            <td title="Accusé de lecture" data-container="body">{if $uneNote.accuse == 1}<i class="fa fa-check fa-lg text-success"></i>{else}&nbsp;{/if}</td>
            <td title="Note permanente" data-container="body">{if $uneNote.freeze == 1}<i class="fa fa-thumb-tack fa-lg text-success"></i>{else}&nbsp;{/if}</td>
        </tr>
        {/foreach}
        <tr>
            <th colspan="5">
                {if $liste|@count > 0}
                <input type="checkbox" class="selectAll"> Sélectionner <i class="fa fa-arrow-left"></i>
                <button class="btn btn-warning delModal" type="button">
                    <i class="fa fa-times text-danger"></i> Effacer
                </button>
                {else} Aucune notification à un niveau d'études {/if}
            </th>
        </tr>
    </table>
</div>
{/if}
