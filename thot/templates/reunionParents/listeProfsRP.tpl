{if $listeProfs|count > 0}

    <div class="form-group">
      <label for="selectProfs">Professeurs concernés</label>
      <select class="form-control" name="listeProfs[]" id="selectProfs" multiple size="25">
          {foreach from=$listeProfs key=acronyme item=unProf}
          <option value="{$acronyme}">{$unProf.nom} {$unProf.prenom}</option>
          {/foreach}
      </select>
    </div>

    <button type="button" class="btn btn-primary btn-block" id="btnSelectProfs">Sélectionner tous</button>
{/if}
