<div class="container">

<h2>Carnet de cotes de {$coursGrp} Période {$bulletin}</h2>

<!-- ---------------- boîte d'alerte en cas d'erreurs dans les cotes enregistrées ----------------------------- -->
{if isset($listeErreurs) && ($listeErreurs|@count > 0)}
<div class="alert alert-danger alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	<p><span class="glyphicon glyphicon-warning-sign" style="color:red;font-size:1.3em"></span> Vos cotes contiennent des erreurs</p>
	<ol>
	{foreach from=$listeErreurs key=idCarnet item=matricules}
		<li>
			<ul>
				{foreach from=$matricules key=matricule item=wtf}
				<li> Cote du <strong>{$listeTravaux.$idCarnet.date}</strong> pour <strong>{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}</strong>: cote = <strong class="erreurEncodage">{$listeCotes.$matricule.$idCarnet.cote|trim:'!'}/{$listeTravaux.$idCarnet.max}</strong></li>
				{/foreach}
			</ul>
		</li>
	{/foreach}
	</ol>
</div>
{/if}
<!-- -----boîte d'alerte en cas d'erreurs dans les cotes enregistrées---------- -->


<form name="cotes" action="index.php" method="POST" id="formCotes" role="form">

<div id="barreOutils" class="noprint">

	<a type="button" class="btn btn-primary pull-left" href="index.php?action=carnet&amp;mode=oneClick">Bulletin one click <i class="fa fa-thumbs-o-up fa-lg"></i></a>

	<button type="button" class="btn btn-primary" id="pdf" title="Enregistrer en PDF">PDF <i class="fa fa-file-pdf-o fa-lg" style="color:red"></i></button>

	<div class="btn-group pull-right">
		<button class="btn btn-primary" id="boutonPlus"><i class="fa fa-plus fa-lg"></i> Ajouter une cote</button>
		<button type="button" id="enregistrer" class="btn btn-primary disabled"><i class="fa fa-floppy-o fa-lg"></i> Enregistrer</button>
		<button type="reset" class="btn btn-default">Annuler</button>
	</div>
	<div class="clearfix"></div>
	<input type="hidden" name="tri" value="{$tri}">
	<input type="hidden" name="action" value="carnet">
	<input type="hidden" name="mode" value="gererCotes">
	<input type="hidden" name="etape" value="recordCotes">
	<input type="hidden" name="coursGrp" value="{$coursGrp}" id="coursGrp">
	<input type="hidden" name="bulletin" value="{$bulletin}" id="bulletin">

</div>

