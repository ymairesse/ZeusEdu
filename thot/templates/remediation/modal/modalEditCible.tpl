<div id="modalEditCible" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditCibleLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalEditCibleLabel">Ajout de groupes</h4>
            </div>
            <div class="modal-body" id="detailsCible">


            </div>
            <div class="modal-footer">
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="btn-saveGroup">Sélectionner</button>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        function reset(){
            $('#matiere').val('');
            $('#coursGrp').val('');
            $('#classeEleve').val('');
            $('#matiere').html('<option value="">Matière</option>');
            $('#coursGrp').html('<option value="">Cours</option>');
            $('#classeEleve').html('<option value="">Classe</option>');
        }

        $('#modalEditCible').on('click', '#btn-saveGroup', function(){
            if ($('#formCible').valid()) {
                var formulaire = $('#formCible').serialize();
                $.post('inc/remediation/saveCible.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    $('#modalEditCible').modal('hide');
                    var resultat = JSON.parse(resultat);
                    var idOffre = resultat.idOffre;
                    if (parseInt(resultat.nombre) > 0) {
                        bootbox.alert('Le groupe <strong>'+ resultat.groupe + '</strong> a été ajouté pour cette remédiation');
                        $.post('inc/remediation/panelGroupes.inc.php', {
                            idOffre: idOffre
                        }, function(resultat){
                            $('#panelGroupes').html(resultat);
                        })
                        }
                        else bootbox.alert('Le groupe <strong>' + resultat.groupe +'</strong> n\'a pas été ajouté...');
                })

            }
        })

        $('#detailsCible').on('change', '#type', function() {
            var type = $(this).val();
            switch (type) {
                case 'ecole':
                    $('.selecteurRem').addClass('hidden');
                    reset();
                    $('#selectEcole').removeClass('hidden');
                    break;
                case 'niveau':
                    $('.selecteurRem').addClass('hidden');
                    $.post('inc/remediation/selectNiveau.inc.php', {},
                        function(resultat) {
                            $('#selectNiveauGroupe').html(resultat);
                            $('#selectNiveauGroupe').closest('.selecteurRem').removeClass('hidden');
                        })
                    break;
                case 'classe':
                    $('.selecteurRem').addClass('hidden');
                    reset();
                    $.post('inc/remediation/selectNiveauClasse.inc.php', {},
                        function(resultat) {
                            $('#niveauClasse').html(resultat);
                            $('#niveauClasse').closest('.selecteurRem').removeClass('hidden');
                        });
                    break;
                case 'matiere':
                    $('.selecteurRem').addClass('hidden');
                    reset();
                    $.post('inc/remediation/selectNiveauMatiere.inc.php', {},
                        function(resultat) {
                            $('#niveauMatiere').html(resultat);
                        })
                    $('#niveauMatiere').closest('.selecteurRem').removeClass('hidden');
                    break;
                case 'coursGrp':
                    $('.selecteurRem').addClass('hidden');
                    reset();
                    $.post('inc/remediation/selectCoursProf.inc.php', {},
                        function(resultat) {
                            $('#coursGrp').html(resultat);
                        })
                    $('#coursGrp').closest('.selecteurRem').removeClass('hidden');
                    break;
            }
        })

        $('#detailsCible').on('change', '#niveauMatiere', function() {
            var niveau = $(this).val();
            if (niveau != '') {
                $.post('inc/remediation/selectMatiere.inc.php', {
                    niveau: niveau
                }, function(resultat) {
                    $('#matiere').html(resultat);
                })
            }
        })

        $('#detailsCible').on('change', '#niveauClasse', function() {
            var niveau = $(this).val();
            if (niveau != '') {
                $.post('inc/remediation/selectClasse.inc.php', {
                    niveau: niveau
                }, function(resultat) {
                    $('#classe').html(resultat);
                })
            }
        })

    })

</script>
