<div class="row">

    <div class="col-sm-6">
        <ul class="listeMembres list-unstyled">
        {foreach from=$listeGroupes key=groupe item=unGroupe}
            <li>
                <label class="radio-inline">
                <input type="radio" class="groupe" name="groupe" value="{$groupe}">
                <strong>{$unGroupe.nomGroupe}</strong>: {$unGroupe.intitule|truncate:25:'...'}</label>
            </li>
        {/foreach}
        </ul>
    </div>

    <div class="col-sm-6" id="listeEleves" style="height:20em; overflow:auto">

    </div>

</div>