<div id="page">  <!-- début d'imprssion du PDF -->

	<div class="table-responsive">

		<span class="smallNotice pull-right">Cliquer sur l'entête de colonne pour modifier/supprimer une évaluation</span>

		<table class="table table-hover" id="carnet">
			<thead>

			<tr>
				<th width="20">&nbsp;</th>
				<th>&nbsp;</th>
				{assign var=counter value=1}
				{foreach from=$listeTravaux key=idCarnet item=travail}
					{assign var=idComp value=$travail.idComp}
				<th id="idCarnet{$idCarnet}"
					style="width:4em cursor:pointer"
					class="pop enteteCote {$travail.formCert}"
					data-content="Cliquer pour modifier"
					data-container="body"
					data-placement="left">
				[ {$counter++} ]
					<input type="hidden" name="max{$idCarnet}" value="{$travail.max}">
					<input type="hidden" name="coursGrp" value="{$coursGrp}" class="inputCoursGrp">
					<input type="hidden" name="idCarnet" value="{$idCarnet}" class="inputIdCarnet">
					<input type="hidden" name="bulletin" value="{$bulletin}" class="inputBulletin">
					<input type="hidden" name="date" value="{$travail.date}" class="inputDate">
					<input type="hidden" name="libelle" value="{$travail.libelle}" class="inputLibelle">
					<input type="hidden" name="remarque" value="{$travail.remarque}" class="inputRemarque">
					<input type="hidden" name="neutralise" value="{$travail.neutralise}" class="inputNeutralise">
					<input type="hidden" name="formCert" value="{if $travail.formCert == 'cert'}cert{else}form{/if}" class="inputFormCert">
					<input type="hidden" name="max" value="{$travail.max}" class="inputMax">
					<input type="hidden" name="idComp" value="{$travail.idComp}" class="inputIdComp">
					<input type="hidden" name="comp" value="{$listeCompetences.$idComp.libelle}" class="inputComp">
				</th>
				{/foreach}
			</tr>

			<tr>
				<th>Classe</th>
				<th>Nom</th>
				{assign var=counter value=1}
				{foreach from=$listeTravaux key=idCarnet item=travail}
					{assign var=idComp value=$travail.idComp}
				<th id="idCarnet{$idCarnet}"
					style="width:4em"
					class="pop detailsCote {$travail.formCert}"
					data-content="Libellé: {$travail.libelle}<br>
								Remarque: {$travail.remarque}<br>
								Neutralisé: {if $travail.neutralise == 1}O{else}N{/if}<br>
								Form/Cert: {if $travail.formCert == 'cert'}Certificatif{else}Formatif{/if}<br>
								Max: <strong>{$travail.max}</strong>"
					data-html="true"
					data-container="body"
					data-placement="left"
					data-original-title="C{$travail.ordre} {$listeCompetences.$idComp.libelle}">
					{$travail.date|substr:0:5}<br>
					<span class="micro">C{$travail.ordre}</span> / <strong>{$travail.max}</strong>
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
				<td class="{$travail.formCert} couleur{$couleur} idCarnet{$idCarnet}
					{if (isset($listeCotes.$matricule.$idCarnet)) && $listeCotes.$matricule.$idCarnet.echec} echec{/if} cote"
					title="{$nomPrenom}"
					data-container="body">
					<input type="text" name="cote-{$idCarnet}_eleve-{$matricule}"
						tabIndex="{$tabIndex}"
						class="coteCarnet"
						value="{$listeCotes.$matricule.$idCarnet.cote|default:''}"
						disabled="disabled"
						style="font-size:8pt; display:none; width:4em">

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

</div>  <!-- page -->

<!-- .......................................................................... -->
<!-- .....formulaire modal pour le choix Edition/ suppression / modification..  -->
<!-- .......................................................................... -->
<div class="modal fade noprint" id="modalChoixEdit" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">
					Évaluation du <span id="spanChoixEditDate"></span>
				</h4>
			</div>  <!-- modal-header -->
			<div class="modal-body">
				<form name="choixEdit" methode="POST" action="index.php">
					<p><strong>Libellé:</strong> <span id="spanChoixEditLibelle"></span></p>
					<p><strong>Remarque:</strong> <span id="spanChoixEditRemarque"></span></p>
					<p><strong>Compétence:</strong> <pan id="spanChoixEditComp"></pan></p>
					<p><strong>Max:</strong> <span id="spanChoixEditMax"></span> points</p>
					<p>Que souhaitez-vous faire?</p>
					<div class="btn-group">
						<button type="button" class="btn btn-info boutonEdit">Modifier l'évaluation</button>
						<button type="button" class="btn btn-primary boutonVerrou">Encoder les cotes</button>
						<button type="button" class="btn btn-danger boutonSuppr">Supprimer cette évaluation</button>
					</div>
					<div id="hiddenInput">
					<input type="hidden" name="coursGrp" value="{$coursGrp}">
					<input type="hidden" name="bulletin" value="{$bulletin}">
					<input type="hidden" name="idCarnet" value="" id="inputChoixEditidCarnet">
					</div>
				</form>
			</div>
		</div>

	</div>

</div>


<!-- ........................................................................... -->
<!-- ............... FORMULAIRE MODAL POUR L'EDITION  DES COTES ................ -->
<!-- ........................................................................... -->

