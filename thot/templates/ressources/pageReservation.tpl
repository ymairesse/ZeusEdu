{assign var=first value=0}
{assign var=width value=80/$listeHeuresCours|count}
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
            {foreach from=$listeHeuresCours key=n item=dataHeure}
                <td class="micro" style="text-align:center; width: {$width}%">
                {$dataHeure.debut}
                {if $first == 0}
                <a class="badge badge-success badge-xs btn-allPeriode"
                    href="javascript:void(0)"
                    data-heure={$dataHeure.debut}>
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
            <td style="20%">
                {$dateFRJ}/{$dateFRM}
                <button type="button"
                    class="btn btn-success btn-xs pull-right btn-allDate"
                    data-date="{$date}"
                    data-idressource="{$idRessource}">
                    <i class="fa fa-arrow-right"></i>
                </button>
            </td>
            {foreach from=$listeHeuresCours key=n item=dataHeure}
                <td style="width:{$width}%">
                    {assign var=heure value=$dataHeure.debut}
                    {assign var=occupied value=isset($dataOccupation.$heure.user)}
                    {assign var=osf value=!in_array($heure, array_keys($dataOccupation))}
                    {if $osf == 1}
                    <button type="button" class="btn btn-info btn-xs btn-block" disabled>-</button>
                    {else}
                        {if $occupied}
                        <button type="button"
                            class="btn {if $dataOccupation.$heure.user != $acronyme}btn-info{else}btn-danger{/if} btn-xs btn-hire btn-block btn-reserved"
                            data-acronyme="{$dataOccupation.$heure.user}"
                            data-heure="{$heure}"
                            data-date="{$date}"
                            data-idressource="{$idRessource}"
                            title="{$dataOccupation.$heure.nom} {$dataOccupation.$heure.prenom}">
                            <span class="micro">{$dataOccupation.$heure.user}</span>
                        </button>
                        {else}
                        <button type="button"
                            class="btn btn-success btn-xs btn-block btn-hire btn-reservation"
                            data-heure="{$heure}"
                            data-date="{$date}"
                            data-idressource="{$idRessource}">
                            <i class="fa fa-user"></i>
                        </button>
                        {/if}
                    {/if}

                </td>
            {/foreach}
        </tr>

    {/foreach}
    {/foreach}
    </table>

{if $userStatus == 'admin'}
<p class="micro pull-right">Administrateur: clic droit pour supprimer une réservation</p>
{/if}
