<div class="row">

    <div class="col-sm-3" style="height:20em; overflow:auto">

        <ul class="listeClasses list-unstyled">
        {foreach from=$listeClasses item=classe}
            <li>
                <label class="radio-inline">
                    <input type="radio" class="classe" name="classe" value="{$classe}">{$classe}
                </label>
            </li>
        {/foreach}
        </ul>

    </div>

    <div class="col-sm-9" id="listeEleves" style="height:20em; overflow:auto">

    </div>

</div>
