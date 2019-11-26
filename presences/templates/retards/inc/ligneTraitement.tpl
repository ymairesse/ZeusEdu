{assign var=nonTraite value=$dataRetards.nonTraite|@count|default:0}
<td>
  {if $nonTraite > 0}
  <button
      type="button"
      class="btn btn-info btn-xs btn-traitement"
      {if $nonTraite == 0} disabled{/if}
      data-matricule="{$matricule}"
      data-debut="{$form.debut}"
      data-fin="{$form.fin}">
      <span class="badge badge-danger nonTraite" style="color: white  ;">
          {$nonTraite}
      </span>&nbsp; <i class="fa fa-pencil"></i>
  </button>
  {else}
      &nbsp;
  {/if}
</td>

<td>{$dataRetards.classe}</td>

<td title="{$matricule}">{$dataRetards.nom}</td>

<td>
    {foreach from=$dataRetards.traite key=idTraitement item=data}
        <button
          type="button"
          data-matricule="{$matricule}"
          data-idtraitement="{$idTraitement}"
          class="btn btn-danger btn-xs btn-edit">
              <i class="fa fa-pencil"></i>
          </button>
      {/foreach}
</td>

<td>
    {foreach from=$dataRetards.traite key=idTraitement item=data}
    <button
      type="button"
      data-matricule="{$matricule}"
      data-idtraitement="{$idTraitement}"
      class="btn btn-warning btn-xs btn-retour"
      style="color: black">
          {if $data.dateRetour == Null}
              <i class="fa fa-pencil"></i>
          {else}
              <span class="discret">{$data.dateRetour|truncate:5:''}</span>
          {/if}
      </button>
    {/foreach}

</td>

<td>
    {foreach from=$dataRetards.traite key=idTraitement item=data}
        <button
          type="button"
          data-matricule="{$matricule}"
          data-idtraitement="{$idTraitement}"
          class="btn btn-default btn-xs btn-printer"
          title="Document imprimé {$data.impression} fois">
              <i class="fa fa-print"></i> <span class="discret">{$data.impression}</span>
          </button>
          <input type="hidden" name="toPrint[]" class="toPrint" value="" style="padding">
      {/foreach}
</td>
