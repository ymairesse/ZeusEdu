<div id="modalNewAgenda" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalNewAgendaLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalNewAgendaLabel">{if $idAgenda == ''}Nouvel{else}Modification d'un{/if} agenda</h4>
      </div>
      <div class="modal-body">

        <form id="modalNewForm">
            <div class="form-group">
                <label for="nom">Nom de cet agenda</label>
                <input class="form-control" type="text" name="nom" id="nomAgenda" value="{$nomAgenda}" required>
            </div>
            <input type="hidden" name="idAgenda" id="idAgenda" value="{$idAgenda}">
            <button type="button" class="btn btn-primary pull-right" id="btn-saveNewName" name="button">Enregistrer</button>
            <div class="clearfix"></div>
        </form>

      </div>

    </div>
  </div>
</div>
