<input type="checkbox" id="checkListe" name="TOUS" value="tous" checked>
<strong class="clickable teteListe" title="Cliquer pour ouvrir"> TOUS </strong>

<ul class="listeMembres list-unstyled" style="display:none">
{foreach from=$listeEleves key=matricule item=unEleve}
    <li>
        <label class="checkbox-inline">
        <input type="checkbox" class="cb" name="membres[]" value="{$matricule}" checked>
        {$unEleve.classe|default:''} {$unEleve.nom|truncate:15:'...'} {$unEleve.prenom}
        </label>
    </li>
{/foreach}
</ul>
