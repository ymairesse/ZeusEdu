<div class="row">

    <div class="col-sm-6" style="height:20em; overflow:auto">

    <ul class="listeCours list-unstyled">
        {foreach from=$listeCours key=coursGrp item=unCours}
          <li>
              <label class="radio-inline">
                  <input class="coursGrp" type="radio" name="coursGrp" value="{$coursGrp}">
                  {$coursGrp}: {if ($unCours.nomCours != '')}{$unCours.nomCours}{else}{$unCours.libelle}{/if}
              </label>
          </li>
        {/foreach}
    </ul>

    </div> <!-- col-sm-12 -->

  <div class="col-sm-6" id="listeEleves"  style="height:20em; overflow:auto">

  </div>

</div>  <!-- row -->
