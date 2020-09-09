
{if isset($listeMembres)}

    <table class="table table-condensed table-striped">
        <thead>
            <tr>
                <th colspan="2">Membres actuels de <span class="pull-right" style="font-size:12pt; color:red;">{$detailsListe.nomListe}</span></th>
            </tr>
        </thead>

        <tbody>
            {foreach from=$listeMembres key=acronyme item=data}
            <tr data-acronyme="{$acronyme}">
                <td>{$data.nom} {$data.prenom}</td>
                <td style="width:2em;"><button type="button" class="btn btn-danger btn-delMembre btn-xs"><i class="fa fa-times"></i></button></td>
            </tr>
            {/foreach}
        </tbody>

    </table>

{else}

    <p class="avertissement">Veuillez choisir ou créer une liste à gauche</p>

{/if}
