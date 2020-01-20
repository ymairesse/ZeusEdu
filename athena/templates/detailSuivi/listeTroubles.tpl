<fieldset class="form-group">
  <label for="trouble">Troubles</label>
  <ul class="list-unstyled" style="max-height: 15em; overflow: auto;">

      {foreach from=$listeTroubles key=id item=unTrouble}
      <div class="checkbox">
          <li>
              <label><input name="trouble[]" type="checkbox" value="{$id}" {if in_array($id, $infoEBS['troubles'])}checked{/if}>{$unTrouble}</label>
          </li>
      </div>
      {/foreach}

  </ul>
</fieldset>

<div class = "input-group">
    <input type = "text" class="form-control" name="plusTrouble" id="plusTrouble">
    <span class = "input-group-btn">
        <button class="btn btn-success" type="button" data-matricule="{$matricule}" id="btn-addTrouble"><i class="fa fa-plus"></i></button>
    </span>
    <br>
</div><!-- /input-group -->
<div class="help-block">Ajouter un trouble à la liste</div>
