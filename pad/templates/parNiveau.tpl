<div class="container">

    <form id="formShare">


    <div class="row">

        <div class="col-md-4">

            <div class="form-group">
                <label for="classe">Classes</label>
                <select class="form-control" name="classe" id="classe">
                    <option value="">Choisir</option>
                    {foreach from=$listeClasses item=uneClasse}
                    <option value="{$uneClasse}">{$uneClasse}</option>
                    {/foreach}
                </select>

            </div>

            <div id="eleves4classe">

            </div>

        </div>

        <div class="col-md-4">
            <button type="button" class="btn btn-primary btn-block" id="selectAlllProfs">Sélection/désélection</button>

            <div id="listeProfs" style="height:30em; overflow:auto;">

                <ul class="list-unstyled">
                {foreach from=$listeProfs key=acronyme item=data}
                    <li>
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" name="acronyme[]" value="{$acronyme}" class="acronyme">
                                <span>{$data.nom} {$data.prenom}</span>
                            </label>
                        </div>
                    </li>
                {/foreach}
                </ul>

            </div>

        </div>

        <div class="col-md-4">
            <h4>Mode de partage</h4>
            <div class="radio">
                <label><input type="radio" name="moderw" value="r"{if !(isset($moderw)) || $moderw == 'r'} checked="checked"{/if}>Lecture seule</label>
            </div>
            <div class="radio">
                <label><input type="radio" name="moderw" value="rw"{if $moderw == 'rw'} checked="checked"{/if}> Lecture/écriture</label>
            </div>

            <div class="radio">
                <label><input type="radio" name="moderw" value="release"{if $moderw == 'release'} checked="checked"{/if}> Fin du partage</label>
            </div>

            <div class="btn-group-vertical" class="pull-right btn-block" style="width:100%">
                <button type="reset" class="btn btn-default">Annuler</button>
                <button type="button" class="btn btn-primary" id="submit">Enregistrer</button>

            </div>

        </div>

    </div>

    </form>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#submit').click(function(){
            var formulaire = $('#formShare').serialize();
            $.post('inc/partageNiveau.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                bootbox.alert({
                    title: 'Partages de bloc notes',
                    message: resultat + " partage(s) enregistré(s)"
                })
            })
        })

        $('#eleves4classe').on('click', '#selectAllEleves', function(){
            $('#eleves option').prop('selected', true);
            var nb = $("#eleves :selected").length;
            $("#nbEleves").html(nb+" élève(s) sélectionné(s)");
        })

        $('#selectAlllProfs').click(function(){
            $('.acronyme').trigger('click');
        })

        $('#classe').change(function(){
            var classe = $(this).val();
            $.post('inc/listeEleves.inc.php', {
                classe: classe
            }, function(resultat){
                $('#eleves4classe').html(resultat);
            })
        })
    })

</script>
