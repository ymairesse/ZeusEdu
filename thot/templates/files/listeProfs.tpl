<div class="btn-group btn-group-justified">
    <a href="#" class="btn btn-primary btn-xs" id="btn-tous">Tous</a>
    <a href="#" class="btn btn-success btn-xs" id="btn-invert">Inverser</a>
    <a href="#" class="btn btn-danger btn-xs" id="btn-none">Aucun</a>
</div>

<div  style="height:20em; overflow:auto">

    <ul class="listeMembres list-unstyled">
    {foreach from=$listeProfs key=acro item=prof}
    <li class="checkbox">
          <label>
              <input type="checkbox" class="cb" name="membres[]" value="{$acro}" checked>
              {$prof.nom|truncate:15:'...'} {$prof.prenom}
          </label>
    </li>
    {/foreach}
    </ul>

</div>
