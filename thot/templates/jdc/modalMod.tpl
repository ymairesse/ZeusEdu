<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div id="modalMod" class="modal fade" aria-hidden="true">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" data-target="#modalMod">&times;</button>
                <h4 class="modal-title">Modification d'un événement</h4>
            </div>

                <form action="index.php" method="POST" name="modJdc" id="modJdc" role="form" class="form-vertical">

                <div class="modal-body">

                    <div class="row">

                    <div class="col-md-5 col-sm-12">

                        <div class="form-group">
                            <label for="categorie" class="sr-only">Catégorie</label>
                            <select name="categorie" id="categorie" class="form-control">
                                <option value="">Veuillez choisir une catégorie</option>
                                {foreach from=$categories key=id item=cat}
                                    <option value="{$id}"{if $id == $travail.idCategorie} selected='selected'{/if}>{$cat.categorie}</option>
                                {/foreach}
                            </select>
                        </div>

                    </div>  <!-- col-md-... -->

                    <div class="col-md-7 col-sm-12">

                        <div class="form-group">
                            <label for="destinataire" class="sr-only">Destinataire</label>
                            <select name="destinataire" id="destinataire" class="form-control">
                                <option value="">Destinataire</option>
                                {foreach from=$listeClasses item=uneClasse}
                                <option data-type="classe" value="{$uneClasse}"{if ($travail.type == 'classe') && ($travail.destinataire == $uneClasse)} selected='selected'{/if}>
                                    {$uneClasse}
                                </option>
                                {/foreach}

                                {foreach from=$listeCours key=leCoursGrp item=unCours}
                                <option data-type="cours" value="{$leCoursGrp}"{if ($travail.type == 'cours') && ($travail.destinataire == $leCoursGrp)} selected='selected'{/if}>
                                    {$unCours.libelle} {$unCours.nomCours|default:''} {$leCoursGrp}
                                </option>
                                {/foreach}
                            </select>
                        </div>

                    </div>  <!-- col-md-... -->

                    </div>

                    <div class="row">

                        <div class="col-md-3 col-sm-6">
                            <div class="form-group">
                                <label for="date" class="sr-only">Date</label>
                                <input type="text" name="date" id="datepicker" value="{$travail.startDate|date_format:"%d/%m/%Y"}" placeholder="Date de notification" class="ladate form-control" autocomplete="off">
                                <div class="help-block">Date de notification</div>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="form-group">
                                <label for="heure" class="sr-only">Heure</label>
                                <input type="text" name="heure" id="timepicker" value="{$travail.heure}" placeholder="Heure de notification" class="form-control" autocomplete="off"{if isset($travail.allDay) && $travail.allDay == true} disabled{/if}>
                                <div class="help-block">Heure</div>
                            </div>
                        </div>

                        <div class="col-md-4 col-sm-6">

                        <div class="input-group">

                            <input type="text" name="duree" id="duree" class="form-control" value="{$travail.duree}"{if isset($travail.allDay) && $travail.allDay == true} disabled{/if}>

                			<div class="input-group-btn">
                				<button id="listeDurees" type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">(min) <span class="caret"></span>
                				</button>
                                {assign var=heures value=range(1,8)}
                				<ul class="dropdown-menu pull-right" id="choixDuree">
                                    {foreach from=$heures item=duree}
                                        <li><a href="javascript:void(0)" data-value="{$duree*50}">{$duree}x50'</a></li>
                                    {/foreach}
                                        <li><a href="javascript:void(0)" data-value="Autre">Autre</a></li>
                				</ul>
                            </div>    <!-- input-group-btn -->

                		</div>  <!-- input-group -->
                        <div class="help-block">Durée</div>

                        </div>  <!-- col-md-4... -->

                        <div class="col-md-1 col-sm-12">

                            <div class="form-group">
                                <label for="journee" class="sr-only">Journée</label>
                                <input type="checkbox" name="journee" id='journee' value='allDay'{if isset($travail.allDay) && $travail.allDay == true} checked='checked'{/if}>
                                <div class="help-block">Journée entière</div>
                            </div>

                        </div>

                    </div>  <!-- row -->

                    <div class="form-group">
                        <label for="titre" class="sr-only">Titre</label>
                        <input type="text" name="titre" id="titre" placeholder="Titre de la note" value="{$travail.title|default:''}" class="form-control" autocomplete="off">
                    </div>

                    <div class="form-group">
                    <label for="enonce" class="sr-only">Texte</label>
                        <textarea name="enonce" id="enonce" class="form-control ckeditor" rows="4" placeholder="Votre texte ici">{$travail.enonce|default:''}</textarea>
                    </div>

                </div>

                <div class="modal-footer">

                    <div class="btn-group pull-right">
                        <button type="reset" class="btn btn-default">Annuler</button>
                        <button type="submit" class="btn btn-primary"><i class="fa fa-floppy-o"></i> Enregistrer</button>
                    </div>

                    <div class="clearfix"></div>
                </div>

                <input type="hidden" name="id" value="{$travail.id}">
                <input type="hidden" name="type" id="type" value="{$travail.type}">
                <input type="hidden" name="startDate" value="{$startDate|default:''}" id="startDate">
                <input type="hidden" name="viewState" value="{$viewState}">

                <input type="hidden" name="action" value="jdc">
                <input type="hidden" name="mode" value="save">

            </form>

        </div>  <!-- modal-content -->

    </div>  <!-- modal-dialog -->

