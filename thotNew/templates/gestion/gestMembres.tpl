<div class="col-md-3 col-sm-12" id="listeMembres">

    {include file='gestion/inc/listeMembres.tpl'}

</div>

<div class="col-md-9 col-sm-12" id="selectMembres">

    {include file="gestion/inc/addMembres.tpl"}

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#listeMembres').on('click', '.btn-statut', function(){
            var membre = $(this).data('acronyme');
            var oldStatut = $(this).data('statut');
            var nomGroupe = $(this).data('nomgroupe');
            console.log(nomGroupe);
            var ceci = $(this);
            statut = (oldStatut == 'admin') ? 'membre' : 'admin';

            $.post('inc/gestion/changeStatut.inc.php', {
                membre: membre,
                nomGroupe: nomGroupe,
                statut: statut
            }, function(resultat){
                ceci.data('statut', resultat);
                ceci.removeClass(oldStatut).addClass(resultat);
            })
        })

        $('#selectMembres').on('change', '.selecteurAddMembres', function(){
            var nb = parseInt($('.selecteurAddMembres:checked').length);
            var maxMembres = parseInt($('#maxMembres').val());
            var nbMembres = parseInt($('#nbMembres').val());
            var ceci = $(this);
            if (nb + nbMembres > maxMembres) {
                ceci.prop('checked', false);
                bootbox.alert({
                    title: 'Dépassement du quota',
                    message: 'Vous dépassez le nombre maximum d\'inscrits'
                })
            }

        })

    })

</script>
