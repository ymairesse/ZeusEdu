<div style="height:25em; overflow: auto">

    <table class="table table-condensed">
        <tr>
            <th>Nom</th>
            <th>Première connexion à </th>
        </tr>
        {foreach from=$listeEleves key=matricule item=data}
        <tr title="{$matricule}">
            {assign var=user value=$data.user}
            <td>
                {$data.classe} {$data.nom} {$data.prenom}
            </td>
            <td>
                {$listePresences.$user|substr:0:5|default:'pas connecté'}
            </td>
        </tr>
        {/foreach}
    </table>

</div>
