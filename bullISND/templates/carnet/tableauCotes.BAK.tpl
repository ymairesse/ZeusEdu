<div class="container">

<h2>Carnet de cotes de {$coursGrp} Période {$bulletin}</h2>

<div id="barreOutils" class="noprint">

	<a type="button" class="btn btn-primary pull-left" href="index.php?action=carnet&amp;mode=oneClick">Bulletin one click <i class="fa fa-thumbs-o-up fa-lg"></i></a>

	<button type="button" class="btn btn-primary" id="pdf" title="Enregistrer en PDF">PDF <i class="fa fa-file-pdf-o fa-lg" style="color:red"></i></button>

	<div class="btn-group pull-right">
		<button class="btn btn-primary" id="boutonPlus"><i class="fa fa-plus fa-lg"></i> Ajouter une cote</button>
		<button type="button" id="enregistrer" class="btn btn-primary disabled"><i class="fa fa-floppy-o fa-lg"></i> Enregistrer</button>
		<button type="button" id="btn-reset" class="btn btn-default disabled"><i class="fa fa-times"></i> Annuler</button>
	</div>

</div>


<form name="cotes" id="formCotes">

	<div class="table-responsive">

		<span class="smallNotice pull-right">Double clic dans les cotes ou sur le chapeau pour modifier, clic sur l'entête de colonne pour modifier/supprimer une évaluation</span>

		<table class="table table-hover" id="carnet">
			<thead>

			<tr>
				<th width="20">&nbsp;</th>
				<th>&nbsp;</th>
				{assign var=counter value=1}
				{foreach from=$listeTravaux key=idCarnet item=travail}
					{assign var=idComp value=$travail.idComp}
				<th id="idCarnet{$idCarnet}"
					data-idcarnet = "{$idCarnet}"
					style="width:4em; cursor:pointer"
					class="enteteCote {$travail.formCert}"
					data-toggle="popover"
					data-original-title="Choisir une action"
					data-content="<div class='btn-group-vertical'>
						<button type='button' class='btn btn-danger boutonSuppr' data-idcarnet='{$idCarnet}'>Supprimer cette évaluation</button>
						<button type='button' class='btn btn-info boutonEdit' data-idcarnet='{$idCarnet}'>Modifier l'évaluation</button>
						<button type='button' class='btn btn-primary boutonEncoder' data-idcarnet='{$idCarnet}'>Encoder les cotes</button>
					</div>"
					data-html="true"
					data-container="body"
					data-placement="left"
					data-date="{$travail.date}"
					data-libelle="{$travail.libelle}"
					data-competence="{$listeCompetences.$idComp.libelle}"
					data-max="{$travail.max}">
				[ {$counter++} ]
				</th>
				{/foreach}
			</tr>

			<tr>
				<th>Classe</th>
				<th>Nom</th>
				{assign var=counter value=1}
				{foreach from=$listeTravaux key=idCarnet item=travail}
					{assign var=idComp value=$travail.idComp}
				<th data-idcarnet="{$idCarnet}"
					style="width:4em"
					class="pop detailsCote {$travail.formCert}"
					data-content="Libellé: {$travail.libelle}<br>
								Remarque: {$travail.remarque}<br>
								Neutralisé: <strong>{if $travail.neutralise == 1}Oui{else}Non{/if}</strong><br>
								Form/Cert: {if $travail.formCert == 'cert'}Certificatif{else}Formatif{/if}<br>
								Max: <strong>{$travail.max}</strong><br>
								Publié sur Thot: <strong>{if $travail.publie == 1}Oui{else}Non{/if}</strong>"
					data-html="true"
					data-container="body"
					data-placement="left"
					data-original-title="C{$travail.ordre} {$listeCompetences.$idComp.libelle}">
					{$travail.date|substr:0:5}<br>
					<span class="micro">C{$travail.ordre}</span> / <strong>{$travail.max}</strong>
					{if $travail.publie == 1}<img src="images/thotIco.png" alt="Thot">{/if}
                    <input type="hidden" name="max{$idCarnet}" value="{$travail.max}">
				</th>
				{/foreach}
			</tr>
			</thead>

			<tbody>
			{assign var=tabIndex value=1}
			{assign var=nbEleves value=$listeEleves|@count}
			{assign var=nbTravaux value=$listeTravaux|@count}
			{foreach from=$listeEleves key=matricule item=unEleve}
			<tr>
			<td>{$unEleve.classe}</td>
			{assign var=nomPrenom value=$unEleve.nom|cat:' '|cat:$unEleve.prenom}
			<td	style="cursor:pointer"
				class="pop"
				data-content="<img src='../photos/{$unEleve.photo}.jpg' alt='{$matricule}' style='width:100px'><br><span class='micro'>{$matricule}</span>"
				data-html="true"
				data-placement="top"
				data-container="body"
				data-original-title="{$nomPrenom|truncate:15}">
			{$nomPrenom}
			</td>

			{foreach from=$listeTravaux key=idCarnet item=travail}
				{assign var=couleur value=$travail.idComp|substr:-1}
				<td class="{$travail.formCert} couleur{$couleur}
					{if (isset($listeCotes.$matricule.$idCarnet)) && $listeCotes.$matricule.$idCarnet.echec} echec{/if} cote"
					title="{$nomPrenom}"
					data-original-title="{$nomPrenom}"
					data-placement="right"
					data-container="body"
                    data-idcarnet="{$idCarnet}">
					<input type="text" name="cote-{$idCarnet}_eleve-{$matricule}"
						tabIndex="{$tabIndex}"
						class="coteCarnet form-control-sm hidden"
						value="{$listeCotes.$matricule.$idCarnet.cote|default:''}"
						disabled>

					<span class="{if (isset($listeCotes.$matricule.$idCarnet)) && $listeCotes.$matricule.$idCarnet.erreurEncodage} erreurEncodage{/if}">
						{$listeCotes.$matricule.$idCarnet.cote|default:'&nbsp;'}
					</span>

					{assign var=tabIndex value=$tabIndex+$nbEleves}
				</td>
			{/foreach}
			{assign var=tabIndex value=$tabIndex-($nbTravaux*$nbEleves)+1}
			</tr>
			{/foreach}
			<tr>
				<th style="text-align:right; padding-right:1em" colspan="2">Moyennes</th>
				{foreach from=$listeTravaux key=idCarnet item=travail}
					<th class="{$travail.formCert}"><strong>
						{if $listeMoyennes}
						{$listeMoyennes.$idCarnet|@round:1|default:'&nbsp;'}
						{else}
						&nbsp;
						{/if}</strong></th>
				{/foreach}
			</tr>
			</tbody>
		</table>

		</div>  <!-- table-responsive -->

	<p class="notice noprint">
		Mentions admises<br>
		Mentions neutres: <strong>{$COTEABS}</strong> | Mentions valant pour "0": <strong>{$COTENULLE}</strong>
	</p>

    <input type="hidden" name="coursGrp" value="{$coursGrp}">
    <input type="hidden" name="bulletin" value="{$bulletin}">

	</form>

	<ol>
	{foreach from=$listeTravaux key=idCarnet item=travail}
	{assign var=idComp value=$travail.idComp}
		<li>{$travail.date|substr:0:5}: {$travail.libelle|truncate:50:'...'} {$travail.formCert} <strong>/{$travail.max}</strong> : <strong>C{$travail.ordre}</strong> {$listeCompetences.$idComp.libelle}</li>
	{/foreach}
	</ol>
	<ul class="noprint">
	{foreach from=$listeCompetences key=idComp item=competence}
		<li class="couleur{$idComp|substr:-1}">{$competence.libelle}</li>
	{/foreach}
	</ul>

