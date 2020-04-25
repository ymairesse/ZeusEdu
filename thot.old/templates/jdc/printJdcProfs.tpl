    <div class="col-md-3 col-sm-6">

        <form id="formPrint">

            <div class="form-group col-xs-6">
                <label for="debut">Depuis</label>
                <input type="text" value="{$debut}" name="debut" id="debut" maxlength="10" class="datepicker form-control">
            </div>

            <div class="form-group col-xs-6">
                <label for="fin">Jusqu'à</label>
                <input type="text" value="{$fin}" name="fin" id="fin" maxlength="10" class="datepicker form-control">
            </div>

        <div id="erreur">

        </div>

        <div class="panel panel-default">
            <div class="panel-heading">
                Niveau d'étude
            </div>
            <div class="panel-body">
                <select class="form-control" name="niveau" id="niveau" required>
                    <option value="">Niveau d'étude</option>
                    {foreach from=$listeNiveaux item=niveau}
                    <option value="{$niveau}">{$niveau}e année</option>
                    {/foreach}
                </select>

                <select class="form-control" name="classe" id="listeClasses">
                    <option value="">Classe</option>
                </select>
            </div>

        </div>

        <div class="panel panel-info">
            <div class="panel-heading">
                Liste des élèves
            </div>
            <div class="panel-body" style="height:10em; overflow: auto" id="listeEleves">

            </div>
        </div>

        <div class="panel panel-default">

            <div class="panel-heading">
                Liste des catégories
            </div>

            <div class="panel-body" style="height:15em; overflow: auto;">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="cbCategories">
                        TOUTES
                    </label>
                </div>
                <ul class="list-unstyled">
                    {foreach from=$listeCategories key=idCategorie item=categorie}
                    <li>
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" class="selecteurCategorie" name="idCategories[]" value="{$idCategorie}">
                            <span style="padding-left:0.5em">{$categorie}</span>
                        </label>
                        </div>
                    </li>
                    {/foreach}
                </ul>

            </div>

        </div>

        <button type="button" id="btn-printJdc" class="btn btn-primary btn-block">Envoyer</button>

        </form>

    </div>

    <div class="col-md-9 col-sm-6" id="zonePrint">

        {include file='jdc/pagePrintJdc.tpl'}

    </div>

<style media="screen" type="text/css">
#erreur label.error {
    width: 100%;
    font-size: 0.8em;
    color: yellow;
    padding: 0.2em  0em 0em 1em ;
    font-weight: lighter;
    }
</style>

<script type="text/javascript">

    $(document).ready(function(){

        $('#formPrint').validate( {
            rules: {
                debut: {
                    required: true,
                },
                fin: {
                    required: true,
                },
                niveau: {
                    required: true,
                },
                classe: {
                    required: true,
                },
                "eleves[]": {
                    required: true,
                    minlength: 1
                },
                "idCategories[]": {
                    required: true,
                    minlength: 1
                }
            },
            messages: {
                "debut" : "<p>Date de début obligatoire</p>",
                "fin" : "<p>Date de fin obligatoire</p>",
                "niveau" : "<p>Choisir le niveau d\'étude</p>",
                "classe" : "<p>Choisir la classe</p>",
                "eleves[]": "<p>Au moins un élève</p>",
                "idCategories[]": "<p>Au moins une catégrie</p>"
            },
            errorLabelContainer: "#erreur",
        } )

        $('#niveau').change(function(){
            var niveau = $(this).val();
            $.post('inc/jdc/listeClassesNiveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#listeClasses').html(resultat);
            })
        })

        $(".datepicker").datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $('#listeClasses').change(function(){
            var classe = $(this).val();
            $.post('inc/jdc/listeElevesCB.inc.php', {
                classe: classe
            }, function(resultat){
                $('#listeEleves').html(resultat);
            })
        })

        $('#btn-printJdc').click(function(){
            if ($('#formPrint').valid()){
                var formulaire = $('#formPrint').serialize();
                $.post('inc/jdc/jdcEleves4PDF.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    $('#zonePrint').html(resultat);
                })
            }
        })

        $('#listeEleves').on('change', '#cbEleves', function(){
            $('.selecteurEleve').trigger('click');
        })

        $('#cbCategories').change(function(){
            $('.selecteurCategorie').trigger('click');
        })

    })

</script>
