<div style="height:45em; overflow: auto">

    <table class="table table-condensed">

        <tr>
            <th>acronyme</th>
            <th>Nom</th>
            <th>Nombre de prises de présences</th>
        </tr>

        {foreach from=$listeStats key=acronyme item=data}
            <tr>
                <td>{$acronyme}</td>
                <td>{$data.nom} {$data.prenom}</td>
                <td>{$data.nb}</td>
            </tr>
        {/foreach}

    </table>

</div>
