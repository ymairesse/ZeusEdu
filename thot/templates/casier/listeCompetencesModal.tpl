<table class="table table-condensed" id="tableCompetences">
    <thead>
        <tr>
            <th style="width:2em">&nbsp;</th>
            <th style="width:65%">Compétence</th>
            <th style="width:5%">Form</th>
            <th style="width:5%">Cert</th>
            <th>Max</th>
            <th style="width:2em">&nbsp;</th>
        </tr>
    </thead>
    <tbody>

        {foreach from=$listeCompetences key=id item=competence}
        {$id} => {$competence} <br>
        {/foreach}

    </tbody>
</table>
