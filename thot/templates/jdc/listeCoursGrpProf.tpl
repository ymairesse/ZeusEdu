<div style="height: 35em; overflow:auto">

    <label>Choisir un cours</label>

    <div class="btn-group-vertical  btn-block">

    {foreach from=$listeCoursGrp key=coursGrp item=data}

        <button type="button"
            class="btn {if $data.virtuel == 1}btn-info{else}btn-default{/if} btn-selectCours"
            data-coursgrp="{$coursGrp}">
            {if isset($data.nomCours) && ($data.nomCours != '')}
                {$data.nomCours} [{$coursGrp}]
            {else}
                [{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h
            {/if}
        </button>

    {/foreach}

    </div>

</div>
