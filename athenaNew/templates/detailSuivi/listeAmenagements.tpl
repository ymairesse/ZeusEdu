<fieldset class="form-group">
  <label for="amenagements">Aménagements</label>
  <ul class="list-unstyled" style="max-height: 15em; overflow: auto;">

      {foreach from=$listeAmenagements key=id item=unAmenagement}
      <div class="checkbox">
          <li>
              <label><input name="amenagement[]" type="checkbox" value="{$id}" {if in_array($id, $infoEBS['amenagements'])}checked{/if}>{$unAmenagement}</label>
          </li>
      </div>
      {/foreach}

  </ul>
</fieldset>

<div class = "input-group">
    <input type = "text" class="form-control" name="plusAmenagement" id="plusAmenagement">
    <span class = "input-group-btn">
        <button class="btn btn-success" type="button" id="btn-addAmenagement" data-matricule="{$matricule}"><i class="fa fa-plus"></i></button>
    </span>
    <br>
</div><!-- /input-group -->
<div class="help-block">Ajouter un aménagement à la liste</div>
