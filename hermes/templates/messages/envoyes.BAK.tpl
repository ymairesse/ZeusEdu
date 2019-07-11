<div id="envoye" class="tab-pane fade">

    <h2>Mes épinglettes en cours</h2>

    <table class="table table-condensed table-striped">
        <thead>
            <tr>
                <th style="width:14em;">Date</th>
                <th style="width:12em;">Destinataire(s)</th>
                <th style="width:10em;">Objet</th>
                <th>Texte</th>
                <th style="width:1em;">PJ</th>
                <th style="width:12em;">Date de fin</th>
                <th style="width:1em;"></th>
            </tr>
        </thead>
        {foreach from=$messagesFromUser key=id item=unMail}
        <tr data-id="{$unMail.id}">
            <td class="envoi">{$unMail.date} {$unMail.heure}</td>
            <td class="envoi">{$unMail.acroDest}</td>
            <td class="envoi">{$unMail.objet}</td>
            <td class="envoi">{$unMail.texte|truncate:150}</td>
            <td class="envoi">
                {if $unMail.pj|@count > 0}
                <span class="badge pop"
                    data-html="true"
                    data-placement="left"
                    data-title="Pièces jointes"
                    data-content="<ul class='list-unstyled'>{foreach from=$unMail.pj item=liste}<li>{$liste}</li>{/foreach}</ul>">
                    {$unMail.pj|@count}
                </span>
                {else}
                -
                {/if}
            </td>
            <td>
                <button type="button" title="Changer la date de fin" class="btn btn-warning btn-xs btn-date">{$unMail.dateFin}</button>
            </td>
            <td>
                <button type="button" class="btn btn-danger btn-xs btn-del"><i class="fa fa-times"></i></button>
            </td>
        </tr>
        {/foreach}
    </table>

</div>
