<div class="row">

    <div class="col-xs-6">
        <div class="panel panel-danger">
            <div class="panel-heading">
                Enseignants
            </div>
            <div class="panel-body">
                <div id="listeCBprofs" style="height:15em; overflow: auto">
                        {include file="forum/modal/listeCBprofs.tpl"}
                </div>
            </div>
        </div>
    </div>

    <div class="col-xs-6">
        <div class="panel panel-info">
            <div class="panel-heading">
                Élèves
            </div>
            <div class="panel-body">
                <div id="listeCBeleves">
                    <select class="form-control" name="choixCibleEleve" id="choixCibleEleve">
                        <option value="" data-choix="">Sélection des élèves</option>
                        <option value="w" data-choix="tous" data-nb="{$listeAbonnes.ecole|@count|default:0}">Tous les élèves [{$listeAbonnes.ecole|@count|default:0}]</option>
                        <option value="x" data-choix="niveau" data-nb="{$listeAbonnes.niveau|@count|default:0}">Un niveau d'étude [{$listeAbonnes.niveau|@count|default:''}]</option>
                        <option value="y" data-choix="classe" data-nb="{$listeAbonnes.classe|@count|default:0}">Une classe [{$listeAbonnes.classe|@count|default:''}]</option>
                        <option value="z" data-choix="coursGrp" data-nb="{$listeAbonnes.coursGrp|@count|default:0}">Un de vos cours [{$listeAbonnes.coursGrp|@count|default:''}]</option>
                    </select>
                </div>

                <div id="tousEleves" class="hidden sousSelection">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="ecole" id="ecole" value="ecole" class="selecteurEcole"
                            {if isset($listeAbonnes.ecole)} checked{/if}>
                            <span style="padding-left:0.5em">Tous les élèves</span>
                        </label>
                    </div>
                </div>

                <div id="listeNiveaux" style="height:10em; overflow:auto;" class="hidden sousSelection">
                    <ul class="list-unstyled">
                    {foreach from=$listeNiveaux item=niveau}
                        <li>
                            <div class="checkbox">
                                <label>
                                    <input class="selecteurNiveau"
                                        type="checkbox"
                                        name="niveau[]"
                                        value="{$niveau}"
                                        {if isset($listeAbonnes.niveau.$niveau)} checked{/if}>
                                    <span style="padding-left:0.5em">{$niveau}e année</span>
                                </label>
                            </div>
                        </li>
                    {/foreach}
                    </ul>
                </div>

                <div id="listeClasses" style="height:10em; overflow:auto;" class="hidden sousSelection">
                    <ul class="list-unstyled">
                    {foreach from=$listeClasses item=uneClasse}
                        <li>
                            <div class="checkbox">
                                <label>
                                    <input class="selecteurClasses"
                                        id="selecteurClasses"
                                        type="checkbox"
                                        name="classe[]"
                                        value="{$uneClasse}"
                                        {if isset($listeAbonnes.classe.$uneClasse)} checked{{/if}}>
                                    <span style="padding-left:0.5em">{$uneClasse}</span>
                                </label>
                            </div>
                        </li>
                    {/foreach}
                    </ul>
                </div>

                <div id="listeCoursGrp" style="height:10em; overflow:auto;" class="hidden sousSelection">
                    <ul class="list-unstyled">
                    {foreach from=$listeCoursGrp key=unCoursGrp item=dataCoursGrp}
                        <li>
                            <div class="checkbox">
                                <label>
                                    <input class="selecteurCoursGrp"
                                        type="checkbox"
                                        name="coursGrp[]"
                                        value="{$unCoursGrp}"
                                        {if isset($listeAbonnes.coursGrp.$unCoursGrp)} checked{/if}>
                                    <span style="padding-left:0.5em">{$unCoursGrp} - {$dataCoursGrp.libelle} {$dataCoursGrp.nomCours}</span>
                                </label>
                            </div>
                        </li>
                    {/foreach}
                    </ul>
                </div>
            </div>
        </div>
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('.selecteurEcole').click(function(){
            var nb = $('input.selecteurEcole:checked').length;
            $('#choixCibleEleve option[data-choix="tous"]').text('Tous les élèves ['+nb+']').attr('data-nb', nb);
        })

        $('.selecteurNiveau').click(function(){
            var nb = $('input.selecteurNiveau:checked').length;
            $('#choixCibleEleve option[data-choix="niveau"]').text('Un niveau d\'étude ['+nb+']').attr('data-nb', nb);
        })
        $('.selecteurClasses').click(function(){
            var nb = $('input.selecteurClasses:checked').length;
            $('#choixCibleEleve option[data-choix="classe"]').text('Une classe ['+nb+']').attr('data-nb', nb);
        })
        $('.selecteurCoursGrp').click(function(){
            var nb = $('input.selecteurCoursGrp:checked').length;
            $('#choixCibleEleve option[data-choix="coursGrp"]').text('Un de vos cours ['+nb+']').attr('data-nb', nb);
        })

        $('#choixCibleEleve').change(function() {
            var selection = $('#choixCibleEleve option:selected').attr('data-choix');
            $('.sousSelection').addClass('hidden');
            switch (selection) {
                case 'tous':
                    $('#tousEleves').removeClass('hidden');
                    break;
                case 'niveau':
                    $('#listeNiveaux').removeClass('hidden');
                    break;
                case 'classe':
                    $('#listeClasses').removeClass('hidden');
                    break;
                case 'coursGrp':
                    $('#listeCoursGrp').removeClass('hidden');
                    break;
            }
        })

    })

</script>
