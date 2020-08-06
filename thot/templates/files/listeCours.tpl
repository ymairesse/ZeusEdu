<div class="row">

    <div class="col-xs-5" style="height:20em; overflow:auto">

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

</div> <!-- col-sm-6 -->

  <div class="col-xs-4" id="listeEleves">

  </div>

  <div class="col-xs-3">
      <div class="alert alert-info">
          <i class="fa fa-info-circle fa-2x" style="float:left; padding:0 5px 5px"></i>
          <p>Sélection d'un cours puis des élèves</p>
      </div>
  </div>

</div>  <!-- row -->
