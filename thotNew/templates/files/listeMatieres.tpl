<div style="height:25em; overflow: auto">

    <ul class="listeMembres list-unstyled">
    {foreach from=$listeMatieres key=matiere item=data}
        <li class="checkbox">
            <label title="{$data.libelle}"><input type="radio" class="cb" name="membres" value="{$matiere}">
                [{$matiere}] {$data.libelle|truncate:30:'...'} {$data.nbHeures} {$data.statut}
            </label>
        </li>
    {/foreach}
    </ul>

</div>

<input type="text" name="TOUS" value="tous">
