<label for="classe">Groupe</label>
<select class="form-control" name="groupe" id="groupe" required>
    <option value="">Choisir le groupe</option>
    {foreach from=$listeGroupes key=nomGroupe item=data}
    <option value="{$nomGroupe}">{$data.intitule}</option>
    {/foreach}
</select>
