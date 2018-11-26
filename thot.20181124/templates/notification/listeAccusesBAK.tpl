<div class="container">

    <h2>Gestion des accusés de lecture</h2>

    {assign var=listeEleves value=$listeAccuses.eleves|default:Null}
    {assign var=listeCours value=$listeAccuses.cours|default:Null}
    {assign var=listeClasses value=$listeAccuses.classes|default:Null}
    {assign var=listeNiveaux value=$listeAccuses.niveau|default:Null}
    {assign var=listeEcole value=$listeAccuses.ecole|default:Null}

    <ul class="nav nav-tabs">
        <li class="active" data-onglet="0"><a data-toggle="tab" href="#tabs-0">À un élève <span class="badge">{$listeEleves|count}</span></a></li>
        <li><a data-toggle="tab" href="#tabs-1">À un cours <span class="badge">{$listeCours|count}</span></a></li>
        <li><a data-toggle="tab" href="#tabs-2">À une classe <span class="badge">{$listeClasses|count}</span></a></li>
        {if ($userStatus == 'admin') || ($userStatus == 'direction')}
        <li><a data-toggle="tab" href="#tabs-3">À un niveau <span class="badge">{$listeNiveaux|count}</span></a></li>
        <li><a data-toggle="tab" href="#tabs-4">À l'ensemble des élèves <span class="badge">{$listeEcole|count}</span></a></li>
        {/if}
    </ul>

    <div class="tab-content">
        <div id="tabs-0" class="tab-pane fade in active">
            {if $listeEleves|count > 0}
            <div class="table-responsive">
                <table class="table condensed">
                    <thead>
                        <tr>
                            <th style="width:12em">Date de début</th>
                            <th style="width:12em">Date de fin</th>
                            <th>Objet</th>
                            <th style="width:20em">Destinataire</th>
                            <th>&nbsp;</th>
                            <th style="width:2em">Vérifier</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$listeEleves key=id item=data}
                        <tr class="trAccuses">
                            <td>{$data.dateDebut}</td>
                            <td>{$data.dateFin}</td>
                            <td>{$data.objet}</td>
                            <td>{if isset($data.nom)} {$data.prenom} {$data.nom} - {$data.classe} {else} {$data.destinataire} {/if}
                            </td>
                            <td>
                                {* <meter title="Cliquer pour voir le détail" data-container="body" value="{$statsAccuses.$id.confirme}" min="0" max=""></meter> *}
                                <span class="discret">{$statsAccuses.$id.confirme}</span>
                            </td>
                            <td>
                                <button type="button" class="btn btn-primary btn-sm showAccuse" data-id="{$data.id}">
                                    <i class="fa fa-check text-success"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <!--  table-responsive -->
            {else}
            <p>Aucun accusé de lecture demandé</p>
            {/if}
        </div>

        <div id="tabs-1" class="tab-pane fade">
            {if $listeCours|count > 0}
            <div class="table-responsive">
                <table class="table condensed">
                    <thead>
                        <tr>
                            <th style="width:12em">Date de début</th>
                            <th style="width:12em">Date de fin</th>
                            <th>Objet</th>
                            <th style="width:20em">Destinataire</th>
                            <th>&nbsp;</th>
                            <th style="width:2em">Vérifier</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$listeCours key=id item=data}
                        <tr class="trAccuses">
                            <td>{$data.dateDebut}</td>
                            <td>{$data.dateFin}</td>
                            <td>{$data.objet}</td>
                            <td>{$data.destinataire}</td>
                            <td>
                                {* <meter title="Cliquer pour voir le détail" data-container="body" value="{$statsAccuses.$id.confirme}" min="0" max=""></meter> *}
                                <span class="discret">{$statsAccuses.$id.confirme}</span>
                            </td>
                            <td>
                                <button type="button" class="btn btn-sm btn-primary showAccuse" data-id="{$data.id}">
                                    <i class="fa fa-check text-success"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <!-- table-responsive -->
            {else}
            <p>Aucun accusé de lecture demandé</p>
            {/if}
        </div>

        <div id="tabs-2" class="tab-pane fade">
            {if $listeClasses|count > 0}
            <div class="table-responsive">
                <table class="table condensed">
                    <thead>
                        <tr>
                            <th style="width:12em">Date de début</th>
                            <th style="width:12em">Date de fin</th>
                            <th>Objet</th>
                            <th style="width:20em">Destinataire</th>
                            <th>&nbsp;</th>
                            <th style="width:2em">Vérifier</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$listeClasses key=id item=data}
                        <tr class="trAccuses">
                            <td>{$data.dateDebut}</td>
                            <td>{$data.dateFin}</td>
                            <td>{$data.objet}</td>
                            <td>{$data.destinataire}</td>
                            <td>
                                {* <meter title="Cliquer pour voir le détail" data-container="body" value="{$statsAccuses.$id.confirme}" min="0" max=""></meter> *}
                                <span class="discret">{$statsAccuses.$id.confirme}</span>
                            </td>
                            <td>
                                <button type="button" class="btn btn-sm btn-primary showAccuse" data-id="{$data.id}">
                                    <i class="fa fa-check text-success"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <!-- table-responsive -->
            {else}
            <p>Aucun accusé de lecture demandé</p>
            {/if}
        </div>
        <div id="tabs-3" class="tab-pane fade">
            {if $listeNiveaux|count > 0}
            <div class="table-responsive">
                <table class="table condensed">
                    <thead>
                        <tr>
                            <th style="width:12em">Date de début</th>
                            <th style="width:12em">Date de fin</th>
                            <th>Objet</th>
                            <th style="width:20em">Destinataire</th>
                            <th>&nbsp;</th>
                            <th style="width:2em">Vérifier</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$listeNiveaux key=id item=data}
                        <tr class="trAccuses">
                            <td>{$data.dateDebut}</td>
                            <td>{$data.dateFin}</td>
                            <td>{$data.objet}</td>
                            <td>{$data.destinataire}e années</td>
                            <td>
                                {* <meter title="Cliquer pour voir le détail" data-container="body" value="{$statsAccuses.$id.confirme}" min="0" max=""></meter> *}
                                <span class="discret">{$statsAccuses.$id.confirme}</span>
                            </td>
                            <td>
                                <button type="button" class="btn btn-sm btn-primary showAccuse" data-id="{$data.id}">
                                    <i class="fa fa-check text-success"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <!-- table-responsive -->
            {else}
            <p>Aucun accusé de lecture demandé</p>
            {/if}
        </div>
        <div id="tabs-4" class="tab-pane fade">
            {if $listeEcole|count > 0}
            <div class="table-responsive">
                <table class="table condensed">
                    <thead>
                        <tr>
                            <th style="width:12em">Date de début</th>
                            <th style="width:12em">Date de fin</th>
                            <th>Objet</th>
                            <th style="width:20em">Destinataire</th>
                            <th>&nbsp;</th>
                            <th style="width:2em">Vérifier</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$listeEcole key=id item=data}
                        <tr class="trAccuses">
                            <td>{$data.dateDebut}</td>
                            <td>{$data.dateFin}</td>
                            <td>{$data.objet}</td>
                            <td>{$data.destinataire}</td>
                            <td>
                                {* <meter title="Cliquer pour voir le détail" data-container="body" value="{$statsAccuses.$id.confirme}" min="0" max=""></meter> *}
                                <span class="discret">{$statsAccuses.$id.confirme}</span>
                            </td>
                            <td>
                                <button type="button" class="btn btn-sm btn-primary showAccuse" data-id="{$data.id}">
                                    <i class="fa fa-check text-success"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <!-- table-responsive -->
            {else}
            <p>Aucun accusé de lecture demandé</p>
            {/if}
        </div>
    </div>

</div>
<!-- container -->

<div id="modal">

</div>


<script type="text/javascript">
    // quel est l'onglet actif?
    var onglet = "{$onglet|default:0}";

    // activer l'onglet dont le numéro a été passé
    $(".nav-tabs li a[href='#tabs-" + onglet + "']").tab('show');

    $(document).ready(function() {

        $(".showAccuse").click(function() {
            var id = $(this).data('id');
            $(".trAccuses").removeClass('selected');
            $(this).closest('tr').addClass('selected');
            $.post('inc/notif/showAccuses.inc.php', {
                    id: id
                },
                function(resultat) {
                    $("#modal").html(resultat);
                    $("#modalAccuses").modal('show');
                });
        })

        // si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet'
        $(".nav-tabs li a").click(function() {
            var ref = $(this).attr("href").split("-")[1];
            $(".onglet").val(ref);
        });

    })
</script>
