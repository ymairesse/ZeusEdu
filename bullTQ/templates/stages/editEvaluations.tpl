<form>

    {foreach from=$qualification item=epreuve}
        {assign var=sigle value=$epreuve.sigle}
        <div class="form-group">
            <label for="{$sigle}">{$sigle}</label>
            <div class="input-group">
                <input type="text" class="form-control majuscules" id="{$sigle}" value="{$evaluations.$sigle}" {if ($annee != $epreuve.annee)} disabled{/if}>
                <span class="input-group-addon"><i class="fa {if ($annee != $epreuve.annee)}fa-ban{else}fa-check{/if}"></i></span>
            </div>
        </div>

    {/foreach}

    <div class="btn-group btn-group-sm pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="button" class="btn btn-primary" id="submitStages">Enregistrer</button>
    </div>

</form>
