<h4 class="bg-info">{$nomProf}</h4>
<table class="table table-condensed">
    <thead>
        <tr>
            <th>Cours</th>
            <th>Libelle</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$listeAffectations key=coursGrp item=dataCours}
        <tr>
            <td>{$coursGrp}</td>
            <td>{$dataCours.libelle}</td>
        </tr>
        {/foreach}
    </tbody>

</table>
