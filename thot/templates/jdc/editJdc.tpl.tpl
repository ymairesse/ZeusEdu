<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<h4>Ajout/modification d'une note</h4>

<form action="index.php" method="POST" name="addJdc" id="addJdc" role="form" class="form-vertical">

    <div class="form-group">
        <label for="coursGrp" class="sr-only">Cours</label>
        <select name="coursGrp" id="coursGrp" class="form-control">
            <option value="">Sélectionner</option>
            // cas où le prof est titulaire d'une classe
            {foreach from=$listeClasses item=uneClasse}
                <option value="classe|{$uneClasse}"{if isset($classe) && ($classe == $uneClasse)} selected{/if}>
                    {$uneClasse}
                </option>
            {/foreach}
            {foreach from=$listeCours key=leCoursGrp item=unCours}
            <option value="cours|{$leCoursGrp}"{if $leCoursGrp == $coursGrp} selected{/if}>
                {$unCours.libelle} {$unCours.nomCours|default:''} {$leCoursGrp}
            </option>
            {/foreach}
        </select>
    </div>

    <div class="form-group">
        <label for="categorie" class="sr-only">Catégorie</label>
        <select name="categorie" id="categorie" class="form-control">
            <option value="">Veuillez choisir une catégorie</option>
            {foreach from=$categories key=id item=cat}
                <option value="{$id}">{$cat.categorie}</option>
            {/foreach}
        </select>
    </div>


    <div class="form-group">
        <label for="date" class="sr-only">Date</label>
        <input type="text" name="date" id="datepicker" value="" placeholder="Date de notification" class="ladate form-control" autocomplete="off">
        <div class="help-block">Date de notification</div>
    </div>

    <div class="form-group">
        <label for="heure" class="sr-only">Heure</label>
        <input type="text" name="heure" id="timepicker" value="" placeholder="Heure de notification" class="form-control" autocomplete="off">
        <div class="help-block">Heure</div>
    </div>

    <div class="input-group">

        <input type="text" name="duree" id="duree" class="form-control" value="" autocomplete="off">

		<div class="input-group-btn">
			<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
				Durée (min) <span class="caret"></span>
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

    <div class="form-group">
        <label for="titre" class="sr-only">Titre</label>
        <input type="text" name="titre" id="titre" placeholder="Titre de la note" value="" class="form-control" autocomplete="off">
    </div>

    <div class="form-group">
        <label for="enonce" class="sr-only">Texte</label>
        <textarea name="enonce" id="enonce" class="form-control ckeditor" rows="4" cols="40" placeholder="Votre texte ici"></textarea>
    </div>


    <div class="btn-group pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="submit" class="btn btn-primary">Enregistrer</button>
    </div>

    <input type="hidden" name="action" value="jdc">
    <input type="hidden" name="mode" value="save">

    </form>




<script type="text/javascript">

$.validator.addMethod(
    "dateFr",
    function(value, element) {
        return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
    },
    "date au format jj/mm/AAAA svp"
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
    jQuery.validator.addMethod('uneDate', function(value, element) {
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
        }, "Date incorrecte");


$(document).ready(function(){

    $.validator.addMethod('time', function(value, element) {
        return this.optional(element) || /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/i.test(value);
       }, "Heure invalide");

    $("#addJdc").validate({
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
            timeFormat: 'h:mm:ss p',
    		minuteStep: 5,
    		showSeconds: false,
    		showMeridian: false
    		}
        );

    $("#ladate").val(today());
	$("#datepicker").val(today());

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

})

</script>