<div class="modal fade noprint" id="editCote" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	 <div class="modal-dialog">
		 <div class="modal-content">
			<div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Notification ou modification des cotes</h4>
            </div>

			<div class="modal-body">
				<form name="formEdit" action="index.php" method="POST" id="formEdit" role="form" class="form-vertical">
				<div class="row">

					<div class="col-md-6 col-xs-8">
						<div class="input-group">
							<label for="date">Date</label>
							<input type="text" name="date" id="date" value="" class="ladate inputDate form-control" maxlength="10" id="date">
							<div class="help-block">Date de l'évaluation</div>
						</div>
					</div>

					<div class="col-md-6 col-xs-4">
						<div class="input-group">
							<label for="bulletin">Bulletin</label>
							<select name="bulletin" class="bulletin form-control">
								{section name=boucleBulletin start=1 loop=$nbBulletins+1}
									<option value="{$smarty.section.boucleBulletin.index}" {if $smarty.section.boucleBulletin.index == $bulletin} selected="selected"{/if}>{$smarty.section.boucleBulletin.index}</option>
								{/section}
							</select>
							<div class="help-block">N° du bulletin</div>
						</div>
					</div>

				</div>  <!-- row -->

					<div class="input-group">
						<label for="idComp">Compétence</label>
						<select name="idComp" size="1" id="idComp" class="idComp form-control">
						<option value="">Compétence</option>
						{foreach from=$listeCompetences key=idComp item=uneCompetence}
							<option value="{$idComp}">{$uneCompetence.libelle}</option>
						{/foreach}
						</select>
						<div class="help-block">Compétence exercée pour cette évaluation</div>
					</div>

					<div class="radio-inline">
						<label>
							<input type="radio" name="formCert" value="form" class="inputForm" checked="checked"> Formatif
						</label>
						<div class="help-block">Cote formative</div>
					</div>

					<div class="radio-inline">
						<label>
							<input type="radio" name="formCert" value="cert" class="inputCert"> Certificatif
						</label>
						<div class="help-block">Cote Certificative</div>
					</div>


					<div class="checkbox-inline">
						<label>
						<input type="checkBox" name="neutralise" value="1" class="inputNeutralise"> Neutralisé
						</label>
						<div class="help-block">Cote non comptabilisée</div>
					</div>

					<div class="input-group">
						<label for="libelle">Libellé</label>
						<input type="text" name="libelle" value="" maxlength="50" class="inputLibelle form-control">
						<div class="help-block">Titre du travail</div>
					</div>

					<div class="input-group">
						<label for="remarque">Remarque</label>
						<input type="text" name="remarque" ide="remarque" value="" class="inputRemarque form-control" maxlength="30">
						<div class="help-block">Remarque libre</div>
					</div>

					<div class="input-group">
						<label for="max">Cote maximale</label>
						<input type="text" name="max" value="" class="inputMax form-control" maxlength="4">
						<div class="help-block">Cote maximale pour ce travail</div>
					</div>

					<button class="btn btn-primary pull-right" type="submit">Enregistrer</button>
					<button class="btn btn-default pull-right" data-dismiss="modal" type="reset">Annuler</button>

					<input type="hidden" name="coursGrp" value="{$coursGrp}" class="inputCoursGrp">
					<input type="hidden" name="action" value="carnet">
					<input type="hidden" name="mode" value="gererCotes">
					<input type="hidden" name="tri" value="{$tri}">
					<input type="hidden" name="etape" value="recordEnteteCote">
					<input type="hidden" name="idCarnet" value="" class="inputIdCarnet required">
				</form>
			</div>  <!-- modal-body -->

			<div class="modal-footer">
				<p>{$listeCours.$coursGrp.libelle} -> {$listeCours.$coursGrp.nomCours} [{$coursGrp}] / Bulletin n° {$bulletin}</p>
            </div>  <!-- modal-footer -->
		 </div>  <!-- modal-content -->
	 </div>  <!-- modal-dialog -->
</div>  <!-- modal -->



<!-- ........................................................................... -->
<!-- .............. FORMULAIRE  CACHÉ  POUR L'EFFACEMENT DES COTES ............- -->
<!-- ........................................................................... -->

