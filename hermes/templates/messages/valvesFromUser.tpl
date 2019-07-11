<div id="valvesFrom" class="tab-pane fade">

    <h3>Mes envois aux valves <span class="badge pull-right" style="background:red"> {$messagesFromUser|@count}</span></h3>

    <div class="table-responsive">

        <table class="table table-condensed table-striped">
            <thead>
                <tr>
                    <th style="width:14em;">Date</th>
                    <th style="width:10em;">Objet</th>
                    <th>Texte</th>
                    <th style="width:7em;">Destinataires</th>
                    <th style="width:1em;">PJ</th>
                    <th style="width:3em;">&nbsp;</th>
                    <th style="width:1em;">&nbsp;</th>
                </tr>
            </thead>
            {foreach from=$messagesFromUser key=id item=uneNote}
            <tr data-id="{$id}" title="{$id}" class="{if $uneNote.lecture == 0 && $uneNote.acronyme != $acronyme}nonLu{/if}>
                <td class="epingle">{$uneNote.date} {$uneNote.heure|truncate:5:''}</td>
                <td class="epingle objet">{$uneNote.objet}</td>
                <td class="epingle">{$uneNote.texte|truncate:150}</td>
                <td class="epingle">{$uneNote.acroDest}</td>
                <td>
                    {if isset($pj4Notifs.$id) && $pj4Notifs.$id|@count > 0}
                    <span class="badge pop" data-html="true" data-placement="left" data-title="Pièces jointes" data-content="<ul class='list-unstyled'>{foreach from=$pj4Notifs.$id item=liste}<li>{$liste.pj}</li>{/foreach}</ul>">
                            {$pj4Notifs.$id|@count}
                        </span> {else} - {/if}
                </td>
                <td>
                    <button type="button" data-content="Changer la date de fin: {$uneNote.dateFin}" data-id="{$uneNote.id}" class="btn btn-green btn-xs btn-date pop">
                        > {$uneNote.dateFin|truncate:5:''}
                    </button>
                </td>
                <td>
                    <button type="button" data-content="Supprimer cette annonce" class="btn btn-danger btn-xs btn-delvalve pop"><i class="fa fa-times"></i></button>
                </td>
            </tr>
            {/foreach}
        </table>

    </div>

</div>
