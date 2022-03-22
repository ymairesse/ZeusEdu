<div style="max-height:10em; overflow: auto">

    {if isset($listeRessources)}

    <table class="table table-condensed">
        <tr>
            <th>
                <button type="button"
                    class="btn btn-success btn-xs"
                    id="selAllRessources"
                    title="Inverser la sélection">
                    <i class="fa fa-arrow-circle-o-down" aria-hidden="true"></i>
                </button>

            </th>
            <th>
                Ressources existantes <span class="badge badge-danger">{$listeRessources|count}</span>
            </th>
            <th>
                <span class="badge badge-info" title="calendrier des réservations"><i class="fa fa-info"></i> </span>
            </th>
        </tr>
        {foreach from=$listeRessources key=unIdRessource item=data }
            <tr>
                <td style="width: 2em;">

                    <input type="checkbox"
                        name="ressources[]"
                        class="ressource"
                        data-idressource="{$unIdRessource}"
                        value="{$unIdRessource}"
                        {if $userStatus != 'admin'}
                            {if (($data.longTermeBy != '') || ($data.indisponible == 1))} disabled{/if}
                        {/if}>

                </td>
                <td {if ($data.longTermeBy != '') || ($data.indisponible == 1)}class="longTerme" title="Indisponible"{/if}>
                    {$data.description}
                </td>
                <td style="width:2em;">
                    <button type="button"
                        class="btn btn-info btn-xs pull-right btn-infoRessource"
                        data-idressource= "{$unIdRessource}"
                        class="btn-infoRessource"
                        title="Calendrier pour {$data.description}">
                        <i class="fa fa-info"></i>
                    </button>
                </td>
            </tr>
        {/foreach}

    </table>

    {else}
        <p>Sélectionner un type de ressources d'abord</p>
    {/if}

</div>

<script type="text/javascript">

    $(document).ready(function(){

        // restauration de la sélection dans la liste des ressources
        var idRessources = Cookies.get('idRessources');
        if (idRessources != undefined) {
            var idRessources = $.parseJSON(Cookies.get('idRessources'));
            $.each(idRessources, function(index, value){
                $('input.ressource[data-idressource="' + value +'"]').prop('checked', true);
            })
        }

    })

</script>
