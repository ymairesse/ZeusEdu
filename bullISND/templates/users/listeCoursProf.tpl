<h4 class="bg-primary">{$nomProf} <i class="fa fa-arrow-right pull-right"></i></h4>
<table class="table table-condensed">
    <thead>
        <tr>
            <th>Cours</th>
            <th>Libelle</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$listeAffectations key=coursGrp item=dataCours}
        <tr class="unCours">
            <td>{$coursGrp}</td>
            <td>{$dataCours.libelle}</td>
            <td><input type="checkbox" name="cours[]" value="{$dataCours.coursGrp}"></td>
        </tr>
        {/foreach}
    </tbody>

</table>
