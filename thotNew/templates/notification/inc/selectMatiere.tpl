<select class="form-control" name="matiere" id="matiere" required>
    <option value="">Choisir la matière</option>
    {foreach from=$listeMatieres key=matiere item=data}
    <option value="{$matiere}">{$data.cours} {$data.libelle}</option>
    {/foreach}
</select>
