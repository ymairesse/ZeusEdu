<form id="formShare">

<div class="col-xs-12 col-sm-6">
    <div class="panel panel-info">

        <div class="panel-heading">
            Liste de vos cours
        </div>

        <div class="panel-body">
            <div class="form-group">
                <select class="form-control" name="coursGrp" id="coursGrp">
                    <option value="">Cours</option>
                    {foreach from=$listeCoursGrp key=coursGrp item=data}
                    <option value="{$coursGrp}">[{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures} {if $data.nomCours != ''}({$data.nomCours}){/if}</option>
                    {/foreach}
                </select>
            </div>

            <button type="button" class="btn btn-primary btn-block" id="btn-selectAllEleves">Tous les élèves</button>

            <div id="listeEleves">

            </div>
        </div>

    </div>
</div>

<div class="col-xs-12 col-sm-6">

    {include file="panelProfs.tpl"}

</div>

<div class="clearfix"></div>

</form>


<script type="text/javascript">

    $(document).ready(function(){

        $('#formShare').validate({
            rules: {
                coursGrp: {
                    required: true
                },
                'acronyme[]': {
                    required: true
                },
                'matricule[]': {
                    required: true
                }
            }
        })

        $(document).ajaxStart(function(){
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#ajaxLoader').addClass('hidden');
        });

        $('#btn-shareProf').click(function(){
            if ($('#formShare').valid()) {
                var nbEleves = $('#selectEleve option:selected').length;
                var nbProfs = $('#acronyme option:selected').length;
                var formulaire = $('#formShare').serialize();
                var action;
                $.post('inc/saveShares.inc.php', {
                    formulaire: formulaire
                }, function(resultatJSON){
                    var resultat = JSON.parse(resultatJSON)
                    action = (resultat.nbTotal < 0) ? " supprimés " : "ajoutés";
                    nbTotal = Math.abs(resultat.nbTotal);
                    bootbox.alert({
                        title: 'Partages',
                        message: "<strong>" + nbTotal + "</strong> enregistrements " + action + " pour <strong>" + resultat.nbEleves + " bloc-notes</strong> partagé(s) avec <strong>" + resultat.nbProfs + " enseignant(s)</strong>"
                    })
                })
            }
        })

        $('#coursGrp').change(function(){
            var coursGrp = $(this).val();
            $.post('inc/getListeElevesCoursGrp.inc.php', {
                coursGrp: coursGrp
            }, function(resultat){
                $('#listeEleves').html(resultat);
            })
        })

        $('#btn-selectAllEleves').click(function(){
            $('#selectEleve option').prop('selected', true)
        })
    })

</script>
