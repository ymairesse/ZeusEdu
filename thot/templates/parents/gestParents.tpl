<div class="container-fluid">

{if $listeNonInscrits|@count > 0}
<h3>Liste des élèves dont les parents n'ont pas été invités</h3>
<table class="table table-condensed">
    <tr>
        <th style="width:6em">Classe</th>
        <th>Nom</th>
    </tr>
    {foreach from=$listeNonInscrits key=matricule item=eleve}
        <tr>
            <td>{$eleve.classe}</td>
            <td>{$eleve.nom} {$eleve.prenom}</td>
        </tr>
    {/foreach}
</table>
{/if}
{if count($listeParents) > 0}
    <h3>Références des parents <button type="button" class="btn btn-lightBlue pull-right" id="printParents"><i style="color:red" class="fa fa-file-pdf-o fa-lg"></i> Impression fiches</button> </h3>
    <table class="table table-condensed">
        {foreach from=$listeParents key=matricule item=dataParents}
            <tr style="background-color: #ddd">
                <td colspan="8">
                <strong>{$dataParents[0].nomEleve} {$dataParents[0].prenomEleve}</strong>
                </td>
            </tr>
            {foreach from=$dataParents key=n item=unParent}
            <tr>
                <td>&nbsp;</td>
                <td>{$unParent.formule} {$unParent.nom} {$unParent.prenom}</td>
                <td>{$unParent.userName}</td>
                <td>{$unParent.lien}</td>
                <td><a href="mailto:{$unParent.mail}">{$unParent.mail}</a></td>
                <td><button type="button"
                    title="Renvoyer le mail de confirmation d'inscription"
                    data-username="{$unParent.userName}"
                    class="btn btn-success btn-xs btn-mailConfirm" {if $unParent.confirme == 1}disabled{/if}>Mail confirmation</button></td>
                <td><button type="button" class="btn btn-danger btn-xs btn-delUser" data-username="{$unParent.userName}" name="button" title="Supprimer"><i class="fa fa-times"></i></button></td>
                <td>{if $unParent.confirme == 1}
                    <i class="fa fa-check" style="color:green" title="Mail Confirmé"></i>
                    {else}
                    <i class="fa fa-minus" style="color:red" title="Mail Non Confirmé"></i>
                    {/if}
                </td>
            </tr>
            {/foreach}
        {/foreach}
    </table>
{/if}

</div>


<div id="modalMail" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalMailLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalMailLabel">Message à envoyer</h4>
      </div>
      <div class="modal-body">
          <h4>Texte fixe</h4>
          <div id="fixedText" style="max-height:10em; overflow: auto;"></div>
          <h4>Ajout variable</h4>
          <textarea name="varText" id="varText" rows="4" class="form-control"></textarea>

      </div>
      <div class="modal-footer">
         <input type="hidden" name="userName" id="userName" value="">
        <div class="btn-group pull-right">
            <button type="reset" class="btn btn-default">Annuler</button>
            <button type="button" class="btn btn-primary" id="btn-sendMail">Envoyer</button>
        </div>
      </div>
    </div>
  </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        $('#printParents').click(function(){
            var groupe = $('#selectClasse').val();
            $.post('inc/parents/printParents.inc.php', {
                groupe: groupe
            }, function(resultat){
                bootbox.alert({
                    'title': 'Fiches "parents"',
                    'message': resultat
                })
            })
        })

        $('.btn-mailConfirm').click(function(){
            var userName = $(this).data('username');
            $("#userName").val(userName);
            $.post('inc/parents/getFixedMailText.inc.php', {
                userName: userName
                },
                function(resultat){
                    $("#fixedText").html(resultat);
                    $("#modalMail").modal('show');
                })
        })

        $("#btn-sendMail").click(function(){
            var texteFixe = $("#fixedText").html();
            var texteVariable = $("#varText").val();
            var userName = $("#userName").val();
            $.post('inc/parents/sendConfirmMail.inc.php', {
                texteFixe: texteFixe,
                texteVariable: texteVariable,
                userName: userName
                }, function(resultat){
                    $("#modalMail").modal('hide');
                    if (resultat == 1)
                        bootbox.alert('Mail envoyé à l\'utilisateur <strong>'+userName+'</strong>');
                        else {
                            bootbox.alert('Le mail n\'a pas pu être envoyé à l\'utilisateur <strong>'+userName+'</strong>');
                        }
            })
        })


        $(".btn-delUser").click(function(){
            var userName = $(this).data('username');
            var ligne = $(this).closest('tr');
            $.post('inc/parents/getUserDetails.inc.php', {
                userName: userName
                },
                function(resultat){
                    resultat = JSON.parse(resultat)
                    var formule = resultat.formule;
                    var nom = resultat.nom;
                    var prenom = resultat.prenom;
                    bootbox.confirm({
                        message: "Veuillez confirmer la suppression du profil de <strong>"+formule+" "+prenom+" "+nom+"</strong>",
                        buttons: {
                            confirm: {
                                label: 'Supprimer',
                                className: 'btn-danger'
                            },
                            cancel: {
                                label: 'Annuler',
                                className: 'btn-default'
                                }
                            },
                        callback: function(result) {
                            if (result == true) {
                                $.post('inc/parents/delUserParent.inc.php', {
                                    userName: userName
                                    },
                                function(){
                                    ligne.remove();
                                })
                            }
                        }
                    })
                    })
                })

            })
</script>
