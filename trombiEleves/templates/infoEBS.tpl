{assign var=eleveEBS value=$eleveEBS.$matricule|default:Null}
<div class="row">

    <div class="col-sm-12 col-md-6" id="listeTroubles">

        <fieldset class="form-group">
          <label for="trouble">Troubles</label>
          <ul class="list-unstyled" style="max-height: 15em; overflow: auto;">
              {foreach from=$eleveEBS.troubles key=id item=unTrouble}
                  <li>{$unTrouble}</li>
              {/foreach}
          </ul>
        </fieldset>

    </div>

    <div class="col-sm-12 col-md-6" id="listeAmenagements">

        <fieldset class="form-group">
          <label for="amenagements">Aménagements</label>
          <ul class="list-unstyled" style="max-height: 15em; overflow: auto;">
              {foreach from=$eleveEBS.amenagements key=id item=unAmenagement}
                  <li>{$unAmenagement}</li>
              {/foreach}
          </ul>
        </fieldset>
    </div>

</div>

<div class="row">
    <div class="col-xs-12">
        <fieldset class="form-group">
          <label for="memo">Mémo</label>
          <div style="height:5em; border: 1px solid #555; padding: 1em;">{$eleveEBS['memo']}</div>
        </fieldset>
    </div>

    </div>
