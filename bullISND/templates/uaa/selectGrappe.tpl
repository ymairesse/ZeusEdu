<form id="formSelectGrappe">
    <div class="form-group">
        <select class="form-control" name="listeGrappes[]" id="listeGrappes" size="20">
            {foreach from=$listeGrappes key=unIdGrappe item=data}
            <option value="{$unIdGrappe}"
                {if isset($idGrappe) && ($idGrappe == $unIdGrappe)}selected{/if}>
                {$data.grappe} [{$data.nbCours} cours liés]
            </option>
            {/foreach}
        </select>
    </div>
</form>
