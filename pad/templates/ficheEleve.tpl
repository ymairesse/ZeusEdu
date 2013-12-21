<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Notes <span id="mod">*</span></a></li>
		<li><a href="#tabs-2">Données personnelles</a></li>
		<li><a href="#tabs-3">Parents et responsables</a></li>
	</ul>
	
	<div id="tabs-1">
		<p><img src="../photos/{$eleve.photo}.jpg" class="photo draggable" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" 
			id="photo" style="width:100px; top:-60px; position: relative" /></p>
		<form name="padEleve" id="padEleve" method="POST" action="index.php">
			<input type="hidden" name="classe" value="{$classe}">
			<input type="hidden" name="matricule" value="{$matricule}">
			<input type="Submit" id="save" name="action" value="Enregistrer">
			<hr>
			<textarea name="texte" cols="90" rows="20" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true">{$padEleve->getPadText()}</textarea>
		</form>
	</div>
	
	<div id="tabs-2">
		<p><img src="../photos/{$eleve.photo}.jpg" class="photo" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" 
			id="photo" style="width:100px; top:-60px; position: relative" /> </p>
		<p><label>Commune de naissance</label>{$eleve.commNaissance|default:'&nbsp;'}</p>
		<p><label>Classe</label> {$eleve.groupe} {if $titulaires} [{", "|implode:$titulaires}]{/if}</p>
		<p><label>Date de naissance</label> {$eleve.DateNaiss} 
		<small>[Âge approx. {$eleve.age.Y} ans {if !($eleve.age.m == 0)}{$eleve.age.m} mois{/if} 
			{if !($eleve.age.d == 0)}{$eleve.age.d} jour(s){/if}]</small></p>
		<p><label>Sexe</label>{$eleve.sexe}</p>
		<p><label>Adresse</label>{$eleve.adresseEleve}</p>
		<p><label>Code Postal</label>{$eleve.cpostEleve} <label>Commune</label>{$eleve.localiteEleve}</p>
	</div>
	
	<div id="tabs-3">
		<p><img src="../photos/{$eleve.photo}.jpg" class="photo" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" 
			id="photo" style="width:100px; top:-60px; position: relative" /> </p>
			<ul class="detailsEleve">
			<li>Coordonnées de la personne responsable
				<ul>
					<li><label>Responsable</label>{$eleve.nomResp}</li>
					<li><label>e-mail</label>&nbsp;<a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></li>
					<li><label>Téléphone</label>&nbsp;{$eleve.telephone1}</li>
					<li><label>GSM</label>&nbsp;{$eleve.telephone2}</li>
					<li><label>Téléphone bis</label>&nbsp;{$eleve.telephone3}</li>
					<li><label>Adresse</label>{$eleve.adresseResp}</li>
					<li><label>Code Postal</label>{$eleve.cpostResp} <label>Commune</label>{$eleve.localiteResp}</li>
				</ul>
			</li>
			<li>Coordonnées du père de l'élève
				<ul>
					<li><label>Nom</label>{$eleve.nomPere}</li>
					<li><label>e-mail</label><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></li>
					<li><label>Téléphone</label>{$eleve.telPere|default:''}</li>
					<li><label>GSM</label>{$eleve.gsmPere}</li>
				</ul>
			</li>
			<li>Coordonnées de la mère de l'élève
				<ul>
					<li><label>Nom</label>{$eleve.nomMere}</li>
					<li><label>e-mail</label><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></li>
					<li><label>Téléphone</label>{$eleve.telMere|default:''}</li>
					<li><label>GSM</label>{$eleve.gsmMere}</li>
				</ul>
			</li>
		</ul>
		</div>
		
</div> <!-- tabs -->

<script type="text/javascript">
{literal}

$(document).ready(function(){
	
	var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var modifie = false;
	
	$("#mod").hide();
	
	$("#tabs").tabs();

	function modification () {
		if (!(modifie)) {
			modifie = true;
			$("#mod").show();
			window.onbeforeunload = function(){
				var reponse = confirm (confirmationBeforeUnload);
				if (!(reponse)) {
					$.unblockUI();
				}
				return reponse
			};
			}
		}
		
	$("#padEleve").keyup(function(e){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		if ((key > 31) || (key == 8)) {
			modification();
			}
		}
	})

	$("#padEleve").submit(function(){
		modifie = false;
		window.onbeforeunload = function(){};
		$.blockUI();
		$("#wait").show();
		})

	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			$("#mod").hide();
			modifie = false;
			window.onbeforeunload = function(){};
			return true
			}
		else {
			$.unblockUI();
			return false;
			}
	})
	
	// le copier/coller provoque aussi  une "modification"
	$("input, textarea").bind('paste', function(){
		modification()
	});
	
	})

{/literal}
</script>
