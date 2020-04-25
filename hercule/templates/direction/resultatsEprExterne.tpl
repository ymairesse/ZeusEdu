<div class="container">

    <div class="col-md-4 col-sm-6">
        <form class="form-vertical">

        <div class="form-group">
          <label for="selectClasse">Classe</label>
          <select id="selectClasse" name="classe" class="form-control">
              <option value="">Classe</option>
              {foreach from=$listeClasses item=uneClasse}
                <option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected{/if}>{$uneClasse}</option>
              {/foreach}
          </select>
          <p class="help-block">Choisir la classe</p>
        </div>

        <div class="form-group">
          <label for="dateMois">Mois</label>
          <select id="dateMois" class="form-control" name="mois">
              <option value="">Choisir le mois</option>
              {foreach from=$listeMois item=leMois}
                <option value="{$leMois}"{if isset($mois) && ($leMois == $mois)} selected{/if}>{$leMois}</option>
              {/foreach}
          </select>
          <p class="help-block">Mois de l'année.</p>
        </div>

        <div class="form-group">
          <label for="dateAnnee">Année</label>
          <input type="text" class="form-control" id="dateAnnee" placeholder="Année" value="{$annee}">
          <p class="help-block">Année de l'épreuve</p>
        </div>

        <div class="form-group">
            <label for="signature" class="checkbox-inline">
                <input id="signature" name="signature" type="checkbox" value="1" checked>Impression de la signature</label>
            <div id="imgSignature">
                <strong>{$DIRECTION}</strong>
                <img src="images/direction.jpg" alt="signature de la direction" id="signe" class="img-responsive">
            </div>

        </div>

        <div class="btn-group pull-right">
          <button type="reset" class="btn btn-default">Annuler</button>
          <button type="button" class="btn btn-primary" id="print">Générer le document</button>
        </div>

        <div class="clearfix"></div>
        </form>

    </div>  <!-- col-md-... -->

    <div class="col-md-8 col-sm-6">

        <h4>Aperçu de l'entête</h4>
        <div class="apercu">
        {include file='direction/ext/titreExterne.tpl'}
        <p class="small">Voir le fichier templates/direction/ext/titreExterne.tpl</p>
            <img src="../images/ajax-loader.gif" class="hidden" id="ajaxLoader">
        </div>

        <div class="alert alert-danger hidden" id="noClasses">
            <i class="fa fa-warning fa-2x"></i> Veuillez sélectionner une classe.
        </div>
        <!-- alert noClasses -->

        <div class="alert alert-danger hidden" id="noMois">
            <i class="fa fa-warning fa-2x"></i> Veuillez sélectionner un mois.
        </div>
        <!-- alert noMois  -->

        <div class="alert alert-danger hidden" id="noAnnee">
            <i class="fa fa-warning fa-2x"></i> Veuillez indiquer une année.
        </div>
        <!-- alert noAnnee  -->

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Le fichier à imprimer</h3>
            </div>
            <div class="panel-body">
                <div id="ajaxLoader" class="hidden">
                    <p>Veuillez patienter</p>
                    <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
                </div>
                <div id="link" class="hidden"></div>
            </div>
        </div>

    </div>

</div>

<style media="screen" type="text/css">

.reset {
    border: 1px solid black;
}

.reset td {
    padding: 0.5em;
}

.reset * {
    color: black;
    background: none;
    border: none;
}

.reset h1 {
    font-size: 1.8571em; /* equiv 26px */
    font-weight: normal;
    line-height: 1.6154em;
    margin: .8077em 0 0 0;
    color: black;
}
.reset h2 {
    font-size: 1.7143em; /* equiv 24px */
    font-weight: normal;
    line-height: 1.75em;
    margin: .875em 0 0 0;
}

</style>


<script type="text/javascript">

$(document).ready(function(){

    $(document).ajaxStart(function() {
        $('#link').addClass('hidden');
        $('#ajaxLoader').removeClass('hidden');
    }).ajaxComplete(function() {
        $('#link').removeClass('hidden');
        $('#ajaxLoader').addClass('hidden');
    });

    $("#signature").click(function() {
        if ($(this).prop('checked') == true)
            $("#signe").removeClass('hidden');
        else $("#signe").addClass('hidden');
    })

    $("#dateMois").change(function(){
        var leMois = $(this).val();
        $("#ceMois").text(leMois);
    })

    $("#dateAnnee").blur(function(){
        var annee = $(this).val();
        $("#cetteAnnee").text(annee);
    })

    $("#print").click(function(){
        var erreur = false;

        var classe = $("#selectClasse").val();
        if (classe == '') {
            $("#noClasses").removeClass('hidden');
            erreur = true;
        } else {
            $("#noClasses").addClass('hidden');
            }

        var annee = $("#dateAnnee").val();
        if (annee == '') {
            $("#noAnnee").removeClass('hidden');
            erreur = true;
        } else {
            $("#noAnnee").addClass('hidden');
            }

        var mois = $("#dateMois").val();
        if (mois == '') {
            $("#noMois").removeClass('hidden');
            erreur = true;
        } else {
            $("#noMois").addClass('hidden');
            }

        var signature = $("#signature").is(':checked') ? 1 : 0;

        if (erreur == false) {
            $.post('inc/direction/generateurEprExterne.inc.php',{
                classe: classe,
                annee: annee,
                mois: mois,
                signature: signature
            },
            function(resultat){
                $("#link").html(resultat);
            })
        }

    })

})

</script>
