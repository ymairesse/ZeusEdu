<div class="row">

    <div class="col-sm-7" style="height:20em; overflow:auto">

        <input type="checkbox" id="checkListe" name="TOUS" value="tous" checked>
        <strong class="clickable teteListe" title="Cliquer pour ouvrir"> TOUS </strong>


        <ul class="listeMembres list-unstyled" style="display:none">
        {foreach from=$listeProfs key=acro item=prof}
            <li>
                <label class="radio-inline">
                <input type="checkbox" class="cb" name="membres[]" value="{$acro}" checked>
                {$prof.nom|truncate:15:'...'} {$prof.prenom}</label>
            </li>
        {/foreach}
        </ul>
    </div>

    <div class="col-sm-5">
        <div class="alert alert-info">
            <i class="fa fa-info-circle fa-2x" style="float:left; padding:0 5px 5px"></i>
            <p>Pour Cliquer pour voir le détail de la liste, cliquez sur TOUS.</p>
            <p>Pour sélectionner ou désélectionner tous les membres de la liste, cochez la case "TOUS".</p>
            <p>Vous pouvez aussi sélectionner les membres de la liste un à un.</p>
        </div>
    </div>

</div>

<input type="hidden" name="groupe" value="profs">
