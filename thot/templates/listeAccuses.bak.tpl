<div class="container">
{assign var=listeEleves value=$listeAccuses.eleves|default:Null}
{assign var=listeCours value=$listeAccuses.cours|default:Null}
{assign var=listeClasses value=$listeAccuses.classes|default:Null}
{assign var=listeNiveaux value=$listeAccuses.niveau|default:Null}
{assign var=listeEcole value=$listeAccuses.ecole|default:Null}

<div class="row">
    <ul class="nav nav-tabs">
      <li class="active" data-onglet="0"><a data-toggle="tab" href="#tabs-0">Élèves <span class="badge">{$listeEleves|count}</span></a></li>
      <li><a data-toggle="tab" href="#tabs-1">Cours <span class="badge">{$listeCours|count}</span></a></li>
      <li><a data-toggle="tab" href="#tabs-2">Classes <span class="badge">{$listeClasses|count}</span></a></li>
      <li><a data-toggle="tab" href="#tabs-3">Niveau <span class="badge">{$listeNiveaux|count}</span></a></li>
      <li><a data-toggle="tab" href="#tabs-4">École <span class="badge">{$listeEcole|count}</span></a></li>
    </ul>

    <div class="tab-content">
      <div id="tabs-0" class="tab-pane fade in active">
        <h3>Élèves</h3>
        {if $listeEleves|count > 0}
            <div class="table-responsive">
            <table class="table condensed">
                <thead>
                    <tr>
                        <th style="width:12em">Date de début</th>
                        <th style="width:12em">Date de fin</th>
                        <th>Objet</th>
                        <th style="width:20em">Destinataire</th>
                        <th style="width:2em">Vérifier</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$listeEleves key=id item=data}
                    <tr>
                        <td>{$data.dateDebut}</td>
                        <td>{$data.dateFin}</td>
                        <td>{$data.objet}</td>
                        <td>{if isset($data.nom)}
                                {$data.prenom} {$data.nom} - {$data.classe}
                                {else}
                                {$data.destinataire}
                            {/if}
                        </td>
                        <td>
                            <form class="microForm" method="POST" action="index.php" role="form">
                                <input type="hidden" name="id" value="{$data.id}">
                                <input type="hidden" class="onglet" name="onglet" value="{$onglet}">
                                <input type="hidden" name="action" value="{$action}">
                                <input type="hidden" name="mode" value="{$mode}">
                                <input type="hidden" name="etape" value="show">
                                <button type="submit" class="btn btn-sm btn-primary"><i class="fa fa-check text-success"></i></button>
                            </form>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>  <!--  table-responsive -->
        {else}
        <p>Aucun accusé de lecture demandé</p>
        {/if}
      </div>

      <div id="tabs-1" class="tab-pane fade">
        <h3>Cours</h3>
        {if $listeCours|count > 0}
        <div class="table-responsive">
            <table class="table condensed">
                <thead>
                    <tr>
                        <th style="width:12em">Date de début</th>
                        <th style="width:12em">Date de fin</th>
                        <th>Objet</th>
                        <th style="width:20em">Destinataire</th>
                        <th style="width:2em">Vérifier</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$listeCours key=id item=data}
                    <tr>
                        <td>{$data.dateDebut}</td>
                        <td>{$data.dateFin}</td>
                        <td>{$data.objet}</td>
                        <td>{$data.destinataire}</td>
                        <td>
                            <form class="microForm" method="POST" action="index.php" role="form">
                                <input type="hidden" name="id" value="{$data.id}">
                                <input type="hidden" class="onglet" name="onglet" value="{$onglet}">
                                <input type="hidden" name="action" value="{$action}">
                                <input type="hidden" name="mode" value="{$mode}">
                                <input type="hidden" name="etape" value="show">
                                <button type="submit" class="btn btn-sm btn-primary"><i class="fa fa-check text-success"></i></button>
                            </form>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>  <!-- table-responsive -->
        {else}
        <p>Aucun accusé de lecture demandé</p>
        {/if}
      </div>

      <div id="tabs-2" class="tab-pane fade">
        <h3>Classe</h3>
        {if $listeClasses|count > 0}
        <div class="table-responsive">
            <table class="table condensed">
                <thead>
                    <tr>
                        <th style="width:12em">Date de début</th>
                        <th style="width:12em">Date de fin</th>
                        <th>Objet</th>
                        <th style="width:20em">Destinataire</th>
                        <th style="width:2em">Vérifier</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$listeClasses key=id item=data}
                    <tr>
                        <td>{$data.dateDebut}</td>
                        <td>{$data.dateFin}</td>
                        <td>{$data.objet}</td>
                        <td>{$data.destinataire}</td>
                        <td>
                            <form class="microForm" method="POST" action="index.php" role="form">
                                <input type="hidden" name="id" value="{$data.id}">
                                <input type="hidden" class="onglet" name="onglet" value="{$onglet}">
                                <input type="hidden" name="action" value="{$action}">
                                <input type="hidden" name="mode" value="{$mode}">
                                <input type="hidden" name="etape" value="show">
                                <button type="submit" class="btn btn-sm btn-primary"><i class="fa fa-check text-success"></i></button>
                            </form>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>  <!-- table-responsive -->
        {else}
        <p>Aucun accusé de lecture demandé</p>
        {/if}
      </div>
      <div id="tabs-3" class="tab-pane fade">
        <h3>Niveau</h3>
        {if $listeNiveaux|count > 0}
        <div class="table-responsive">
            <table class="table condensed">
                <thead>
                    <tr>
                        <th style="width:12em">Date de début</th>
                        <th style="width:12em">Date de fin</th>
                        <th>Objet</th>
                        <th style="width:20em">Destinataire</th>
                        <th style="width:2em">Vérifier</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$listeNiveaux key=id item=data}
                    <tr>
                        <td>{$data.dateDebut}</td>
                        <td>{$data.dateFin}</td>
                        <td>{$data.objet}</td>
                        <td>{$data.destinataire}e années</td>
                        <td>
                            <form class="microForm" method="POST" action="index.php" role="form">
                                <input type="hidden" name="id" value="{$data.id}">
                                <input type="hidden" class="onglet" name="onglet" value="{$onglet}">
                                <input type="hidden" name="action" value="{$action}">
                                <input type="hidden" name="mode" value="{$mode}">
                                <input type="hidden" name="etape" value="show">
                                <button type="submit" class="btn btn-sm btn-primary"><i class="fa fa-check text-success"></i></button>
                            </form>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>  <!-- table-responsive -->
        {else}
        <p>Aucun accusé de lecture demandé</p>
        {/if}
      </div>
      <div id="tabs-4" class="tab-pane fade">
        <h3>École</h3>
        {if $listeEcole|count > 0}
        <div class="table-responsive">
            <table class="table condensed">
                <thead>
                    <tr>
                        <th style="width:12em">Date de début</th>
                        <th style="width:12em">Date de fin</th>
                        <th>Objet</th>
                        <th style="width:20em">Destinataire</th>
                        <th style="width:2em">Vérifier</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$listeEcole key=id item=data}
                    <tr>
                        <td>{$data.dateDebut}</td>
                        <td>{$data.dateFin}</td>
                        <td>{$data.objet}</td>
                        <td>{$data.destinataire}</td>
                        <td>
                            <form class="microForm" method="POST" action="index.php" role="form">
                                <input type="hidden" name="id" value="{$data.id}">
                                <input type="hidden" class="onglet" name="onglet" value="{$onglet}">
                                <input type="hidden" name="action" value="{$action}">
                                <input type="hidden" name="mode" value="{$mode}">
                                <input type="hidden" name="etape" value="show">
                                <button type="submit" class="btn btn-sm btn-primary"><i class="fa fa-check text-success"></i></button>
                            </form>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>  <!-- table-responsive -->
        {else}
        <p>Aucun accusé de lecture demandé</p>
        {/if}
      </div>
    </div>
</div>  <!-- row -->

</div>  <!-- container -->


<script type="text/javascript">

// quel est l'onglet actif?
var onglet = "{$onglet|default:0}";

// activer l'onglet dont le numéro a été passé
$(".nav-tabs li a[href='#tabs-"+onglet+"']").tab('show');

$(document).ready(function(){

    // si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet'
    $(".nav-tabs li a").click(function(){
        var ref=$(this).attr("href").split("-")[1];
        $(".onglet").val(ref);
        });

})

</script>
