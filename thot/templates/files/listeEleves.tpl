<div class="btn-group btn-group-justified">
    <a href="#" class="btn btn-primary btn-xs" id="btn-tous">Tous</a>
    <a href="#" class="btn btn-success btn-xs" id="btn-invert">Inverser</a>
    <a href="#" class="btn btn-danger btn-xs" id="btn-none">Aucun</a>
</div>

<div style="height:20em; overflow:auto;">

    <ul class="listeMembres list-unstyled">
    {foreach from=$listeEleves key=matricule item=unEleve}
        <li class="checkbox">
              <label>
                  <input type="checkbox" class="cb" name="membres[]" value="{$matricule}" checked>
                  {$unEleve.classe|default:''} {$unEleve.nom|truncate:15:'...'} {$unEleve.prenom}
              </label>
        </li>
    {/foreach}
    </ul>

</div>