<div class="modal fade noprint" id="delCote" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Suppresion d'une cote</h4>
			</div>

			<div class="modal-body">

				<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign" style="color:red; font-size:1.5em"></span> Veuillez confirmer la suppression définitive de cette évaluation</div>

				<form name="formDel" action="index.php" method="POST" id="formDel" class="form-vertical">

					<div class="row">

						<div class="col-md-6 col-sm-12">

							<div class="input-group">
								<label>Date</label>
								<p class="spDate form-control-static"></p>
							</div>

						</div>  <!-- col-md-.. -->

						<div class="col-md-6 col-sm-12">

							<div class="input-group">
								<label>Compétence</label>
								<p class="spComp form-control-static"></p>
							</div>
						</div>  <!-- col-md... -->

					</div>  <!-- row -->

					<div class="row">

						<div class="col-md-6 col-sm-12">

							<div class="input-group">
								<label>Libellé</label>
								<p class="spLibelle form-control-static"></p>
							</div>

						</div>  <!-- col-md-.. -->

						<div class="col-md-6 col-sm-12">

							<div class="input-group">
								<label>Remarque</label>
								<p class="spRemarque form-control-static"></p>
							</div>

						</div>  <!-- col-md-.. -->

					</div>  <!-- row -->


					<div class="row">

						<div class="col-md-4 col-sm-6">

							<div class="input-group">
								<label>Neutralisé</label>
								<p class="spNeutralise form-control-static"></p>
							</div>

						</div>

						<div class="col-md-4 col-sm-6">

							<div class="input-group">
								<label>Formatif/Certificatif</label>
								<p class="spFormCert form-control-static"></p>
							</div>

						</div>

						<div class="col-md-4 col-sm-6">

							<div class="input-group">
								<label>Maximum</label>
								<p class="spMax form-control-static"></p>
							</div>

						</div>  <!-- col-md-.. -->

					</div>  <!-- row -->

					<button type="submit" class="btn btn-primary pull-right">Effacer</button>
					<button type="reset" class="btn btn-default pull-right" data-dismiss="modal" >Annuler</button>
					<input type="hidden" name="coursGrp" value="{$coursGrp}" class="coursGrp">
					<input type="hidden" name="bulletin" value="{$bulletin}" class="bulletin">
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="{$mode}">
					<input type="hidden" name="etape" value="delCote">
					<input type="hidden" name="tri" value="{$tri}">
					<input type="hidden" name="idCarnet" value="" class="spIdCarnet">
					<input type="hidden" name="idComp" value="" class="spIdComp">
				</form>
			</div>

			<div class="modal-footer">
				<p>{$listeCours.$coursGrp.libelle} -> {$listeCours.$coursGrp.nomCours} [{$coursGrp}] / Bulletin n° {$bulletin}</p>
			</div>

		</div>
	</div>
</div>

<!-- .......................................................................... -->
<!-- .....fenêtre modale pour la réception du fichier PDF du carnet de cotes    -->
<!-- .......................................................................... -->
<div class="modal fade noprint" id="modalCarnetPDF" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">
					Votre carnet de cotes est prêt
				</h4>
			</div>  <!-- modal-header -->
			<div class="modal-body">
				<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="../{$module}/carnet/{$acronyme}/{$coursGrp}_{$bulletin}.pdf">sur ce lien</a></p>
			</div>
		</div>
	</div>
</div>


</div>  <!-- container -->

<!-- ............................................................................. -->

<script type="text/javascript">

var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var modifie = false;
var nomProf = "{$identite.prenom} {$identite.nom}"

function ajd() {
	var d = new Date();
	var month = d.getMonth()+1;
	var day = d.getDate();

	var laDate = ((''+day).length<2 ? '0' : '') + day+ '/' +
		((''+month).length<2 ? '0' : '') + month + '/' +
		d.getFullYear()
return laDate;
}


