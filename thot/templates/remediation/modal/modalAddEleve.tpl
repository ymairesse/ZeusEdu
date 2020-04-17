<div id="modalInvitationEleve" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalInvitationEleveLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalInvitationEleveLabel">Inviter des élèves</h4>
      </div>
      <div class="modal-body" id="modalFormEleve">

        {include file="remediation/modal/formSelectEleve.tpl"}

      </div>
      <div class="modal-footer">
          <div class="btn-group btn-group-justified">
            <div class="btn-group">
            <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
            </div>
            <div class="btn-group">
            <button type="button" class="btn btn-primary" id="btnSelectEleve" disabled>Sélectionner >></button>
            </div>
          </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#modalFormEleve').on('change', '#critereEleve', function(){
            var critere = $(this).val();

            switch (critere) {
                case 'classe':
                    $.post('inc/remediation/selectNiveau.inc.php', {},
                    function(resultat){
                        $('#selectNiveauEleve').html(resultat);
                        $('#selectByCours').addClass('hidden');
                        $('#coursGrp').html('');
                        $('#selectByNiveauClasse').removeClass('hidden');
                    })

                    break;
                case 'cours':
                    $.post('inc/remediation/selectCoursProf.inc.php', {},
                        function(resultat){
                            $('#coursGrp').html(resultat);
                            $('#classe').html('<option value="">Choisir la classe</option>');
                            $('#selectByNiveauClasse').addClass('hidden');
                            $('#selectByCours').removeClass('hidden');
                        })
                    break;
            }
        })

        $('#modalFormEleve').on('change', '#selectNiveauEleve', function(){
            var niveau = $(this).val();
            if (niveau != '') {
                $.post('inc/remediation/selectClasse.inc.php', {
                    niveau: niveau
                }, function(resultat){
                    $('#classeEleve').html(resultat);
                })
            }
            else {
                $('#listeEleves').html(resultat);
                $('#blocSelectEleves').addClass('hidden');
                $('#btnSelectEleve').prop('disabled', true);
            }
        })

        $('#modalFormEleve').on('change', '#classeEleve', function(){
            var classe = $(this).val();
            if (classe != '') {
                $.post('inc/remediation/listeElevesClasse.inc.php', {
                    classe: classe
                }, function(resultat){
                    $('#listeEleves').html(resultat);
                    $('#blocSelectEleves').removeClass('hidden');
                    $('#btnSelectEleve').prop('disabled', false);
                }) }
                else {
                    $('#listeEleves').html('');
                    $('#blocSelectEleves').addClass('hidden');
                    $('#btnSelectEleve').prop('disabled', true);
                }
        })

        $('#modalFormEleve').on('change', '#coursGrp', function(){
            var coursGrp = $(this).val();
            if (coursGrp != '') {
            $.post('inc/remediation/listeElevesCoursGrp.inc.php', {
                coursGrp: coursGrp
            }, function(resultat){
                $('#listeEleves').html(resultat);
                $('#blocSelectEleves').removeClass('hidden');
                $('#btnSelectEleve').prop('disabled', false);
            }) }
            else {
                $('#listeEleves').html('');
                $('#blocSelectEleves').addClass('hidden');
                $('#btnSelectEleve').prop('disabled', true);
            }
        })

        $('#modalInvitationEleve').on('click', '#btnSelectEleve', function(){
            var formulaire = $('#formSelectEleve').serialize();
            var idOffre = $('this').data('idoffre');
            $.post('inc/remediation/inviteEleves.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#panelEleves').html(resultat);
            })
        })

    })

</script>
