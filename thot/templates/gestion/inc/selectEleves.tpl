<form id="formAddMembres">

    <input type="hidden" name="nomGroupe" id="nomGroupe" value="{$nomGroupe}">
    <input type="hidden" name="intitule" id="intitule" value="{$intitule}">

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

            <div class="form-group hidden selecteur" id="selectEleves">

            </div>

        </div>

        <div class="panel-footer">
            <button type="button" class="btn btn-success btn-block" id="addMembres"><<< Ajouter les élèves</button>
        </div>

    </div>

</form>

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

    })
</script>
