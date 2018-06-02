<div id="modalEditRemediation" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditRemediationLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
                <h4 class="modal-title" id="modalEditRemediationLabel">Édition d'une remédiation</h4>
            </div>
            <div class="modal-body">
                <form id="formEditRemediation">

                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-group">
                    <button type="button" data-dismiss="modal" class="btn btn-default">Annuler</button>
                    <button type="button" class="btn btn-primary" id="btn-saveRemediation">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>
</div>

<style media="screen" type="text/css">
    {* nécessaire pour amener le widget au dessus de la fenêtre modale *}
    .bootstrap-timepicker-widget.dropdown-menu {
        z-index: 1050 !important;
    }
</style>
