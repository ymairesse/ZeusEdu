<table class="table table-condensed">
    <thead>
        <tr>
            <th>Prof</th>
            <th class="text-center">Attribution<br>
            <input type="checkbox" id="attribProfs" title="Attribuer à tous"></th>
            <th style="text-align:center" title="cocher pour les personnes qui ne donnent pas cours">Dir</th>
        </tr>
    </thead>
    <tbody>
        {assign var=i value=0}
        {foreach from=$listeProfs key=acronyme item=unProf}
            <tr>
                <td>
                    <span title="{$unProf.acronyme}">{$unProf.nom} {$unProf.prenom}</span>
                </td>
                <td class="text-center">
                    <input type="checkbox" value="{$acronyme}" id="prof_{$acronyme}" data-acronyme="{$acronyme}" name="prof[{$acronyme}]" class="cbProf">
                </td>
                <td class="text-center">
                    <input type="checkbox" value="{$acronyme}" id="dir_{$acronyme}" data-acronyme="{$acronyme}" name="dir[{$acronyme}]" class="dir">
                </td>
            </tr>
            {assign var=i value=$i+1}
        {/foreach}

    </tbody>
</table>
