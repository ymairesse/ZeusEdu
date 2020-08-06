<div class="row">

    <div class="col-sm-7">
        <ul class="listeMembres list-unstyled">
        {foreach from=$listeNiveaux key=wtf item=unNiveau}
            <li>
                <label class="radio-inline">
                <input type="checkbox" class="cb" name="membres[]" value="{$unNiveau}">
                Élèves de {$unNiveau}e</label>
            </li>
        {/foreach}
        </ul>
    </div>

    <div class="col-sm-5">
        <div class="alert alert-info">
            <i class="fa fa-info-circle fa-2x" style="float:left; padding:0 5px 5px"></i>
            <p>Vous pouvez sélectionner les niveaux d'études un à un.</p>
        </div>
    </div>

</div>
