<div id="modalShowEleve" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalShowEleveLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalShowEleveLabel">Résumé</h4>
      </div>
      <div class="modal-body">

        {include file="eleve.tpl"}

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal" name="button">Fermer <i class="fa fa-times"></i> </button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        var onglet = Cookies.get('onglet');
        if (onglet != undefined){
            $('ul#tabs a[href="' + onglet +'"]').trigger('click');
            }

        $('#modalShowEleve').on('click', 'ul#tabs a', function(){
    		var onglet = $(this).attr('href');
    		Cookies.set('onglet', onglet);
    	})

    })

</script>
