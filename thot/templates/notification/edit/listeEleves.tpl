<div class="panel panel-default">

    <div class="panel-body">

        {if isset($listeEleves)}

            <div id="listeEleves" style="max-height:25em; overflow:auto;">

                <div class="btn-group btn-group-justified">
                    <a href="#" class="btn btn-primary btn-xs" id="btn-tous">Tous</a>
                    <a href="#" class="btn btn-success btn-xs" id="btn-invert">Inverser</a>
                    <a href="#" class="btn btn-danger btn-xs" id="btn-none">Aucun</a>
                </div>

                <ul class="list-unstyled">
                    {foreach from=$listeEleves key=matricule item=eleve}

                        <li class="checkbox">
                            <label>
                                <input type="checkbox" class="membres" name="membres[]" value="{$matricule}" checked {if isset($type)}disabled{/if}>
                                {$eleve.nom} {$eleve.prenom}
                            </label>
                        </li>

                    {/foreach}
                </ul>

            </div>
        {/if}

    </div>

    <div class="panel-footer">
        {if isset($notification.id)}
            <p class="discret">Il n'est pas possible de modifier les destinataires.</p>
            {else}
            <p class="discret">Vous pouvez sélectionner seulement certains élèves</p>
        {/if}
    </div>


</div>

<script type="text/javascript">

    $(document).ready(function() {

        // sélection du type "groupe" ou "élèves séparés" selon que toutes
        // les cases sont cochées ou pas
        function setType() {
            var checkedCB = $('#listeEleves li.checkbox :checked').length;
            var totalCB = $('#listeEleves li.checkbox').length;
            if (checkedCB == totalCB) {
                var type = $('#type').val();
                $('#leType').val(type);
                }
                else {
                    $('#leType').val('eleves');
                }
        }

        $('#btn-tous').click(function(){
            $('#listeEleves input').prop('checked', true);
            setType();
        })

        $('#btn-none').click(function(){
            $('#listeEleves input').prop('checked', false);
            setType();
        })

        $('#btn-invert').click(function(){
            var checked;
            $('#listeEleves input').each(function(){
                checked = $(this).prop('checked');
                $(this).prop('checked', !checked);
            })
            setType();
        })

    })

</script>
