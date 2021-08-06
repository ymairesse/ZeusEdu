{assign var=first value=0}
{assign var=width value=85/$listeHeuresCours|count}
{assign var=nbCol value=$listeHeuresCours|count+1}

<table class="table table-condensed">
    {foreach from=$listeRessources key=idRessource item=dataRessource}
    <tr>
        <th colspan="{$nbCol}">
            <h3>{$listeRessources.$idRessource.description}
                {if $userStatus == 'admin'}
                <button type="button" data-idRessource="{$idRessource}" data-idtype="{$dataRessource.idType}" class="btn btn-success btn-xs pull-right" id="btn-longTerme">
                    <i class="fa fa-calendar"></i> Long Terme
                </button>
                {/if}
            </h3>
        </th>
    </tr>
    <tr>
        <th style="width:15%">Date</th>
        {foreach from=$listeHeuresCours key=wtf item=heure}
            <td class="micro" style="text-align:center; width: {$width}%">
            {$heure}
            {if $first == 0}
            <a class="badge badge-success badge-xs btn-allPeriode"
                href="javascript:void(0)"
                data-heure={$heure}>
                <i class="fa fa-arrow-down"></i></a>
            {/if}
            </td>
        {/foreach}
    </tr>
{assign var=first value=$first+1}
{foreach from=$planOccupation.$idRessource key=date item=dataOccupation}

    {assign var=dateFRJ value=$date|substr:8:2}
    {assign var=dateFRM value=$date|substr:5:2}

    <tr data-date="{$date}"
        data-idressource="{$idRessource}">
        <td>
            {$dateFRJ}/{$dateFRM}
            <button type="button"
                class="btn btn-success btn-xs pull-right btn-allDate"
                data-date="{$date}"
                data-idressource="{$idRessource}">
                <i class="fa fa-arrow-right"></i>
            </button>
        </td>
        {foreach from=$listeHeuresCours key=wtf item=heure}
            <td style="width:{$width}%">
                {assign var=abreviation value=$dataOccupation.$heure.user|default:''}

                {assign var=occupied value=isset($dataOccupation.$heure.user)}
                {assign var=attribue value=$dataOccupation.$heure.attribue|default:0}
                {if isset($dataOccupation.$heure.nom)}
                    {assign var=nom value=$dataOccupation.$heure.nom|cat:' '|cat:$dataOccupation.$heure.prenom}
                    {else}
                    {assign var=nom value=''}
                {/if}

                {if $occupied == 1}
                    {if $attribue == 1}
                        {include file='ressources/boutonAttribue.tpl'}
                    {else}
                        {include file='ressources/boutonOccupe.tpl'}
                    {/if}
                {else}
                    {include file='ressources/boutonReservation.tpl'}
                {/if}
            </td>
        {/foreach}
    </tr>

    {/foreach}

{/foreach}
</table>

<p class="pull-right">
    Légende:
    <button type="button" class="btn btn-xs btn-success">Libre</button>
    <button type="button" class="btn btn-xs btn-danger">Réservé par</button>
    <button type="button" class="btn btn-xs btn-warning">En sa possession</button>
    Personnel:
    <button type="button" class="btn btn-xs btn-lightBlue">Réservé par moi</button>
    <button type="button" class="btn btn-xs btn-blue">En ma possession</button>
</p>
