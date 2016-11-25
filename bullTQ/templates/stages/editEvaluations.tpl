<form>

    {foreach from=$evaluations key=champ item=value}

    <div class="form-group">
        <label for="{$champ}">{$legendes.$champ}</label>
        <div class="input-group">
            <input type="text" class="form-control" id="{$champ}" value="{$value}" {if !$activations[$champ]}disabled{/if}>
            <span class="input-group-addon"><i class="fa {if !$activations.$champ}fa-ban{else}fa-check{/if}"></i>

            </span>
        </div>

    </div>

    {/foreach}

    <div class="btn-group btn-group-sm pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="button" class="btn btn-primary" id="submitStages">Enregistrer</button>
    </div>

</form>
