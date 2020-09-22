<form name="editJdc" id="editJdc" class="form-vertical">

    <div class="row">

        <div class="col-md-6 col-sm-12">

            <div class="form-group">
                <label for="categorie" class="sr-only">Catégorie</label>
                <select name="categorie" id="categorie" class="form-control input-sm">
                    {foreach from=$categories key=id item=cat}
                        <option value="{$id}"{if isset($travail) && ($travail.idCategorie == $id)} selected{/if}>{$cat.categorie}</option>
                    {/foreach}
                </select>
            </div>

        </div>  <!-- col-md-... -->

        <div class="col-md-6 col-sm-12">

            <h2 class="pull-right" style="padding: 0 1em; margin: 0;"><strong>{$lblDestinataire}</strong></h2>

        </div>  <!-- col-md-... -->

    </div>  <!-- row -->



    <div class="row">

        <div class="col-md-3 col-sm-6">
            <div class="form-group">
                <label for="date" class="sr-only">Date</label>
                <input type="text" name="date" id="datepicker" value="{$travail.startDate}" placeholder="Date de notification" class="ladate form-control input-sm" autocomplete="off">
                <div class="help-block">Date de la note</div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">

            <div class="input-group">
                <input type="text" name="heure" id='heure' value="{$travail.heure|default:''}" class="form-control input-sm" autocomplete="off" {if isset($travail.allDay) && $travail.allDay == true}disabled{/if}>
                <div class="input-group-btn">
                    <button id="listePeriodes" type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown"><i class="fa fa-hourglass"></i> <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu pull-right" id="choixPeriode">
                        {foreach from=$listePeriodes item=unePeriode}
                        <li><a href="javascript:void(0)" data-periode="{$unePeriode['debut']}">{$unePeriode['debut']}</a></li>
                        {/foreach}
                    </ul>
                </div>
            </div>
            <div class="help-block">Heure</div>

        </div>

        <div class="col-md-4 col-sm-6">

            <div class="input-group">

                <input type="text" name="duree" id="duree" class="form-control input-sm" value="{$travail.duree|default:''}" autocomplete="off" {if isset($travail.allDay) && $travail.allDay == true}disabled{/if}>

    			<div class="input-group-btn">
    				<button id="listeDurees" type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown">(min) <span class="caret"></span>
    				</button>
                    {assign var=heures value=range(0,8)}
    				<ul class="dropdown-menu pull-right" id="choixDuree">
                        {foreach from=$heures item=duree}
                            <li><a href="javascript:void(0)" data-value="{$duree*50}">{$duree}x50'</a></li>
                        {/foreach}
                        <li><a href="javascript:void(0)" data-value="-">Autre</a></li>
    				</ul>
                </div>    <!-- input-group-btn -->

    		</div>  <!-- input-group -->
            <div class="help-block">Durée</div>

        </div>  <!-- col-md-4... -->

        <div class="col-md-2 col-sm-12">

            <div class="form-group">
                <label for="journee" class="sr-only">Journée</label>
                <input type="checkbox" name="journee" id='journee' value='1'{if isset($travail.allDay) && $travail.allDay == true} checked='checked'{/if}>
                <div class="help-block">Journée entière</div>
            </div>

        </div>
</div>

<div class="row">

        <div class="col-md-7 col-xs-8">
            <div class="form-group">
                <label for="titre" class="sr-only">Titre</label>
                {assign var=idFirst value=$categories|key}
                {assign var=defaultTitle value=$categories.$idFirst.categorie}
                <input type="text"
                    name="titre"
                    id="titre"
                    placeholder="Titre de la note"
                    value="{$travail.title|default:$defaultTitle}"
                    class="form-control"
                    data-modified="false"
                    autocomplete="off">
                    <span class="modified hidden">*</span>
            </div>
        </div>

        <div class="col-md-5 col-xs-4">
            <div class="btn-group pull-right">
                <button type="reset" class="btn btn-default">Annuler</button>
                <button type="button" class="btn btn-primary" id="saveJDC"><i class="fa fa-floppy-o"></i> Enregistrer</button>
            </div>
        </div>
