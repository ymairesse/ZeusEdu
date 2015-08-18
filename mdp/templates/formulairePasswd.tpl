<form name="formPasswd" id="formPasswd" method="POST" action="index.php" role="form" class="form-vertical" autocomplete="off">

    <div class="row">

        <div class="col-md-4 col-sm-12">

            <h4>Vous êtes</h4>
            <p><strong>{$identite.prenom} {$identite.nom}</strong></p>
            <p>Votre nom d'utilisateur: <strong>{$identite.acronyme}</strong></p>

            <p>Votre adresse IP: <strong>{$identiteReseau.ip} {$identiteReseau.hostname}</strong></p>
            <p>Nous sommes le <strong>{$identiteReseau.date}</strong> à <strong>{$identiteReseau.heure}</strong></p>
            <p><i class="fa fa-warning fa-lg text-danger"></i> Ces informations sont enregistrées.</p>

            <div class="input-group">
                <label for="passwd" class="sr-only"></label>
                <span class="input-group-addon"><i class="fa fa-info-circle fa-lg fa-help"></i></span>
                <input type="password" name="passwd" id="passwd" value="" maxlength="20" placeholder="Mot de passe souhaité"
                    class="inputHelp form-control goodPwd">
            </div>

            <div class="input-group">
                <label for="password2" class="sr-only"></label>
                <span class="input-group-addon"><i class="fa fa-info-circle fa-lg fa-help"></i></span>
                <input type="password" name="passwd2" id="passwd2" value="" maxlength="20" placeholder="Veuillez répéter le mot de passe"
                    class="inputHelp form-control">
            </div>

            <div class="btn-group pull-right">
                <button type="reset" class="btn btn-default">Annuler</button>
                <button type="submit" class="btn btn-primary" name="submit">Enregistrer</button>
            </div>
            <input type="hidden" name="userName" value="{$userName}">
            <input type="hidden" name="token" value="{$token}">
            <input type="hidden" name="action" value="{$action}">
        </div> <!-- col-md-... -->

        <div class="col-md-8 col-sm-12">

            {include file="profileHelp.tpl"}

        </div>  <!-- div-md-... -->

    </div>  <!-- row -->

</form>


<script type="text/javascript">

    function countLettres(chaine) {
        return (chaine.match(/[a-zA-Z]/g) == null)?0:chaine.match(/[a-zA-Z]/g).length;
        }
    function countChiffres(chaine) {
        return (chaine.match(/[0-9]/g) == null)?0:chaine.match(/[0-9]/g).length;
    }

    jQuery.validator.addMethod('goodPwd', function(value, element) {
        // validation longueur
        var condLength = (value.length >= 8);
        // validation 2 chiffres min
        var condChiffres = (countChiffres(value) >= 2)
        // validation 2 lettres min
        var condLettres = (countLettres(value) >= 2)

        var testOK = (condLength && condChiffres && condLettres);
        return this.optional(element) || testOK;
        }, "Complexité insuffisante");


$(document).ready(function(){

    $(".help").hide();
    $(".fa-help").css('cursor','pointer');

    $(".inputHelp").focus(function(){
        var id=$(this).attr('id');
        $(".help").hide();
        $("#texte_"+id).fadeIn();
    })

    $(".inputHelp").blur(function(){
        $(".help").hide();
    })

    $(".fa-help").hover(function(){
        var id=$(this).closest('.input-group').find('.inputHelp').attr('id');
        $(".help").hide();
        $("#texte_"+id).fadeIn();
    })

    $("#choixLien li a").click(function(){
        $("#lien").val($(this).data('value'));
        $("#lien").select();
        })

    $("#formPasswd").validate({
      rules: {
        passwd: {
            goodPwd:true
            },
        passwd2: {
            equalTo: "#passwd"
            }
        }
    });

})
</script>
