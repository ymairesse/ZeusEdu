<table class="table table-condensed" id="tableCompetences">
    <thead>
        <tr>
            <th style="width:2em">&nbsp;</th>
            <th>Compétence(s) à ajouter</th>
        </tr>
    </thead>
    <tbody>

        {foreach from=$listeCompetences key=id item=competence name=boucle}
        <tr>
            <td><input class="idCompetence" type="checkbox" name="comp_{$smarty.foreach.boucle.index}" value="{$id}"></td>
            <td>{$competence}</td>
        </tr>
        {/foreach}

    </tbody>
</table>
