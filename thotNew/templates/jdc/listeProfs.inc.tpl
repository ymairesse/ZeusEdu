<div class="checkbox">
    <label>
        <input type="checkbox" id="cbProfs" style="float: left; margin-right:0.5em">
        TOUS
    </label>
</div>

<ul class="list-unstyled">
{foreach from=$listeProfs key=unAcronyme item=prof}
    <li>
        <div class="checkbox">
            <label>
                <input class="selecteurProf" type="checkbox" name="profs[]" value="{$unAcronyme}">
                <span style="padding-left:0.5em">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
            </label>
        </div>
    </li>
{/foreach}
</ul>
