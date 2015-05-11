
<div class="container">
	
	<div class="row">
		
		<div class="col-md-10 col-sm-12">

	
<form method="post" action="index.php" name="formEleve" id="formEleve" class="form-vertical">
	
<div class="panel-group" id="accordion">	
	
	<div class="panel panel-default" id="panel1">
		
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-target="#collapse1" href="#collapse1">Élève</a>
			</h4>
		</div>
		
		
		<div id="collapse1" class="panel-collapse collapse">
			
		<div class="row panel-body">

			<div class="col-md-4 col-sm-12">
		
				<div class="form-group">
					<label for="nom">Nom:</label>
					<input type="text" maxlength="30" size="20" name="nom" id="nom" value="{$eleve.nom}" class="text-uppercase form-control"><br>
				</div>
				
				<div class="form-group">
					<label for="prenom">Prénom:</label>
					<input type="text" maxlength="30" size="20"  name="prenom" id="prenom" value="{$eleve.prenom}" class="form-control">
				</div>
				
				<div class="form-group">
					<label for="annee">Année:</label>
					<input type="text" maxlength="2" size="2" name="annee" id="annee" value="{$eleve.annee}" class="text-uppercase form-control">
					<div class="help-block">(SEULEMENT L'ANNÉE - attention à distinguer les 1C, des 1S et des 1D)</div>
				</div>
				
				<div class="form-group">
					<label for="sexe">Sexe</label>
					<input type="text" maxlength="1" size="1" name="sexe" id="sexe" value="{$eleve.sexe}" class="text-uppercase form-control">
					<div class="help-block">(M ou F)</div>
				</div>
				
			</div>
			
			<div class="col-md-4 col-sm-12">
				
				<div class="form-group">
					<label for="classe">Classe:</label>
					<input type="text" maxlength="6" size="6" name="classe" id="classe" value="{$eleve.classe}" class="text-uppercase form-control">
				</div>
				
				<div class="form-group">
					<label for="groupe">Groupe:</label>
					<input type="text" maxlength="6" size="6" name="groupe" id="groupe" value="{$eleve.groupe}" class="text-uppercase form-control">
				</div>
				
				<div class="form-group">
					<label for="section">Section</label>
					<select name="section" id="section" class="form-control">
						<option value=''>Section</option>
						<option value='TQ'{if $eleve.section == 'TQ'} selected{/if}>TQ</option>
						<option value='G'{if $eleve.section == 'G'} selected{/if}>GT</option>
						<option value='TT'{if $eleve.section == 'TT'} selected{/if}>TT</option>
						<option value='S'{if $eleve.section == 'S'} selected{/if}>S</option>
						<option value='PARTI'{if $eleve.section == 'PARTI'} selected{/if}>PARTI</option>
					</select>
				</div>
				
				
				<div class="form-group">
					<label for="matricule">Matricule:</label>
					<input type="text" maxlength="6" size="6" name="matricule" id="matricule" value="{$eleve.matricule}" class="form-control"
					{if $recordingType == 'modif'}readonly="readonly"{/if}>
					<div class="help-block">
					{if $recordingType == 'modif'} non modifiable.{/if} Veiller à indiquer exclusivement le matricule officiel
					</div>
				</div>
			
			</div>  <!-- col-md-... -->
			
			<div class="col-md-4 col-sm-12">
				
				<div class="form-group">
					<label for="DateNaiss">Date de naissance:</label>
					<input type="text" name="DateNaiss" id="DateNaiss" maxlength="11" type="text" value="{$eleve.DateNaiss}" class="form-control">
					<div class="help-block">Utiliser le format jj/mm/AAAA</div>
				</div>
				
				<div class="form-group">
					<label for="commNaissance">Commune de naissance</label>
					<input type="text" name="commNaissance" id="commNaissance" maxlength="30" value="{$eleve.commNaissance}" class="form-control">
				</div>
				
				<div class="form-group">
					<label for="adresseEleve">Adresse</label>
					<input type="text" name="adresseEleve" id="adresseEleve" maxlenght="40" value="{$eleve.adresseEleve}" class="form-control">
				</div>
				
				 <div class="form-group">
					<label for="cpostEleve">Code Postal</label>
					<input type="text" name="cpostEleve" id="cpostEleve" maxlength="6" value="{$eleve.cpostEleve}" class="form-control">
				 </div>
				 
				 <div class="form-group">
					<label for="localiteEleve">Commune</label>
					<input type="text" name="localiteEleve" id="localiteEleve" maxlength="30" value="{$eleve.localiteEleve}" class="form-control">
				 </div>
				 
			</div>  <!-- col-md-... -->
					
		</div>  <!-- row -->
		
		</div>  <!-- collapse -->
	
	</div>  <!-- panel -->


	<div class="panel panel-default">
		
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-target="#collapse2" href="#collapse2">Personne responsable</a>
			</h4>
		</div>
		
		<div id="collapse2" class="panel-collapse collapse">
		<div class="row panel-body">
			
			<div class="col-md-4 col-sm-12">
				
				<div class="form-group">
					<label for="nomResp">Responsable</label>
					<input type="text" name="nomResp" id="nomResp" maxlength="50" value="{$eleve.nomResp}" class="text-uppercase form-control">
				</div>
				
				<div class="form-group">
					<label for="courriel">Courriel</label>
					<input type="text" name="courriel" id="courriel" maxlength="40" value="{$eleve.courriel}" class="form-control">
				</div>
				
				<div class="form-group">
					<label for="telephone1">Téléphone</label>
					<input type="text" name="telephone1" id="telephone1" maxlength="20" value="{$eleve.telephone1}" class="form-control">
				</div>
				
			</div>
			
			<div class="col-md-4 col-sm-12">
				
				<div class="form-group">
					<label for="telephone2">GSM</label>
					<input type="text" name="telephone2" id="telephone2" maxlength="20" value="{$eleve.telephone2}" class="form-control">
					</div>

				<div class="form-group">
					<label for="telephone3">Téléphone bis</label>
					<input type="text" name="telephone3" id="telephone3" maxlength="20" value="{$eleve.telephone3}" class="form-control">
				</div>
				
				<div class="form-group">
					<label for="adresseResp">Adresse</label>
					<input type="text" name="adresseResp" id="adresseResp" maxlenght="40" value="{$eleve.adresseResp}" class="form-control">
				</div>
				
			</div>
			
			<div class="col-md-4 col-sm-12">

				<div class="form-group">
					<label for="cpostResp">Code Postal</label>
					<input type="text" name="cpostResp" id="cpostResp" maxlength="6" value="{$eleve.cpostResp}" class="form-control">
				</div>
			
				<div class="form-group">
					<label for="localiteResp">Commune</label>
					<input type="text" name="localiteResp" id="localiteResp" maxlength="30" value="{$eleve.localiteResp}" class="form-control">
				</div>
			
			</div>  <!-- col-md-... -->
			
		</div>  <!-- row -->
		
		</div>  <!-- collapse -->
	
	</div>  <!-- panel -->
	
	
	<div class="panel">
		
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-target="#collapse3" href="#collapse3">Père de l'élève</a>
			</h4>
		</div>

		
		<div id="collapse3" class="panel-collapse collapse">
			
		<div class="row panel-body">
			
			<div class="col-md-6 col-sm-12">
			
				<div class="form-group">
					<label for="nomPere">Nom</label>
					<input type="text" name="nomPere" id="nomPere" maxlength="50" value="{$eleve.nomPere}" class="text-uppercase form-control">
				</div>
				
				<div class="form-group">
					<label for="telPere">Téléphone</label>
					<input type="text" name="telPere" id="telPere" maxlength="20" value="{$eleve.telPere}" class="form-control">
				</div>
			
			</div>  <!-- col-md-... -->
			
			<div class="col-md-6 col-sm-12">
			
				<div class="form-group">
					<label for="gsmPere">GSM</label>
					<input type="text" name="gsmPere" id="gsmPere" maxlength="20" value="{$eleve.gsmPere}" class="form-control">
				</div>
				
				<div class="form-group">
					<label for="mailPere">Courriel</label>
					<input type="text" name="mailPere" id="mailPere" maxlength="40" value="{$eleve.mailPere}" class="form-control">
				</div>
				
			</div>  <!-- col-md-... -->
			
		</div>  <!-- row -->
		
		</div>  <!-- collapse  -->
	
	</div>  <!-- panel -->
	
	
	<div class="panel">
		
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-target="#collapse4" href="#collapse4">Mère de l'élève</a>
			</h4>
		</div>
		
		<div id="collapse4" class="panel-collapse collapse">
		
		<div class="row panel-body">
			
			<div class="col-md-6 col-sm-12">
	
				<div class="form-group">
					<label for="nomMere">Nom</label>
					<input type="text" name="nomMere" id="nomMere" maxlength="50" value="{$eleve.nomMere}" class="text-uppercase form-control">
				</div>
				
				<div class="form-group">
					<label for="telMere">Téléphone</label>
					<input type="text" name="telMere" id="telMere" maxlength="20" value="{$eleve.telMere}" class="form-control">
				</div>
				
			</div>  <!-- col-md-... -->
			
			<div class="col-md-6 col-sm-12">
				
				<div class="form-group">
					<label for="gsmMere">GSM</label>
					<input type="text" name="gsmMere" id="gsmMere" maxlength="20" value="{$eleve.gsmMere}" class="form-control">
				</div>
				
				<div class="form-group">
				<label for="mailMere">Courriel</label>
				<input type="text" name="mailMere" id="mailMere" maxlength="40" value="{$eleve.mailMere}" class="form-control">
				</div>
				
			</div>  <!-- col-md-... -->
		
		</div>  <!-- row -->
		
		</div>  <!-- collapse -->
		
	</div>  <!-- panel -->
	
	
	<div class="panel">
		
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-target="#collapse5" href="#collapse5">Informatique</a>
			</h4>
		</div>
		
		<div id="collapse5" class="panel-collapse collapse">
			
		<div class="row panel-body">
			
			<div class="form-group">
				<label for="userName">Nom d'utilisateur</label>
				<p id="userName" class="code form-control-static">{$info.user|default:''}</p>
			</div>
			
			<div class="form-group">
			<label for="mdp">Mot de passe</label>
			<p class="passwd code form-control-static">{$info.passwd|default:''}</p>
			</div>
			
			<div class="form-group">
				<label for="mailDomain">Domaine mail</label>
				<p class="code form-control-static">{$eleve.mailDomain|default:''}</p>
			</div>
			
		</div>  <!-- row -->
		
		</div>  <!-- collapse -->
		
	</div>  <!-- panel -->
	
	<div style="text-align:center">
		
		<button class="btn btn-primary id="enregistrer" type="submit">Enregistrer</button>
		<button type="reset" name="annuler">Annuler</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
		<input type="hidden" name="recordingType" value="{$recordingType}">
		<input type="hidden" name="laClasse" value="{$laClasse}">
		
	</div>

</div>
	
</form>

		</div>  <!-- col-md-... -->
		
		<div class="col-md-2 col-sm-12">
			
			<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" style="width:100px" class="photo">
			
		</div>  <!-- col-md-... -->

	</div>  <!-- row -->
	
</div>  <!-- container -->

<script type="text/javascript">
	
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
	

	$(document).ready(function(){

		$("#formEleve").validate({
		rules: {
            nom:    { required: true },
            prenom: { required: true },
            annee:   { required: true },
			section: { required: true },
			sexe: { required: true },
			classe: { required: true },
			matricule: { required: true },
			courriel: { email: true },
			DateNaiss: {
					required:true,
					uneDate: true
					},
        },
		errorElement: "span"
	})

	$("#matricule").keyup(function (){
		var matricule = $(this).val();
		$.get("inc/verifMatricule.php", {
			'matricule': matricule
			},
                function (resultat){
				  if (resultat == true) {
					$("#OK").html('<span style="color:red" title="Déjà utilisé">:o(</span>');
					$("#enregistrer").attr("disabled","disabled").css("color","#ccc");
					}
					else {
					$("#OK").html(':o)');
					$("#enregistrer").removeAttr("disabled").css("color","");
					}
				})
	})

	$("input, textarea, select").each(function(i, value){
		$(this).attr("tabindex",i+1);
		})

	$(".passwd").hide();

	$(".passwd").prev().hover(function(){
		$(".passwd").toggle();
		})
		
	// forcer les majuscules à la sortie des champs de cette class
	$(".text-uppercase").on("blur",function(){
		$(this).val($(this).val().toUpperCase());
		})
	
	})

</script>
