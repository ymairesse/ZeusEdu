<select class="form-control" name="selectNiveau" id="selectNiveau">
    <option value="">Niveau d'étude</option>
    {foreach from=$listeNiveaux key=wtf item=niveau}
        <option value="{$niveau}">{$niveau}e année</option>
    {/foreach}
</select>
