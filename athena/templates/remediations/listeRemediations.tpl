<div class="col-md-7 col-xs-12">
    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Date</th>
                <th>Heure</th>
                <th>Prof</th>
                <th>Thème</th>
            </tr>
        </thead>
        <tbody>
        {foreach from=$listeRemediations key=id item=data}
            <tr>
                <td>{$data.startDate|substr:0:10}</td>
                <td>{$data.startDate|substr:11:99}</td>
                <td>{$data.prenom} {$data.nom}</td>
                <td>{$data.title}</td>
            </tr>

        {/foreach}
        </tbody>
    </table>
</div>
<div class="col-md-5 col-xs-12">

</div>
