<div class="row">

<div class="col-md-6 col-sm-12">

    <div class="panel panel-primary">
        <div class="panel-heading">
            Identification
        </div>

        <div class="panel-body">
            <p>Nom: <strong>{$eleve.nom}</strong> Prénom: <strong>{$eleve.prenom}</strong>
                <img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="img-responsive ombre" style="float:left; width:75px; margin-right:2em;"></p>
            <p>Classe: <strong>{$eleve.classe}</strong> Titulaire(s): <strong>{$titulaires|implode:', '}</strong></p>
            <p>Sexe: <strong>{$eleve.sexe}</strong> Âge: <strong>{$eleve.age.Y} ans {$eleve.age.m} mois et {$eleve.age.d} jours</strong></p>
        </div>

    </div>

    <div class="panel panel-info">
        <div class="panel-heading">
            Mentions
        </div>
        <div class="panel-body">
            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>Année scolaire</th>
                        <th>
                            <button type="button"
                                class="btn btn-success btn-xs"
                                title="Voir toutes les années"
                                id="btn-showAll"><i class="fa fa-arrow-down"></i>
                            </button> Année</th>
                        {foreach from=range(1, $maxPeriodes) key=wtf item=periode}
                        <th>Période</th>
                        <th>Mention</th>
                        {/foreach}
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$mentions.$matricule key=anScol item=data name=boucle}
                    <tr {if $smarty.foreach.boucle.last != $smarty.foreach.boucle.iteration}style="display:none" class="resultatsScolaires"{/if}>
                        <td>{$anScol}</td>
                        {foreach from=$data key=annee item=lesMentions}
                            <td>{$annee}e</td>
                        {/foreach}
                        {foreach from=$lesMentions key=periode item=laMention}
                            <td>{$periode}</td>
                            <td><strong>{$laMention}</strong></td>
                        {/foreach}
                    </tr>
                    {/foreach}
                </tbody>
            </table>

        </div>
    </div>
</div>


<div class="col-md-6 col-sm-12">

    {assign var=idProprio value=$padsEleve.proprio|key}

    {* s'il n'y a pas de pad "guest", il ne faut pas montrer des onglets *}
    {if $padsEleve.guest|count > 0}
    <ul class="nav nav-tabs">
        <li class="active"><a href="#tab{$idProprio}" data-toggle="tab">{$padsEleve.proprio.$idProprio.proprio}</a></li>
        {foreach from=$padsEleve.guest key=id item=unPad}
        <li><a href="#tab{$id}" data-toggle="tab">{$unPad.proprio}
            {if $unPad.mode == 'rw'}<img src="images/padIco.png" alt=";o)">{/if}
            </a></li>
        {/foreach}
    </ul>
    {/if}

    <div class="tab-content">
        <div class="tab-pane active" id="tab{$idProprio}">
            <textarea
                name="texte_{$idProprio}"
                id="texte_{$idProprio}"
                rows="20"
                class="summernote form-control"
                placeholder="Frappez votre texte ici"
                >{$padsEleve.proprio.$idProprio.texte}</textarea>
        </div>

        {foreach from=$padsEleve.guest key=id item=unPad}
        <div class="tab-pane" id="tab{$id}">
            <textarea
                name="texte_{$id}"
                id="texte_{$id}"
                data-anscol="{$anScol}"
                rows="20"
                class="summernote form-control"
                placeholder="Frappez votre texte ici"
                autofocus="true"
                {if $unPad.mode !='rw' } disabled="disabled" {/if}
                >{$unPad.texte}</textarea>
        </div>
        {/foreach}

    </div>

</div>

</div>
<div class="clearfix"></div>

{* ---------------------------------------------------------------------- *}

<ul class="nav nav-tabs" data-tabs="tabs">
    {foreach from=$tabsAnsPeriodes key=wtf item=anPeriode name=boucle}
        {assign var=anScol value=$anPeriode.anScol}
        {assign var=periode value=$anPeriode.periode}
        <li class="{if $smarty.foreach.boucle.last} active{/if}">
            <a data-toggle="tab"
                href="#{$anScol}_{$periode}"
                data-anscol="{$anScol}" data-periode="{$periode}">
                <small>{$anScol} [{$periode}]</small>
            </a>
        </li>
    {/foreach}
    <li>
        <a href="javascript:void(0)" id="btn-plusPeriode">&nbsp;<i class="fa fa-plus"></i>&nbsp;</a>
    </li>
</ul>