</div>


    <div class="form-group">
        <label for="enonce" class="sr-only">Texte</label>
        <textarea name="enonce" id="enonce" class="summernote form-control" placeholder="Votre texte ici">{$travail.enonce|default:''}</textarea>
    </div>

    {* ------------------------------------------------------------------------------*}
    {include file="../../../widgets/fileTree/templates/treeview4PJ.tpl"}
    {* ------------------------------------------------------------------------------*}

    <div class="clearfix"></div>

    <input type="hidden" name="id" value="{$travail.id|default:''}">
    <input type="hidden" name="type" value="{$travail.type|default:''}">
    <input type="hidden" name="edition" id="edition" value="false">
    <input type="hidden" name="destinataire" value="{$travail.destinataire}">

</form>

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
        return this.optional(element) || (/^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/i.test(value)
           && ((parseInt(value) >= 8) && (parseInt(value) <= 22)));
       },
    "Heure invalide"
    );


$(document).ready(function(){
    // $('#enonce').summernote({})
    //
    $('#enonce').summernote({
        lang: 'fr-FR', // default: 'en-US'
        height: null, // set editor height
        minHeight: 250, // set minimum height of editor
        height: 350,
        focus: true, // set focus to editable area after initializing summernote
        styleTags: [
           'p',
               { title: 'Blockquote', tag: 'blockquote', className: 'blockquote', value: 'blockquote' },
               'pre', 'h1', 'h2'
           ],
        toolbar: [
          ['style', ['style']],
          ['font', ['bold', 'underline', 'italic', 'clear']],
          ['font', ['strikethrough', 'superscript', 'subscript']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture', 'video']],
          ['view', ['fullscreen', 'codeview', 'help']],
        ],
        maximumImageFileSize: 524288,
        callbacks: {
            onChange: function(contents, $editable) {
                $('#enonce').val(contents);
            }
        }
    });

    $("#editJdc").validate({
        // pour faire valider aussi le champ caché "textarea" couvert par Summernote
        // ignore: [],
        errorPlacement: function( error, element ) {
            var placement = element.closest('.input-group');
            if (!placement.get(0)) {
                placement = element;
            }
            if (error.text() !== '') {
                if (element.hasClass("summernote")) {
                    error.insertAfter(element.siblings(".note-editor"));
                } else {
                    error.insertAfter(element);
                    }
                }
            },
        rules: {
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
                required: true,
                minlength: 20
            }
        },
        messages: {
            enonce: 'Un texte significatif svp.'
        }
    });

    $("#timepicker").timepicker({
    		defaultTime: 'current',
    		minuteStep: 5,
    		showSeconds: false,
    		showMeridian: false,
    		}
        );

    $('#journee').change(function(){
        var isChecked =  ($(this).is(':checked'));
        $('#heure').prop('disabled', isChecked);
        $('#duree').prop('disabled', isChecked);
    })

    $("#datepicker").datepicker({
        format: "dd/mm/yyyy",
        clearBtn: true,
        language: "fr",
        calendarWeeks: true,
        autoclose: true,
        todayHighlight: true,
        daysOfWeekDisabled: [0,6],
        }
    );

    $("#choixDuree li a").click(function(){
        $("#duree").val($(this).attr("data-value"))
        })

    $('#choixPeriode li a').click(function(){
        $('#heure').val($(this).attr('data-periode'));
    })

    $("#datepicker").change(function(){
        var date = $(this).val();
        $("#startDate").val(moment(dateMysql(date)).format('YYYY-MM-DD HH:mm'));
        })

    $('#titre').change(function(){
        $('#titre').data('modified', true);
        $('#titre').addClass('modified');
    })

    $('#categorie').change(function(){
        var modified = $('#titre').data('modified');
        if (modified == false) {
            var texte = $("#categorie option:selected").text();
            $('#titre').val(texte);
        }
    })

})

</script>
