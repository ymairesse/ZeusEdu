<div class="modal fade" id="modalAccuses" tabindex="-1" role="dialog" aria-labelledby="titleAccuses" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">


        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#modalAccuses').on('click', '#voirListe', function(){
            if ($(this).data('mode') == 'liste') {
                $("#liste").removeClass('hidden');
                $("#portrait").addClass('hidden');
                $(this).html('Voir en portraits');
                $(this).data('mode','portrait');
            }
            else {
                $("#liste").addClass('hidden');
                $("#portrait").removeClass('hidden');
                $(this).html('Voir en liste');
                $(this).data('mode','liste');
            }
        })

    })
</script>
