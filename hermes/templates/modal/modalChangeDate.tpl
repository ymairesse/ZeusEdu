<div id="modalChangeDate" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalChangeDateLabel" aria-hidden="true">

    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalChangeDateLabel">Modification de la date de fin</h4>
            </div>
            <div class="modal-body row">

                <div class="col-xs-3">

                    <div class="form-group">
                        <label for="date">Date d'envoi</label>
                        <p class="form-control-static">{$message.date}</p>
                    </div>
                </div>

                <div class="col-xs-4">
                    <div class="form-group">
                        <label for="Objet">Objet</label>
                        <p class="form-control-static">{$message.objet}</p>
                    </div>
                </div>

                <div class="col-xs-5">
                    <div class="form-group">
                        <label for="destinataires">Destinataires</label>
                        <p class="form-control-static">{$message.acroDest}</p>
                    </div>
                </div>

                <div class="form-group col-xs-8">
                    <label for="texte">Texte</label>
                    <p class="form-control-static">{$message.texte|truncate:50:'...'}</p>
                </div>

                <div class="form-group col-xs-4">
                    <label for="dateFin">Date de fin</label>
                    <input type="text" class="datepicker form-control" name="dateFin" id="dateFin" value="{$message.dateFin}">
                    <input type="hidden" name="id" id="id" value="{$message.id}">
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="saveNewDate">Enregistrer</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function() {

        $('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });
    })

</script>
