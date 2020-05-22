<div class="panel day-highlight dh-{$event.classe}">

        <div class="col-xs-10">
            {assign var=idCat value=$event.idCategorie}
            <h3 class="panel-title cat_{$event.idCategorie}">{$categories.$idCat.categorie|default:'Type d\'événement'}</h3>
        </div>
        <div class="col-xs-2">
            <button type="button" class="btn btn-info btn-block" id="btn-retour" data-idagenda="{$event.idAgenda}" title="Retour aux agendas"><i class="fa fa-undo"></i> </button>
        </div>

    <div class="panel-body">

        {include file='agenda/include/formEditEvent.tpl'}

    <div class="panel-footer">
        <p class="discret">Dernière modification {$event.lastModif} par {$event.redacteur}</p>
    </div>
</div>

<script type="text/javascript">



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
jQuery.validator.addMethod(
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

jQuery.validator.addMethod(
    "time",
    function(value, element) {
        return this.optional(element) || (/^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/i.test(value));
       },
    "Heure invalide"
    );

    $(document).ready(function(){

        $("#formEditAgenda").validate({
            rules: {
                categorie: {
                    required: true
                    },
                startDate: {
                    required: true,
                    uneDate: true
                    },
                startTime: {
                    required: true,
                    time: true
                    },
                endDate: {
                    required: true,
                    uneDate: true
                    },
                endTime: {
                    required: true,
                    time: true
                    },
                title: {
                    required: true
                    },
                enonce: {
                    required: true
                    }
            }
        });

        $(".datepicker").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
        });

        $(".timepicker").timepicker({
                defaultTime: 'current',
                minuteStep: 5,
                showSeconds: false,
                showMeridian: false,
                }
            );
    })

</script>
