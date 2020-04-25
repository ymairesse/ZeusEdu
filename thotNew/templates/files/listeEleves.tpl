<div class="checkbox">
    <label>
        <input type="checkbox" id="checkListe" name="TOUS" value="tous" checked>
        <strong class="clickable teteListe" title="Cliquer pour ouvrir"> TOUS -> {$listeEleves|@count} élève(s)</strong>
    </label>
</div>


<ul class="listeMembres list-unstyled">
{foreach from=$listeEleves key=matricule item=unEleve}
    <li class="checkbox">
            <label><input type="checkbox" class="cb" name="membres[]" value="{$matricule}" checked>
                {$unEleve.classe|default:''} {$unEleve.nom|truncate:15:'...'} {$unEleve.prenom}
            </label>
    </li>
{/foreach}
</ul>