</div>

<script type="text/javascript">

	{if $listeErreursEncodage|@count > 0}
	bootbox.alert({
		title: 'Erreur(s)',
		message: 'Votre carnet de cotes contient <span class="erreurEncodage">' + {$listeErreursEncodage|@count} + ' erreur(s)</span> d\'encodage',
	})
	{/if}

	$(document).ready(function(){

		$('[data-toggle="popover"]').popover();

		$('body').on('click', function (e) {

	    $('[data-toggle="popover"]').each(function () {
	        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
	            $(this).popover('hide');
	        }
	    	});
		});

		$("input").tabEnter();

		$("input").not(".autocomplete").attr("autocomplete","off");

		$('body').on('click', '.boutonSuppr', function(){
			$('.popover').hide();
			var idCarnet = $(this).data('idcarnet');
			$.post('inc/carnet/getModalDel.inc.php', {
				idCarnet: idCarnet
			}, function(resultat){
				$('#editCote').html(resultat);
				// $('#modalChoixAction').modal('hide');
				$('#modalSuppr').modal('show');
			})
		})

		$('body').on('click', '.boutonEdit', function(){
			$('.popover').hide();
			var idCarnet = $(this).data('idcarnet');
			$('#modalChoixAction').modal('hide');
			$.post('inc/carnet/getModalEdit.inc.php', {
				idCarnet: idCarnet
			}, function(resultat){
				$('#editCote').html(resultat);
				$('#modalEditCote').modal('show');
			})
		})

		$('body').on('click', '.boutonEncoder', function(){
			$('.popover').hide();
			var idCarnet = $(this).data('idcarnet');
			$('td[data-idcarnet="' + idCarnet + '"]').find('input').attr('disabled', false).removeClass('hidden').next('span').addClass('hidden');
		})

	})

</script>
