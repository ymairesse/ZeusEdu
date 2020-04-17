<div id="modalDate" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDateLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalDateLabel">Sélection par date</h4>
      </div>
      <div class="modal-body">
          <div class="row">
              <div class="col-md-6 col-xs-12">
                  <div class="input-group">
                      <input type="text" name="dateForum" id="dateForum" value="{$today}" class="datepicker form-control">
                      <span class="input-group-addon" id="addOnDel"><i class="fa fa-times"></i></span>
                  </div>
              </div>
              <div class="col-md-6 col-xs-12">
                  <p>Choisissez ici les contributions à mettre en évidence par date de publication</p>
              </div>
          </div>
      </div>
      <div class="modal-footer">
        <div class="btn-group">
            <button type="button" class="btn btn-primary" id="btn-confirmDate">OK</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('.datepicker').datepicker({
            format: 'dd/mm/yyyy',
            clearBtn: true,
            language: 'fr',
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
        });

        $('#addOnDel').click(function(){
            $('.datepicker').val('').datepicker('update');
            Cookies.set('dateForum','')
        })

    })

</script>