$.validator.addMethod(
    "dateFr",
    function(value, element) {
        return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
    },
    "date au format jj/mm/AAAA svp"
);

	// -------------------------------------------------------------------------------------
	// pour des raisons de compatibilité avec Google Chrome et autres navigateurs à base
	// de webkit, il ne faut pas utiliser la règle "date" du validateur jquery.validate.js
	// Elle sera remplacée par la règle "uneDate" dont le fonctionnement n'est pas basé sur
	// le présupposé que le contenu du champ est une date. Google Chrome et Webkit traitent
	// exclusivement les dates au format américain mm-dd-yyyy
	// sans cette nouvelle règle, les dates du type 15-09-2012 sont refusées sous Webkit
	// https://github.com/jzaefferer/jquery-validation/issues/20
	// -------------------------------------------------------------------------------------
	jQuery.validator.addMethod('uneDate', function(value, element) {
		var reg=new RegExp("/", "g");
		var tableau=value.split(reg);
		// ne pas oublier le paramètre de "base" dans la syntaxe de parseInt
		// au risque que les numéros des jours et des mois commençant par "0" soient
		// considérés comme de l'octal
		// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/parseInt
		jour = parseInt(tableau[0],10); mois = parseInt(tableau[1],10); annee = parseInt(tableau[2], 10);
		nbJoursFev = new Date(annee,1,1).getMonth() == new Date(annee,1,29).getMonth() ? 29 : 28;
		var lgMois = new Array (31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		condMois = ((mois >= 1) && (mois <= 12));
		if (!(condMois)) return false;
		condJour = ((jour >=1) && (jour <= lgMois[mois-1]));
		condAnnee = ((annee > 1900) && (annee < 2100));
		var testDateOK = (condMois && condJour && condAnnee);
		return this.optional(element) || testDateOK;
		}, "Date incorrecte");

{literal}
	jQuery.extend(jQuery.validator.methods, {
	         number: function(value, element) {
	            return this.optional(element)
	             || /^-?(?:\d+|\d{1,3}(?:\.\d{3})+)(?:[,.]\d+)?$/.test(value);
	          }
		});
{/literal}

$(document).ready(function(){

	$("input").tabEnter();

	$(".coteCarnet").keyup(function(){
		modifie=true;
		window.onbeforeunload = function(){
			if (confirm (confirmationBeforeUnload))
				return true;
				else {
					$("#wait").hide();
					return false;
					}
			};
		})

	$("#enregistrer").click(function(){
		modifie = false;
		window.onbeforeunload = function(){};
		$("#formCotes").submit();
		})

	$(".boutonSuppr").click(function(){
		$("#modalChoixEdit").modal('hide');
		$("#delCote").modal('show');
		})

	$("#boutonPlus").click(function(){
		var coursGrp = $('#coursGrp').val();
		var bulletin = $('#bulletin').val();
		$("#formEdit .ladate").val(ajd());
		$('#formEdit .idComp').prop('selectedIndex',0);
		$("#formEdit .bulletin").val(bulletin);
		$("#formEdit .inputLibelle").val('');
		$("#formEdit .inputRemarque").val('');
		$("#formEdit .inputMax").val('');

		// $("#formEdit .erreurEncodage").text('');
		$("#editCote .modal-title").text("Ajout d'une cote");
		$("#formEdit .inputForm").attr("checked",true);
		$("#formEdit .inputNeutralise").attr("checked",false);
		$("#editCote").modal('show');
		return false;
		})

	$(".boutonEdit").click(function(){
		$("#modalChoixEdit").modal('hide');
		$("#editCote").modal('show');
		})

	$(".boutonVerrou").click(function(){
		var idCarnet = $(this).closest('form').find('#inputChoixEditidCarnet').val()
		var col = $('#idCarnet'+idCarnet).index();
		$('#carnet').column(col).find("input").attr("disabled",false).show();
		$('td.idCarnet'+idCarnet).removeClass('echec');
		$('#carnet').column(col).find("span").hide();
		$("#enregistrer").removeClass('disabled');
		$("#modalChoixEdit").modal('hide');
		})

	$("#date").datepicker({
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});

	$("#formEdit").validate({
		errorElement: "em",
		errorClass: "erreurEncodage",
		rules: {
			date: {
				required: true,
				uneDate: true
				},
			idComp: {
				required: true
				},
			max: {
				required: true,
				number: true
				}
			}
		});


	// fonction qui retourne le numéro de la colonne cliquée
	$.fn.column = function(i) {
		return $('tr td:nth-child('+(i+1)+')', this);
	}

	$(".coteCarnet").click(function(){
		var col = $(this).closest("td").index();
		$('.carnetCotes').column(col).find("input").attr("readonly",false);
		})

	$(".enteteCote").click(function(){
		var bulletin = $('#bulletin').val();
		var coursGrp = $('#coursGrp').val();
		var idCarnet = $(this).find('input.inputIdCarnet').val();
		var libelle = $(this).find('input.inputLibelle').val();
		var date = $(this).find('input.inputDate').val();
		var remarque = $(this).find('input.inputRemarque').val();
		var neutralise = $(this).find('input.inputNeutralise').val();
		var formCert = $(this).find('input.inputFormCert').val()=='form'?'Formatif':'Certificatif';
		var max = $(this).find('input.inputMax').val();
		var idComp = $(this).find('input.inputIdComp').val();
		var comp = $(this).find('input.inputComp').val();

		// populate modal-choix
		$("#spanChoixEditDate").text(date);
		$("#spanChoixEditLibelle").text(libelle);
		$("#spanChoixEditRemarque").text(remarque);
		$("#spanChoixEditComp").text(comp);
		$("#spanChoixEditMax").text(max);
		$("#inputChoixEditidCarnet").val(idCarnet);

		// populate modal-suppr
		$(".spDate").text(date);
		$(".spComp").text(comp);
		$(".spLibelle").text(libelle);
		$(".spRemarque").text(remarque);
		if (neutralise == 1)
			$(".spNeutralise").text('O');
			else $(".spNeutralise").text('N');
		$(".spFormCert").text(formCert);
		$(".spMax").text(max);
		$(".spIdCarnet").val(idCarnet);
		$(".spIdComp").val(idComp);

		// populate modal-edit
		$("#editCote .modal-title").text("Modification d'une cote");
		$("#formEdit .inputCoursGrp").val(coursGrp);
		$("#formEdit .inputBulletin").val(bulletin);
		$("#formEdit .inputDate").val(date);
		$('#date').datepicker('update');
		$("#formEdit #idComp").val(idComp);
		$("#formEdit .inputIdCarnet").val(idCarnet);
		if (formCert == 'form')
			$("#formEdit .inputForm").attr("checked", true);
		if (formCert == 'cert')
			$("#formEdit .inputCert").attr("checked", true);
		if (neutralise == 1)
			$("#formEdit .inputNeutralise").attr("checked", true);
			else $("#formEdit .inputNeutralise").attr("checked", false);
		$("#formEdit .inputLibelle").val(libelle);
		$("#formEdit .inputRemarque").val(remarque);
		$("#formEdit .inputMax").val(max);

		$("#modalChoixEdit").modal('show');
		});

	$("#pdf").click(function(){
		var page = $("#page").html();
		var coursGrp = $("#coursGrp").val();
		var tri = $("#tri").val();
		var bulletin = $("#bulletin").val();
		$("#wait").show();
		$.blockUI();
		$.post("inc/carnet/carnet2PDF.inc.php", {
			page: page,
			coursGrp: coursGrp,
			bulletin: bulletin,
			acronyme: '{$acronyme}',
			titre: coursGrp,
			nomProf: nomProf,
			module: '{$module}'
			},
			function(resultat){
				$("#wait").hide();
				$.unblockUI();
				$("#modalCarnetPDF").modal('show');
			});
		})

	$("#celien").click(function(){
		$("#modalCarnetPDF").modal('hide');
		})


	})

</script>
