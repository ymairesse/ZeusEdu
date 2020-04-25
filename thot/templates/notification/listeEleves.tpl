<div class="panel panel-default">

    <div class="panel-body">

        {if isset($listeEleves)}

            <div id="listeEleves" style="max-height:25em; overflow:auto;">

                <p class="checkbox">
                    <label><input type="checkbox" name="TOUS" id="cbTous" value="tous" checked {if isset($type)}disabled{/if}><strong>TOUS</strong></label>
                </p>

                <ul class="list-unstyled">
                    {foreach from=$listeEleves key=matricule item=eleve}

                        <li class="checkbox">
                            <label>
                                <input type="checkbox" name="membres[]" value="{$matricule}" checked {if isset($type)}disabled{/if}>
                                {$eleve.nom} {$eleve.prenom}
                            </label>
                        </li>

                    {/foreach}
                </ul>

            </div>
        {/if}

    </div>

    {if isset($notification.id)}
        <p class="discret">Il n'est pas possible de modifier les destinataires.</p>
    {/if}

</div>

<script type="text/javascript">

    $(document).ready(function() {

        $('#cbTous').change(function(){
            if ($('#cbTous').is(':checked')) {
                $('#listeEleves input').prop('checked', true);
            }
                else {
                    $('#listeEleves input').prop('checked', false);
                }
        })

    })

</script>
