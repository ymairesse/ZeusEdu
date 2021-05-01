<form id="formListeCours">

    {foreach from=$listeCours key=cours item=data}

        <div class="checkbox"{if in_array($data.coursGrp, $listeMatieres)} class="selection"{/if}>
            <label>
                <input type="checkbox" name="coursGrp[]" value="{$data.coursGrp}" {if in_array($data.coursGrp, $listeMatieres)}checked disabled{/if}>
                {$data.libelle} {$data.nbheures}h [{$data.acronyme}]
            </label>
        </div>

    {/foreach}

    <input type="hidden" name="anScol" value="{$anScol}">
    <input type="hidden" name="periode" value="{$periode}">

</form>
