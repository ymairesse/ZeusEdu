<div id="modalSelectEduc" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalSelectEducLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalSelectEducLabel">Charges des éducateurs</h4>
      </div>
      <form id="formEduc">
      <div class="modal-body" style="max-height: 25em; overflow:auto;">
          <table class="table table-condensed">
              <tr>
                  <th style="width:5em;">Période</th>
                  <th style="width:5em;">Heure</th>
                  <th style="width:5em;">Éducateur</th>
                  <th>Nom</th>
              </tr>
                  {foreach from=$listePeriodes key=periode item=data}
                  <tr {if $periode == $laPeriode} class="ok"{/if}>
                      <td><strong>{$periode}</strong> / {$listePeriodes|@count}</td>
                      <td>{$data.debut}</td>
                      <td>
                          <input type="text"
                            class="form-control input-sm educs"
                            name="educ[{$periode}]"
                            style="text-transform:uppercase"
                            value="{$listeEducs.$periode.acronyme}"
                            data-periode="{$periode}">
                      </td>
                      <td class="nomProf" data-periode="{$periode}">{$listeEducs.$periode.prenom} {$listeEducs.$periode.nom}</td>
                  </tr>
                  {/foreach}
              </tr>
          </table>

      </div>
      <div class="modal-footer">
          <div class="col-xs-1">
              Du
          </div>
          <div class="col-xs-4">
              <input type="text" class="form-control datepicker" id="start" name="start" value="{$date}">
          </div>
          <div class="col-xs-1">
              Au
          </div>
          <div class="col-xs-4">
              <input type="text" class="form-control datepicker" id="end" name="end" value="{$date}">
          </div>
          <div class="col-xs-2">
              <button type="button" class="btn btn-primary btn-block" id="btn-saveEducs" name="button">OK</button>
          </div>
    </div>
    </form>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#start').datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: '06',
        });

        $('#end').datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: '06',
        });

    })

</script>