<div class="tab-content">

    {foreach from=$tabsAnsPeriodes key=wtf item=anPeriode name=boucle}
        {assign var=anScol value=$anPeriode.anScol}
        {assign var=periode value=$anPeriode.periode}

            <!-- le dernier onglet est actif -->
            <div class="tab-pane {if $smarty.foreach.boucle.last}in active{/if}"
            id="{$anScol}_{$periode}"
            data-anscol="{$anScol}"
            data-periode="{$periode}">

                <form id="padEleve{$anScol}_{$periode}"
                    class="form-horizontal"
                    style="background-color: #ccf"
                    data-matricule="{$matricule}">

                <h2>
                    Période {$anScol} {$periode}
                    {if $anScol == $ANNEESCOLAIRE}
                    <button type="button"
                        class="btn btn-danger btn-save btn-lg pull-right"
                        data-anscol="{$anScol}"
                        data-periode="{$periode}">
                        Enregistrer cette page ({$anScol} {$periode})
                    </button>
                    {/if}
                </h2>

    				<input type="hidden" name="matricule" id="matricule" value="{$eleve.matricule}">

    				<div class="col-md-6 col-sm-12">
    					<div class="panel panel-info">
    						<div class="panel-heading">
    							Poursuite de parcours
    						</div>
    						<div class="panel-body">
    							<div class="col-xs-2">
    								<label class="checkbox-inline">
                                        <input type="checkbox"
                                            data-anscol="{$anScol}"
                                            name="cbMeritant"
                                            value="1"
                                            {if $suivi4pad.$anScol.$periode.pp1|default:0 == 1}checked{/if}
                                            {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                                        Méritant
                                    </label>
    							</div>
    							<div class="col-xs-10">
    								<input type="text"
                                    data-anscol="{$anScol}"
                                    class="form-control"
                                    name="meritant"
                                    value="{$suivi4pad.$anScol.$periode.ppa|default:''}" placeholder="Texte libre"
                                    {if $anScol != $ANNEESCOLAIRE} readonly{/if}>
    							</div>
    							<div class="col-xs-2">
    								<label class="checkbox-inline">
                                        <input type="checkbox"
                                        data-anscol="{$anScol}"
                                        name="cbFacilite"
                                        value="1"
                                        {if $suivi4pad.$anScol.$periode.pp2|default:0 == 1}checked{/if}
                                        {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                                    Grandes facilités</label>
    							</div>
    							<div class="col-xs-10">
    								<input type="text"
                                        data-anscol="{$anScol}"
                                        class="form-control"
                                        name="facilite"
                                        value="{$suivi4pad.$anScol.$periode.ppb|default:''}" placeholder="Texte libre"
                                        {if $anScol != $ANNEESCOLAIRE} readonly{/if}>
    							</div>
    						</div>
    					</div>

    					<div class="panel panel-success">
    						<div class="panel-heading">
    							Forces et faiblesses
    						</div>
    						<div class="panel-body">

    							<div class="col-xs-6">
    								<div class="form-group">
    								  <label for="justification">Justification</label><br>
    								  <textarea name="justification"
                                        id="justification"
                                        class="form-control"
                                        data-anscol="{$anScol}"
                                        rows="2" cols="80"
                                        {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                        placeholder="Votre texte ici">{$suivi4pad.$anScol.$periode.ff1|default:''}</textarea>
    								</div>
    							</div>

    							<div class="col-xs-6">
    								<div class="form-group">
    								  <label for="remediation">Remédiation</label><br>
    								  <textarea name="remediation"
                                        id="remediation"
                                        data-anscol="{$anScol}"
                                        class="form-control"
                                        rows="2" cols="80"
                                        {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                        placeholder="Votre texte ici">{$suivi4pad.$anScol.$periode.ff2|default:''}</textarea>
    								</div>
    							</div>

    						</div>

    					</div>

    					<div class="panel panel-warning">
    						<div class="panel-heading">
    							Projet d'orientation
    						</div>
    						<div class="panel-body">
    							<div class="row">
    								<div class="col-xs-6">
    									<label for="orientationInterne" class="control-label">Interne</label>
    									<input type="text"
                                            name="orientationInterne"
                                            id="orientationInterne"
                                            data-anscol="{$anScol}"
                                            class="form-control"
                                            {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                            value="{$suivi4pad.$anScol.$periode.poInterne|default:''}" placeholder="Votre texte ici">
    								</div>
    								<div class="col-xs-6">
    									<label for="orientationExterne" class="control-label">Externe</label>
    									<input type="text"
                                            name="orientationExterne"
                                            id="orientationExterne"
                                            data-anscol="{$anScol}"
                                            class="form-control"
                                            {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                            value="{$suivi4pad.$anScol.$periode.poExterne|default:''}" placeholder="Votre texte ici">
    								</div>
    							</div>

    						</div>

    					</div>

    					<div class="panel panel-info">
    						<div class="panel-heading">
    							Interventions demandées
    						</div>
    						<div class="panel-body">
    							<div class="col-xs-4">
    								<div class="checkbox">
    									<label><input type="checkbox"
                                                value="1"
                                                name="intervention1"
                                                {if $suivi4pad.$anScol.$periode.id1|default:0 == 1}checked{/if}
                                                {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                                            CAI
                                        </label>
    								</div>

    								<div class="checkbox">
    									<label><input type="checkbox"
                                            value="1"
                                            name="intervention2"
                                            {if $suivi4pad.$anScol.$periode.id2|default:0 == 1}checked{/if}
                                            {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                                            PMS
                                        </label>
    								</div>

    								<div class="checkbox">
    									<label><input type="checkbox"
                                            value="1"
                                            name="intervention3"
                                            {if $suivi4pad.$anScol.$periode.id3|default:0 == 1}checked{/if}
                                            {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                                            SCHOLA
                                        </label>
    								</div>

    								<div class="checkbox">
    									<label><input type="checkbox"
                                            value="1"
                                            name="intervention4"
                                            {if $suivi4pad.$anScol.$periode.id4|default:0 == 1}checked{/if}
                                            {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                                            Autre
                                        </label>
    								</div>
    							</div>

    							<div class="col-xs-8">
    								<textarea
                                        name="intervention"
                                        class="form-control"
                                        data-anscol="{$anScol}"
                                        rows="4"
                                        {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                        placeholder="Votre texte ici">{$suivi4pad.$anScol.$periode.idTexte|default:''}</textarea>
    							</div>

    						</div>

    					</div>


    					<div class="panel panel-danger">
    						<div class="panel-heading">
    							Discipline
    						</div>
    						<div class="panel-body">
    							<textarea name="discipline"
                                    id="discipline"
                                    data-anscol="{$anScol}"
                                    class="form-control"
                                    rows="2" cols="80"
                                    {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                    placeholder="Votre texte ici">{$suivi4pad.$anScol.$periode.discipline|default:''}</textarea>
    						</div>
    					</div>


    				</div>

    				<div class="col-md-6 col-sm-12">

    					<div class="panel panel-success">
    						<div class="panel-heading">
    							Matières
                                {if $anScol == $ANNEESCOLAIRE}
    							<button type="button"
                                    class="btn btn-success btn-sm addMatiere"
                                    data-matricule="{$eleve.matricule}"
                                    data-anscol="{$anScol}"
                                    data-periode="{$periode}">
                                    Ajouter une matière
                                </button>
                                {/if}
    						</div>
    						<div class="panel-body listeMatieres_{$anScol}_{$periode}">
                                {include file="direction/listeMatieres.tpl"}
    						</div>

    					</div>

    					<div class="panel panel-success">
    						<div class="panel-heading">
    							Prise en charge
    						</div>
    						<div class="panel-body">
    							<textarea name="prEnCharge"
                                    class="form-control"
                                    data-anscol="{$anScol}"
                                    rows="2" cols="80"
                                    {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                                    placeholder="Votre texte ici">{$suivi4pad.$anScol.$periode.priseEnCharge|default:''}</textarea>
    						</div>
    					</div>

    				</div>

                    <input type="hidden" name="matricule" value="{$matricule}">
                    <input type="hidden" name="anScol" value="{$anScol}">
                    <input type="hidden" name="periode" value="{$periode}">

                    <div class="clearfix"></div>

                </form>

            </div>

    {/foreach}

</div> <!-- 1 -->



<div id="modalListeCours" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalListeCours" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalListeCours">Liste des cours</h4>
      </div>
      <div class="modal-body">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary pull-right" id="btn-modalCours" data-matricule="{$eleve.matricule}">Sélectionner</button>
      </div>
    </div>
  </div>
</div>



<div id="modalAddPeriode" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddPeriodeLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddPeriodeLabel">Ajout d'une période</h4>
      </div>
      <div class="modal-body">
          <form id="formAddPeriode">

            <div class="col-xs-6">
                <div class="form-group">
                    <label for="anScol">Année scolaire</label>
                    <input type="text" class="form-control" name="anScol" id="modalAnScol" value="{$ANNEESCOLAIRE}" readonly>
                </div>
            </div>

            <div class="col-xs-6">
                <div class="form-group">
                    <label for="periode">Nouvelle période</label>
                    <select class="form-control" name="periode" id="modalPeriode" required>
                        <option value="">Période à créer</option>
                        {foreach from=$listePeriodes key=n item=periode}
                        <option value="{$periode}">[{$periode}] {$NOMSPERIODES.$n|default:'Période inconnue'}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="clearfix"></div>
        </form>
      </div>
      <div class="modal-footer">
        <buttton type="button" class="btn btn-primary" id="savePeriodeAdd">Ajouter cette période</button>

      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

	var modifie = false;

	$(document).ready(function(){

        $('input:text, textarea').attr('maxlength', 128);

        $('#formAddPeriode').validate();

        $('#btn-showAll').click(function(){
            $('.resultatsScolaires').toggle();
        })

        $('#savePeriodeAdd').click(function(){
            if ($('#formAddPeriode').valid()) {
                var newPeriode = $('#modalPeriode').val();
                var newAnScol = $('#modalAnScol').val();
                var matricule = $('#modalMatricule').val();
                $.post('inc/direction/addPeriode.inc.php', {
                    anScol: newAnScol,
                    periode: newPeriode
                }, function(resultat){
                    bootbox.alert({
                        title: 'Enregistrement',
                        message: resultat + ' nouvelle période créée'
                    })
                    $('#modalAddPeriode').modal('hide');
                    if (resultat == 1)
                        location.reload();
                })
            }
        })

        $('.btn-save').click(function(){
            var anScol = $(this).data('anscol');
            var periode = $(this).data('periode');
            var formulaire = $(this).closest('form').serialize();
            // enregistrement de l'ensemble du formulaire: général + matières
            $.post('inc/direction/saveFichePad.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                // enregistrement des ckEditors
                var texte;
                var disabled;
                var matricule = $('#matricule').val();
                for (var instanceName in CKEDITOR.instances){
                    disabled = $('#' + instanceName).attr('disabled');
                    if (disabled != 'disabled') {
                        // si "disabled", ne pas enregistrer
                        texte = CKEDITOR.instances[instanceName].getData();
                        $.post('inc/direction/savePadEleve.inc.php', {
                            instanceName: instanceName,
                            matricule: matricule,
                            texte: texte
                        }, function(nb){
                            $('.nav-tabs li a').find('i').remove();
                            modifie = false;
                            $(window).unbind('beforeunload');
                            bootbox.alert({
                                title: 'Enregistrement',
                                message: parseInt(resultat) + parseInt(nb) + " modification(s) apportée(s)"
                            })
                            })
                        }
                    }
                // raffraichissement des matières
                $.post('inc/direction/refreshListeMatieres.inc.php', {
                    matricule: matricule,
                    anScol: anScol,
                    periode: periode
                }, function(resultat){
                    $('.listeMatieres_' + anScol + '_' + periode).html(resultat);
                })
                }
            )
        })

		$('.addMatiere').click(function(){
			var matricule = $(this).closest('form').data('matricule');
			var anScol = $(this).data('anscol');
			var periode = $(this).data('periode');
            $('#btn-modalCours').data('anscol', anScol);
            $('#btn-modalCours').data('periode', periode);
			$.post('inc/direction/addMatiere.inc.php', {
				matricule: matricule,
				anScol: anScol,
				periode: periode
			}, function(resultat){
				$('#modalListeCours .modal-body').html(resultat);
				$('#modalListeCours').modal('show');
			})
		})

		$('#btn-modalCours').click(function(){
			var formulaire = $('#formListeCours').serialize();
			var matricule = $(this).data('matricule');
            var anScol = $(this).data('anscol');
            var periode = $(this).data('periode');
			$.post('inc/direction/setListeMatieres.inc.php', {
				formulaire: formulaire,
				matricule: matricule,
                anScol: anScol,
                periode: periode
			}, function(resultat){
                if(resultat != '') {
                    $('.listeMatieres' + '_' + anScol + '_' + periode).html(resultat);
                }
				$('#modalListeCours').modal('hide');
			})
		})

        $('#btn-plusPeriode').click(function(){
            $('#modalAddPeriode').modal('show');
        })

        function modification() {
			if (!(modifie)) {
				modifie = true;
                $(window).bind('beforeunload', function() {
					var reponse = confirm();
                    $('#wait').hide();
					return reponse
				})
			}
		}

		$("textarea, input:text").keyup(function(e) {
			var readonly = $(this).attr("readonly");
			if (!(readonly)) {
				var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
				if ((key > 31) || (key == 8)) {
					modification();
				}
			}
		})

        $('input:checkbox').click(function(e) {
            var readonly = $(this).attr("readonly");
            if (!(readonly)) {
                modification();
                var anScol = $(this).closest('.tab-pane').data('anscol');
                var periode = $(this).closest('.tab-pane').data('periode');
                $('.nav-tabs li a[data-periode="' + periode + '"][data-anscol="' + anScol +'"]').find('i').remove('i');
                $('.nav-tabs li a[data-periode="' + periode +'"][data-anscol="' + anScol + '"]').not('i').append('<i class="fa fa-floppy-o fa-lg" style="color:red"></i>');

            }
        })

		// le copier/coller provoque aussi  une "modification"
		$("input, textarea").bind('paste', function() {
			modification()
		});


	})

</script>
