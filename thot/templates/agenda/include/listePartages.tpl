{foreach from=$listePartages key=type item=liste4type}
  {foreach from=$liste4type key=destinataire item=data}
  <li class="{$type}"
      title="{$destinataire}" style="overflow:hidden; white-space:nowrap; text-overflow:ellipsis; display:block">
      <button type="button"
          class="btn btn-danger btn-xs btn-delShare"
          title="Supprimer ce partage"
          data-type="{$type}"
          data-destinataire="{$destinataire}"
          data-idagenda="{$idAgenda}">
          x
      </button>
      {if $type == 'profs'}
          {if $destinataire == 'tous'}
              <i class="fa fa-graduation-cap"></i> <span>Tous les profs</span>
              {else}
              <i class="fa fa-graduation-cap"></i> <span>{$data.prenomProf} {$data.nomProf}</span>
          {/if}
      {elseif $type == 'classe'}
          <i class="fa fa-users"></i> <span>Classe de {$destinataire}</span>
      {elseif $type == 'eleve'}
          <i class="fa fa-user"></i> <span>{$data.groupe} {$data.prenomEleve} {$data.nomEleve}</span>
      {elseif $type == 'coursGrp'}
          <i class="fa fa-user-times"></i> <span>{$data.libelle} ({$data.destinataire})</span>
      {elseif $type == 'cours'}
          <i class="fa fa-user-times"></i> <span>{$data.libelle} ({$data.destinataire})</span>
      {elseif $type == 'niveau'}
          <i class="fa fa-arrow-circle-right"></i> <span>{$data.destinataire}e année</span>
      {elseif $type == 'ecole'}
          <i class="fa fa-university"></i> <span>Tous les élèves</span>
      {* {elseif $type == 'groupe'}
          <i class="fa fa-male"></i> *}
      {/if}
  </li>
  {/foreach}
{/foreach}
