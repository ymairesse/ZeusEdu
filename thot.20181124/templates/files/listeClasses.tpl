<div class="row">

    <div class="col-sm-3" style="height:20em; overflow:auto">

        <ul class="listeClasses list-unstyled">
        {foreach from=$listeClasses item=classe}
            <li>
                <label class="radio-inline">
                    <input class="classe" type="radio" name="classe" value="{$classe}">{$classe}
                </label>
            </li>
        {/foreach}
        </ul>

    </div>

    <div class="col-sm-9" id="listeEleves" style="height:20em; overflow:auto">

    </div>

    {* <div class="col-sm-4">
        <div class="alert alert-info">
            <i class="fa fa-info-circle fa-2x" style="float:left; padding:0 5px 5px"></i>
            <p>Sélectionnez d'abord une classe. La liste des élèves apparaît à droite.</p>
            <p>Pour sélectionner ou désélectionner tous les élèves, cochez la case "TOUS".</p>
            <p>Vous pouvez aussi sélectionner les membres de la liste un à un.</p>
        </div>
    </div> *}

</div>

<input type="hidden" name="groupe" value="classe">
