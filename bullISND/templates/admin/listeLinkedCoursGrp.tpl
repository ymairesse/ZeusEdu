<div class="form-group">
    <label for="linkedCoursGrp">Ce cours est lié au(x) cours réel(s)</label>
    <select class="form-control" name="linkedCoursGrp[]" id="linkedCoursGrp" multiple required>
        <option value="">Cours virtuel lié à</option>
        {foreach from=$listeCoursGrp key=coursGrp item=data}
            // ne pas prendre les cours virtuels
            {if $data.virtuel == 0}
            <option
                value="{$coursGrp}"
                {if isset($linkedTo) && ($linkedTo == $coursGrp)} selected{/if}>
                {$coursGrp} - {$data.acronyme}
            </option>
            {/if}
        {/foreach}
    </select>
    <div class="help-block">
        Maintenir Ctrl enfoncé pour sélectionner
    </div>
</div>
