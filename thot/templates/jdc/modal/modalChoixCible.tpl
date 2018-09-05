<div id="modalEditCible" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditCibleLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalEditCibleLabel">Clonage du JDC de {$lblDestinataire}</h4>
            </div>
            <div class="modal-body" id="detailsCible">

                <div style="border: 1px solid #aaa; padding: 0 0.5em">
                    <h5>{$travail.title}</h5>
                    {$enonce}
                </div>

                <form id="formCible">

                    <div class="row">

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label for="type">Cible</label>
                                <select class="form-control" name="type" id="type" required>
                                {foreach from=$types key=type item=leType}
                                <option value="{$type}">{$leType}</option>
                                {/foreach}
                              </select>
                            </div>
                        </div>

                        <div class="col-sm-8" id="detailsCible">

                            <div class="form-group selecteurRem hidden" id="selectEcole">
                                <label for="selectEcole">Sélection</label>
                                <p class="form-control-static">Pour les JDC de tous</p>
                            </div>

                            <div class="form-group selecteurRem hidden">
                                <label for="selectNiveauGroupe">Niveau d'étude</label>
                                <select class="form-control" name="niveau" id="selectNiveauGroupe" required>
                                    <option value=""></option>
                                </select>
                            </div>

                            <div class="selecteurRem hidden">
                                <div class="col-sm-7">
                                    <div class="form-group">
                                        <label for="niveauClasse">Niveau d'étude</label>
                                        <select class="form-control" name="niveauClasse" id="niveauClasse" required>
                                            <option value="">Choisir le niveau</option>
                                          </select>
                                    </div>
                                </div>

                                <div class="col-sm-5">
                                    <div class="form-group">
                                        <label for="classe">Classe</label>
                                        <select class="form-control" name="classe" id="classe" required>
                                            <option value="">Classe</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="selecteurRem hidden">
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label for="niveauMatiere">Niveau</label>
                                        <select class="form-control" name="niveauMatiere" id="niveauMatiere" required>
                                        <option value="">Choisir le niveau</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-sm-8" id="selectMatiere">
                                    <div class="form-group">
                                        <label for="matiere">Matière</label>
                                        <select class="form-control" name="matiere" id="matiere" required>
                                        <option value="">Matière</option>
                                        </select>
                                    </div>
                                </div>
                            </div>


                            <div class="selecteurRem hidden">
                                <div class="form-group">
                                    <label for="modalCoursGrp">Vos cours</label>
                                    <select class="form-control" name="coursGrp" id="modalCoursGrp" required>
                                    <option value="">Cours</option>
                                    </select>
                                </div>
                            </div>

                        </div>

                    </div>

                    <div class="row">
                        <div class="col-xs-6">
                            <div class="form-group">
                                <input type="text" class="form-control datepicker" id="startDate" name="startDate" value="{$travail.startDate}" required>
                                <div class="help-block">Date de la note</div>
                            </div>
                        </div>

                        <div class="col-xs-6">

                            <div class="input-group">
                                <input
                                    type="text"
                                    name="heure"
                                    id="heureCC"
                                    value="{if isset($travail.allDay) && $travail.allDay == true}Journée entière{else}{$travail.heure}{/if}"
                                    class="form-control input-sm"
                                    autocomplete="off"
                                    required
                                    {if isset($travail.allDay) && $travail.allDay == true}disabled{/if}>
                                <div class="input-group-btn">
                                    <button
                                        id="listePeriodes"
                                        type="button"
                                        class="btn btn-primary btn-sm dropdown-toggle"
                                        data-toggle="dropdown"
                                        {if isset($travail.allDay) && $travail.allDay == true}disabled{/if}>
                                    <i class="fa fa-hourglass"></i> <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu pull-right" id="choixPeriode">
                                        {foreach from=$listePeriodes item=unePeriode}
                                        <li><a href="javascript:void(0)" data-periode="{$unePeriode['debut']}">{$unePeriode['debut']}</a></li>
                                        {/foreach}
                                    </ul>
                                </div>
                            </div>
                            <div class="help-block">Heure</div>

                        </div>

                    </div>

                    <input type="hidden" name="idTravail" id="idTravail" value="{$idTravail}">

                </form>

            </div>
            <div class="modal-footer">
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
                    <button type="button" class="btn btn-primary" id="btn-saveCible">Sélectionner</button>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        $('#formCible').validate();

        // le cadenas est-il ouvert pour l'écriture dans le passé?
        var pastIsOpen = {$pastIsOpen};
        if (pastIsOpen)
            limite = new Date(1900,0,1)
            else limite = new Date();

        $(".datepicker").datepicker({
            startDate: limite,
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        });

        $('#choixPeriode li a').click(function(){
            $('#heureCC').val($(this).attr('data-periode'));
        })

        function reset(){
            $('#matiere').val('');
            $('#modalCoursGrp').val('');
            $('#classeEleve').val('');
            $('#matiere').html('<option value="">Matière</option>');
            $('#modalCoursGrp').html('<option value="">Cours</option>');
            $('#classeEleve').html('<option value="">Classe</option>');
        }

        $('#modalEditCible').on('click', '#btn-saveCible', function(){
            if ($('#formCible').valid()) {
                var formulaire = $('#formCible').serialize();
                $.post('inc/jdc/saveClone.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    var resultat = JSON.parse(resultat);
                    var idTravail = parseInt(resultat.idTravail);
                    if (idTravail != 0) {
                        bootbox.alert('La mention au JDC a été ajoutée pour <strong>'+ resultat.groupe + '</strong>');
                        $('#calendar').fullCalendar('refetchEvents');
                         }
                         else bootbox.alert('lA MENTION N\'A PAS ÉTÉ AJOUTÉE POUR <strong>' + resultat.groupe +'</strong>...');
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
                            $('#modalCoursGrp').html(resultat);
                        })
                    $('#modalCoursGrp').closest('.selecteurRem').removeClass('hidden');
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
