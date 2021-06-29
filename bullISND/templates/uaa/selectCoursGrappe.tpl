<div class="form-group">
    <label for="laGrappe">Grappe de cours</label>
    <select class="form-control" name="coursGrappe" size="10" id="coursGrappe">
      {if $detailsGrappe.cours[0].cours != Null}
        {foreach from=$detailsGrappe.cours key=wtf item=data}
          <option value="{$data.cours}" title="{$data.libelle}">[{$data.cours}] {$data.statut} {$data.libelle} {$data.nbheures}h</option>
        {/foreach}
      {/if}
    </select>
</div>