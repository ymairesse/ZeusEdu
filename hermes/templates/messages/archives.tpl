<div id="archives" class="tab-pane fade" style="max-height:35em; overflow: auto">

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Date</th>
                <th>Destinataires</th>
                <th>Objet</th>
                <th>Texte</th>
                <th>PJ</th>
            </tr>
        </thead>
        {foreach from=$listeArchives key=id item=message}
        <tr data-id="{$id}">
            <td class="arch">{$message.date} {$message.heure|truncate:5:''}</td>
            <td class="arch">{$message.acroDest}</td>
            <td class="arch">{$message.objet}</td>
            <td class="arch">{$message.texte|truncate:150:'...'}</td>
            <td class="arch">
                {if isset($pjFromUser.$id)}
                <span class="badge pop"
                    data-html="true"
                    data-placement="left"
                    data-title="Pièces jointes"
                    data-content="<ul class='list-unstyled'>{foreach from=$pjFromUser.$id item=liste}<li>{$liste.PJ}</li>{/foreach}</ul>">
                    {$pjFromUser.$id|@count}
                </span>
                {else}
                -
                {/if}
            </td>
            <td>{if $message.publie == 0}
                <button type="button" data-content="Supprimer cette archive" class="btn btn-danger btn-xs btn-delArchive pop pull-right"><i class="fa fa-times"></i></button>
                {else}
                <span class="badge pull-right pop"
                    data-content="Ce mail est publié jusqu'à la date du {$message.dateFin}"
                    data-html="true"
                    data-placement="left"
                    data-title="Impossible d'effacer">
                {$message.dateFin|truncate:5:''}
                </span>
                {/if}
            </td>
        </tr>
        {/foreach}
    </table>

</div>
