<div class="form-group col-md-2 col-sm-4 col-xs-6">
    <div class="input-group">
        <select class="form-control input-sm" name="groupe[]">
            <option value="">Choix</option>
            {foreach from=$listeClasses item=classe}
            <option value="{$classe}"{if isset($unGroupe) && ($unGroupe == $classe)} selected{/if}>{$classe}</option>
            {/foreach}
        </select>
        {* <input class="form-control input-sm" type="text" name="groupe[]" value="{$unGroupe|default:''}"> *}
        <span class ="input-group-btn">
            <button class="btn btn-danger btn-sm delGroupe" type="button"><i class="fa fa-times"></i></button>
        </span>
    </div>
</div>
