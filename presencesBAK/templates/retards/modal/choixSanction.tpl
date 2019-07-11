<div id="modalChoixSanction" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalChoixSanctionLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalChoixSanctionLabel">Choix des jours de sanction</h4>
      </div>
      <div class="modal-body">
          <form id="formDates">
          <div class="row">
          <div class="col-xs-6">
              <div class="input-group">
                  <input type="text" value="{$date}" id="date" class="datepicker form-control">
                  <span class = "input-group-btn">
                   <button type="button" name="button" class="btn btn-primary btn-block" id="btnAddDate"><i class="fa fa-arrow-right"></i></button>
                </span>
              </div>
          </div>

          <div class="col-xs-6">
              <ol id="ulDates">

              </ol>
          </div>
          </div>

          <div class="row">
              <div class="col-xs-6">
                  <button type="button" id="btn-reset" class="btn btn-default btn-block">Annuler tout</button>
              </div>
              <div class="col-xs-6">
                  <button type="button" id="btn-save" class="btn btn-primary btn-block pull-right" disabled>Confirmer <i class="fa fa-save"></i></button>
              </div>
          </div>
          {foreach from=$listeIds key=wtf item=id}
            <input type="hidden" name="id[]" value="{$id}">
          {/foreach}
          <input type="hidden" name="matricule" value="{$matricule}">
        </form>
          {if $imageEDT != ''}
            <img src="../edt/eleves/{$imageEDT}" alt="{$imageEDT}" class="img img-responsive">
            {else}
            <p>Horaire non disponible</p>
            {/if}
      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $("#date").datepicker({
            format: "DD dd/mm/yyyy",
            daysOfWeekDisabled: [0,6],
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
            });

        $('#btnAddDate').click(function(){
            var date = $('#date').val();
            if (date != '') {
                var date2 = date.split(' ')[1];
                $('#ulDates').append('<li>' + date + '<input type="hidden" name="dateF[]" value="' + date2 + '"></li>');
                $('#btn-save').prop('disabled', false);
            }
        })

    })

</script>
