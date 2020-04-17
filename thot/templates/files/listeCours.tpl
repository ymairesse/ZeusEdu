<div class="row">

    <div class="col-sm-12" style="height:10em; overflow:auto">

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

  <div class="col-sm-12" id="listeEleves"  style="height:15em; overflow:auto">

  </div>

</div>  <!-- row -->



  {* <div class="col-sm-5">
      <div class="alert alert-info">
          <i class="fa fa-info-circle fa-2x" style="float:left; padding:0 5px 5px"></i>
          <p>Sélectionnez d'abord un cours. La liste des élèves apparaît au dessous.</p>
          <p>Pour sélectionner ou désélectionner tous les élèves, cochez la case "TOUS".</p>
          <p>Vous pouvez aussi sélectionner les membres de la liste un à un.</p>
      </div>
  </div> *}

<input type="hidden" name="groupe" value="cours">
