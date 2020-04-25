{assign var=maxMembres value=$dataGroupe.maxMembres}
{assign var=totalMembres value=$listeMembres.profs|@count|default:0 + $listeMembres.eleves|@count|default:0}
<div class="row">

    <div class="col-xs-6">

        <input type="hidden" name="nomGroupe" id="nomGroupe" value="{$nomGroupe}">

        <form id="formAddMembresEleves">

            <div class="panel panel-success">
                <div class="panel-heading">
                    Sélection d'élèves
                </div>

                <div class="panel-body"  style="max-height:35em; overflow: auto;">

                    <div class="form-group selecteur" id="selectNiveau">
                        <label for="niveau">Niveau d'étude</label>
                        <select class="form-control" name="niveau" id="niveau">
                            <option value="">Choix du niveau</option>
                            {foreach from=$listeNiveaux key=wtf item=niveau}
                                <option value="{$niveau}">{$niveau}e année</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="form-group hidden selecteur" id="selectClasse">
                    </div>

                    <div class="hidden" id="selectEleves">
                    </div>

                </div>

                <div class="panel-footer">
                    <button type="button"
                        class="btn btn-success btn-block"
                        id="addMembresEleves"><<< Ajouter les élèves</button>
                </div>

            </div>

        </form>

    </div>

    <div class="col-xs-6">

        <form id="formAddMembresProfs">

            <div class="panel panel-success">
                <div class="panel-heading">
                    Sélection des professeurs
                </div>

                <div class="panel-body"  style="max-height:35em; overflow: auto;">

                    <ul class="list-unstyled">
                    {foreach from=$listeProfs key=unAcronyme item=prof}
                        <li>
                            <div class="checkbox">
                                <label><input type="checkbox" value="{$unAcronyme}" name="profs[]" class="selecteurAddMembres">
                                    {$prof.nom|truncate:15:'...'} {$prof.prenom}
                                </label>
                            </div>
                        </li>
                    {/foreach}
                    </ul>

                </div>

                <div class="panel-footer">
                    <button type="button" class="btn btn-success btn-block" id="addMembresProfs"><<< Ajouter les Professeurs</button>
                </div>

            </div>

        </form>

    </div>

</div>



<script type="text/javascript">

    $(document).ready(function(){

        $('#niveau').change(function(){
            $('#selectClasse').removeClass('hidden');
            $('#selectEleves').addClass('hidden');
            var niveau = $(this).val();
            $.post('inc/selecteurs/selectClasseNiveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#selectClasse').html(resultat).removeClass('hidden');
            })
        })

        $('#selectClasse').on('change', '#classe', function(){
            var classe = $(this).val();
            $.post('inc/selecteurs/selecteurElevesClasse.inc.php', {
                classe: classe
            }, function(resultat){
                $('#selectEleves').html(resultat).removeClass('hidden');
            })
        })

        $('#selectMembres').on('click', '#addMembresProfs', function(){
            var formulaire = $('#formAddMembresProfs').serialize();
            var nomGroupe = $('#nomGroupe').val();
            $.post('inc/gestion/addMembresProfs.inc.php', {
                formulaire: formulaire,
                nomGroupe: nomGroupe
            }, function(resultat){
                bootbox.alert({
                    title: 'Ajout de nouveaux professeurs',
                    message: resultat + ' professeur(s) ajouté(s)'
                });

                $.post('inc/gestion/refreshMembresGroupe.inc.php', {
                    formulaire: formulaire,
                    nomGroupe: nomGroupe
                }, function(resultat){
                    $('#listeMembres').html(resultat);
                })
            })

        })

        $('#selectMembres').on('click', '#addMembresEleves', function(){
            if ($('#formAddMembresEleves').valid()){
                var formulaire = $('#formAddMembresEleves').serialize();
                var nomGroupe = $('#nomGroupe').val();
                $.post('inc/gestion/addMembresEleves.inc.php', {
                    formulaire: formulaire,
                    nomGroupe: nomGroupe
                }, function(resultat){
                    bootbox.alert({
                        title: 'Ajout de nouveaux élèves',
                        message: resultat + ' élève(s) ajouté(s)'
                    });
                    $.post('inc/gestion/refreshMembresGroupe.inc.php', {
                        formulaire: formulaire,
                        nomGroupe: nomGroupe
                    }, function(resultat){
                        $('#listeMembres').html(resultat);
                    })
                })
            }
        })

    })
</script>
