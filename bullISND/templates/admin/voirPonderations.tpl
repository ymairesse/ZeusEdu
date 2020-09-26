<div class="container">

{include file="selecteurs/selectNiveau.tpl"}

<div id="ponderations">

    {include file='admin/listePonderations.tpl'}

</div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function(){
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#ajaxLoader').addClass('hidden');
        });

        $('.niveau').click(function(){
            $('.niveau').removeClass('btn-primary').addClass('btn-default');
            $(this).addClass('btn-primary');
            var niveau = $(this).data('niveau');
            $.post('inc/init/getPonderations.inc.php', {
                niveau: niveau
                },
                function(resultat){
                    $('#ponderations').html(resultat);
                })
        })

    })

</script>
