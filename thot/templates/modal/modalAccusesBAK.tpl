<div class="modal fade" id="modalAccuses" tabindex="-1" role="dialog" aria-labelledby="titleAccuses" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleAccuses">Accusés de lecture [{$listeAccuses|@count}/{$listeEleves|@count}]</h4>
            </div>
            <div class="modal-body" id="bodyAccuses" style="max-height:30em; overflow: auto;">

                {* présentation sous forme de galerie de portraits *}
                {if ($listeEleves|@count < 30)}
                {assign var=portrait value=true}
                <div id="portrait">
                    {foreach from=$listeEleves key=matricule item=data}
                    <div class="ombre {if isset($listeAccuses.$matricule)}accuseRecu {else}accuseNonRecu {/if}"
                        style="padding: 0.5em; float:left; width:120px;">
                        <img class="img-thumbnail" src="../photos/{$data.photo}.jpg" alt="{$matricule}" style="width: 50px" title="{$data.prenom} {$data.nom}">
                        <br>
                        <span class="discret">
                            {$data.prenom|truncate:2:'.'} {$data.nom|truncate:12:'...'}<br>{$listeAccuses.$matricule|default:'Non reçu'}
                        </span>
                    </div>
                    {/foreach}
                </div>
                {/if}

                {* présentation sous forme de liste (nombreux accusés) *}

            <table class="table table-condensed {if isset($portrait)}hidden{/if}" id="liste">
                <thead>
                    <tr>
                        <th>Classe</th>
                        <th>Nom &amp; Prenom</th>
                        <th style="width:8em">Lu le</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$listeEleves key=matricule item=data}
                    <tr class="{if isset($listeAccuses.$matricule)}accuseRecu {else}accuseNonRecu {/if}">
                        <td>{$data.classe}</td>
                        <td>{$data.nom} {$data.prenom}</td>
                        <td>{$listeAccuses.$matricule|default:'&nbsp;'}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>

        </div>
        <div class="modal-footer">
            <div class="btn-group btn-group-sm">
                {if isset($portrait)}
                <button type="button" class="btn btn-primary" data-mode="liste" id="voirListe">Voir en liste</button>
                {/if}
                <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
            </div>

        </div>
    </div>
</div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $("#voirListe").click(function(){
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
