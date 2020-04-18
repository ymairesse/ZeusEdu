<div id="modalTreeView" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalTreeViewLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalTreeViewLabel">Sélection des PJ</h4>
      </div>
      <div class="row modal-body">

		  <div class="col-xs-9" id="listeFichiers">
			  <div class="input-group">
				<div class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" id="root"><i class="fa fa-home"></i> </button>
				</div>
				<input type="text" name="arborescence" id="arborescence" value="/" class="form-control input-sm" readonly>
			  </div>

				<div style="max-height:25em; overflow: auto;">
					{include file='jdc/treeview4PJ.tpl'}
				</div>

		  </div>

		  <div class="col-xs-3">
			  <div class="dropzone" id="myDropZone" style="height:25em;">
			  </div>
		  </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
      </div>
    </div>
  </div>
</div>
