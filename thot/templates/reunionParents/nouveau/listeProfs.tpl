<table class="table table-condensed">
    <thead>
        <tr>
            <th>Prof</th>
            <th class="text-center">Attribution<br>
            <input type="checkbox" id="attribProfs" title="Attribuer à tous"{if $readonly == 1} disabled{/if}></th>
            <th>Dir<br>
            <input type="checkbox" id="attribDir" title="Attribuer à tous" {if $readonly == 1} disabled{/if}></th></th>
        </tr>
    </thead>
    <tbody>
        {assign var=i value=0}
        {foreach from=$listeProfs key=acronyme item=unProf}
            <tr>
                <td>
                    <span title="{$unProf.acronyme}">{$unProf.nom} {$unProf.prenom}</span>
                </td>
                <td class="text-center"><input type="checkbox" value="{$acronyme}" id="prof_{$acronyme}" name="prof[{$acronyme}]" class="cbProf"{if $readonly == 1} disabled{/if}></td>
                <td class="text-center"><input type="checkbox" value="{$acronyme}" name="dir[{$acronyme}]" class="dir"{if $readonly == 1} disabled{/if}>
                </td>
            </tr>
            {assign var=i value=$i+1}
        {/foreach}

    </tbody>
</table>
