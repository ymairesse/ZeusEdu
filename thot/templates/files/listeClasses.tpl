<div class="row">

    <div class="col-xs-3" style="height:20em; overflow:auto">

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

    <div class="col-xs-6" id="listeEleves">

    </div>

    <div class="col-xs-3">
        <div class="alert alert-info">
            <i class="fa fa-info-circle fa-2x" style="float:left; padding:0 5px 5px"></i>
            <p>Sélection d'une classe puis des élèves</p>
        </div>
    </div>

</div>
