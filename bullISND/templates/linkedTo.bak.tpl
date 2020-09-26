<select class="form-control" name="linkedTo" id="linkedTo">
    <option value="">Cours lié à</option>
    {foreach from=$linked key=wtf item=coursGrp}
        <option value="{$coursGrp}">{$coursGrp}</option>
    {/foreach}
</select>
