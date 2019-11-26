<div id="modalPrintRetards" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalPrintRetardsLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalPrintRetardsLabel">Impressions</h4>
      </div>
      <div class="modal-body">
          {foreach from=$listeImpression key=n item=print}
            <div class="form-group">
                

            </div>

          {/foreach}
          <pre>
        {$listeImpression|print_r}
    </pre>
      </div>
      <div class="modal-footer">
        ...
      </div>
    </div>
  </div>
</div>
