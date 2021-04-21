<form id="formShare">
<div class="col-xs-12 col-sm-6">
    <div class="panel panel-info">

        <div class="panel-heading">
            Liste des Niveaux
        </div>

        <div class="panel-body">
            <div class="form-group">
                <select class="form-control" name="niveau" id="niveau">
                    <option value="">Niveau</option>
                    {foreach from=$listeNiveaux item=unNiveau}
                    <option value="{$unNiveau}">{$unNiveau}e année</option>
                    {/foreach}
                </select>
            </div>

            <button type="button" class="btn btn-primary btn-block" id="btn-selectAllClasses">Toutes les classes</button>

            <div id="listeClasses">

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
                niveau: {
                    required: true
                },
                'acronyme[]': {
                    required: true
                },
                'listeClasses[]': {
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
                var nbClasses = $('#selectClasse option:selected').length;
                var nbProfs = $('#acronyme option:selected').length;
                var formulaire = $('#formShare').serialize();
                var action;
                $.post('inc/saveShares.inc.php', {
                    formulaire: formulaire
                }, function(resultatJSON){
                    var resultat = JSON.parse(resultatJSON);
                    action = (resultat.nbTotal < 0) ? " supprimés " : "ajoutés";
                    nbTotal = Math.abs(resultat.nbTotal);
                    bootbox.alert({
                        title: 'Partages',
                        message: "<strong>" + nbTotal + "</strong> enregistrements " + action + " pour <strong>" + resultat.nbEleves + " bloc-notes</strong> partagé(s) avec <strong>" + resultat.nbProfs + " enseignant(s)</strong>"
                    })
                })
            }
        })

        $('#niveau').change(function(){
            var niveau = $(this).val();
            $.post('inc/getListeClasses4Niveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#listeClasses').html(resultat);
            })
        })

        $('#btn-selectAllClasses').click(function(){
            $('#selectClasses option').prop('selected', true)
        })
    })

</script>
