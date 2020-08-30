<table class="table table-condensed" id="tableCompetences">
    <thead>
        <tr>
            <th>Compétence(s) à ajouter</th>
        </tr>
    </thead>
    <tbody>

        {foreach from=$listeCompetences key=id item=competence name=boucle}
        <tr>
            <td>
                <div class="checkbox">
                    <label>
                        <input class="idCompetence" type="checkbox" name="comp_{$smarty.foreach.boucle.index}" value="{$id}">
                        {$competence}
                    </label>
                </div>
            </td>
        </tr>
        {/foreach}

    </tbody>
</table>
