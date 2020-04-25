<div class="checkbox">
    <label>
        <input type="checkbox" id="cbEleves" style="float: left; margin-right:0.5em">
        TOUS
    </label>
</div>

<ul class="list-unstyled">
{foreach from=$listeEleves key=matricule item=eleve}
    <li>
        <div class="checkbox">
            <label>
                <input class="selecteurEleve" type="checkbox" name="eleves[]" value="{$matricule}">
                <span style="padding-left:0.5em">{$eleve.nom|truncate:15:'...'} {$eleve.prenom}</span>
            </label>
        </div>
    </li>
{/foreach}
</ul>
