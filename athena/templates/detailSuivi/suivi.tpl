<table class="table table-condensed">

    <thead>
        <tr>
            <th style="width:1em">&nbsp;</th>
            <th>Propr.</th>
            <th>Abs</th>
            <th>Envoyé par</th>
            <th>Date</th>
            <th>Heure</th>
            <th syle="width:15%">Motif</th>
            <th syle="width:15%">Traitement</th>
            <th syle="width:15%">À suivre</th>
            <th style="width: 2em"><i class="fa fa-book" title="Mention au JDC"></th>
            <th style="width:1em">&nbsp;</th>
        </tr>
    </thead>

    <tbody>
        {foreach from=$listeSuivi item=unItem}
        <tr>
            <td data-id="{$unItem.id}">
                {if $unItem.proprietaire == $acronyme}
                <form action="index.php" method="POST" role="form" class="form-inline microform">
                    <input type="hidden" name="id" value="{$unItem.id}">
                    <input type="hidden" name="matricule" value="{$eleve.matricule}">
                    <input type="hidden" name="classe" value="{$eleve.classe}">
                    <input type="hidden" name="action" value="{$action}">
                    <input type="hidden" name="mode" value="edit">
                    <button class="btn btn-default btn-sm" type="submit" title="Modifier cette ligne"><i class="fa fa-pencil"></i></button>
                </form>
                {/if}
            </td>
            {assign var=id value=$unItem.id}
            <td>{$listeSuivi.$id.proprietaire}</td>
            <td>{if $unItem.absent == 1}<i class="fa fa-question <fa-lg></fa-lg> text-danger" title="Ne s'est pas présenté"></i>{else}-{/if}</td>
            {assign var=leProf value=$unItem.envoyePar}
            <td>
                {if isset($listeProfs.$leProf)}
                    {$listeProfs.$leProf.prenom|truncate:2:'.'} {$listeProfs.$leProf.nom}
                {else}
                    {$leProf} (?)
                {/if}</td>
            <td data-date="{$unItem.date}">{$unItem.date}</td>
            <td data-heure="{$unItem.heure}">{$unItem.heure}</td>
            <td data-motif="{$unItem.motif}"
                class="popover-eleve"
    			data-original-title="Suivi par {$unItem.proprietaire}"
    			data-container="body"
    			data-html="true"
    			data-placement="left"
    			data-content="{$unItem.motif|truncate:500}">
                {$unItem.motif|truncate:35}
            </td>
            <td data-traitement="{$unItem.traitement}"
                class="popover-eleve{if ($unItem.prive == 1)} confidentiel{/if}"
    			data-original-title="Suivi par {$unItem.proprietaire}"
    			data-container="body"
    			data-html="true"
    			data-placement="left"
    			data-content="
                    {if ($unItem.prive == 1) && ($acronyme != $unItem.proprietaire)}
                        <i class='fa fa-user-secret'></i> Confidentiel
                    {else}
                        {$unItem.traitement|truncate:500}
                    {/if}">
                    {if ($unItem.prive == 1)}<i class="fa fa-user-secret"></i>{/if}
                    {if ($unItem.prive == 1) && ($acronyme != $unItem.proprietaire)}
                        Confidentiel
                    {else}
                        {$unItem.traitement|truncate:35}
                    {/if}
                </td>
            <td data-asuivre="{$unItem.aSuivre}"
                class="popover-eleve"
    			data-original-title="Suivi par {$unItem.proprietaire}"
    			data-container="body"
    			data-html="true"
    			data-placement="left"
    			data-content="{$unItem.aSuivre|truncate:500}">
                {$unItem.aSuivre|truncate:35}
            </td>
            <td>
				{if $unItem.jdc == 1}<i class="fa fa-book" style="color:green;" title="Mention au JDC"></i>{else}&nbsp;{/if}
            </td>
            <td>
                {if $unItem.proprietaire == $acronyme}
                <button title="Supprimer cette ligne" class="btn btn-default btn-sm btn-delete" type="button"><i class="fa fa-times text-danger delete" data-id="{$unItem.id}"></i></button>
                {/if}
            </td>
        </tr>
        {/foreach}
    </tbody>
</table>


<div id="modalDel" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header bg-danger">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <div class="modal-title"><h3>Veuillez confirmer la suppression</h3></div>
      </div>
      <div class="modal-body">
        <h4>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h4>
        <p><strong>Date: </strong> <span id="spDate"></span></p>
        <p><strong>Heure:</strong> <span id="spHeure"></span></p>
        <strong>Motif:</strong><br>
        <span id="spMotif"></span>
        <br>
        <strong>Travail effectué:</strong><br>
        <span id="spTraitement"></span>
        <br>
        <strong>À suivre:</strong><br>
        <span id="spAsuivre"></span>
      </div>
      <div class="modal-footer">
        <form action="index.php" method="POST" role="form" class="form-inline">
            <input type="hidden" name="action" value="{$action}">
            <input type="hidden" name="mode" value="delete">
            <input type="hidden" name="matricule" id="matriculeSuivi" value="{$eleve.matricule}">
            <input type="hidden" name="id" id="id" value="">
            <div class="btn-group pull-right">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="submit" class="btn btn-primary">Confirmer</button>
            </div>
            <div class="clearfix"></div>
        </form>
      </div>
    </div>

  </div>
</div>


<script type="text/javascript">

function ellipse (texte, longueur) {
    var txt = texte.substr(0,longueur);
    if (texte.length > longueur)
        return txt+'...';
        else return txt;
    }

$(document).ready(function(){

	$(".popover-eleve").mouseover(function(){
		$(this).popover('show');
		})
	$(".popover-eleve").mouseout(function(){
		$(this).popover('hide');
		})

    $(".btn-delete").click(function(){
        var parent = $(this).closest('tr');
        var id = parent.find('td[data-id]').data('id');
        var date = parent.find('td[data-date]').data('date');
        var heure = parent.find('td[data-heure]').data('heure');
        var motif = ellipse(parent.find('td[data-motif]').data('motif'),100);
        var traitement = ellipse(parent.find('td[data-traitement]').data('traitement'),100);
        var aSuivre = ellipse(parent.find('td[data-asuivre]').data('asuivre'),100);

        $("#spDate").text(date);
        $("#spHeure").text(heure);
        $("#spMotif").text(motif)
        $("#spTraitement").text(traitement);
        $("#spAsuivre").text(aSuivre);
        $("#id").val(id);

        $('#modalDel').modal('show');

    })

})

</script>