</div>  <!-- modal -->



<script type="text/javascript">

function dateMysql(dateFr) {
    var date = dateFr.split('/');
    return date[2]+'-'+date[1]+'-'+date[0];
    }

jQuery.validator.addMethod (
    "dateFr",
    function(value, element) {
        return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
    },
    "Date au format jj/mm/AAAA svp"
    );

// -------------------------------------------------------------------------------------
// pour des raisons de compatibilité avec Google Chrome et autres navigateurs à base
// de webkit, il ne faut pas utiliser la règle "date" du validateur jquery.validate.js
// Elle sera remplacée par la règle "uneDate" dont le fonctionnement n'est pas basé sur
// le présupposé que le contenu du champ est une date. Google Chrome et Webkit traitent
// exclusivement les dates au format américain mm-dd-yyyy
// sans cette nouvelle règle, les dates du type 15-09-2012 sont refusées sous Webkit
// https://github.com/jzaefferer/jquery-validation/issues/20
// -------------------------------------------------------------------------------------
jQuery.validator.addMethod (
    "uneDate",
    function(value, element) {
    	var reg=new RegExp("/", "g");
    	var tableau=value.split(reg);
    	// ne pas oublier le paramètre de "base" dans la syntaxe de parseInt
    	// au risque que les numéros des jours et des mois commençant par "0" soient
    	// considérés comme de l'octal
    	// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/parseInt
    	jour = parseInt(tableau[0],10); mois = parseInt(tableau[1],10); annee = parseInt(tableau[2], 10);
    	nbJoursFev = new Date(annee,1,1).getMonth() == new Date(annee,1,29).getMonth() ? 29 : 28;
    	var lgMois = new Array (31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    	condMois = ((mois >= 1) && (mois <= 12));
    	if (!(condMois)) return false;
    	condJour = ((jour >=1) && (jour <= lgMois[mois-1]));
    	condAnnee = ((annee > 1900) && (annee < 2100));
    	var testDateOK = (condMois && condJour && condAnnee);
    	return this.optional(element) || testDateOK;
    	},
    "Date incorrecte"
    );

jQuery.validator.addMethod (
    "time",
    function(value, element) {
        return this.optional(element) || (/^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/i.test(value)
           && ((parseInt(value) >= 8) && (parseInt(value) <= 22)));
       },
    "Heure invalide"
    );

 $(document).ready(function(){

    $("#modJdc").validate({
        rules: {
            categorie: {
                required: true
                },
            destinataire: {
                required: true
                  },
            date: {
                required: true,
                uneDate: true
                },
            heure: {
                required: true,
                time: true
                },
            duree: {
                required: true
            },
            titre: {
                required: true
                },
            enonce: {
                required: true
                }
        }
    });

    $("#timepicker").timepicker({
    		defaultTime: 'current',
    		minuteStep: 5,
    		showSeconds: false,
    		showMeridian: false
    		}
        );

    $("#datepicker").datepicker({
        format: "dd/mm/yyyy",
        clearBtn: true,
        language: "fr",
        calendarWeeks: true,
        autoclose: true,
        todayHighlight: true
        }
    );

    $("#choixDuree li a").click(function(){
        $("#duree").val($(this).attr("data-value"))
        })

    $("#datepicker").change(function(){
        var date = $(this).val();
        $("#startDate").val(moment(dateMysql(date)).format('YYYY-MM-DD HH:mm'));
        })

})

</script>
