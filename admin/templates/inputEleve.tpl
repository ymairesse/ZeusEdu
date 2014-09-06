<style type="text/css">
{literal}
input.majuscule {
	text-transform: uppercase;
	}
{/literal}
</style>
<form method="post" action="index.php" name="formEleve" id="formEleve">
	<fieldset><legend>Élève</legend>
	<label for="nom">Nom:</label>
		<input type="text" maxlength="30" size="20" name="nom" id="nom" value="{$eleve.nom}" class="majuscule"><br>
	<label for="prenom">Prénom:</label>
		<input type="text" maxlength="30" size="20"  name="prenom" id="prenom" value="{$eleve.prenom}"><br>
	<label for="annee">Année:</label>
		<input type="text" maxlength="2" size="2" name="annee" id="annee" value="{$eleve.annee}" classe="majuscule"> (SEULEMENT L'ANNÉE - attention à distinguer les 1C, des 1S et des 1D)<br>
	<label for="sexe">Sexe</label>
		<input type="text" maxlength="1" size="1" name="sexe" id="sexe" value="{$eleve.sexe}" class="majuscule"> (M ou F)<br>
	<label for="classe">Classe:</label>
		<input type="text" maxlength="6" size="6" name="classe" id="classe" value="{$eleve.classe}" class="majuscule"><br>
	<label for="groupe">Groupe:</label>
		<input type="text" maxlength="6" size="6" name="groupe" id="groupe" value="{$eleve.groupe}" class="majuscule"><br>
	<label for="section">Section</label>
		<select name="section" id="section">
			<option value=''>Section</option>
			<option value='TQ'{if $eleve.section == 'TQ'} selected{/if}>TQ</option>
			<option value='G'{if $eleve.section == 'G'} selected{/if}>GT</option>
			<option value='TT'{if $eleve.section == 'TT'} selected{/if}>TT</option>
			<option value='S'{if $eleve.section == 'S'} selected{/if}>S</option>
			<option value='PARTI'{if $eleve.section == 'PARTI'} selected{/if}>PARTI</option>
		</select>
		<br>
	<label for="matricule">Matricule:</label>
		<input type="text" maxlength="6" size="6" name="matricule" id="matricule" value="{$eleve.matricule}"
	{if $recordingType == 'modif'}readonly="readonly"{/if}><span id="OK"></span>{if $recordingType == 'modif'} non modifiable.{/if} Veiller à indiquer exclusivement le matricule officiel<br>
	<label for="DateNaiss">Date de naissance:</label>
		<input type="text" name="DateNaiss" id="DateNaiss" maxlength="11" size="11" type="text" value="{$eleve.DateNaiss}"> Utiliser le format AAAA-MM-JJ<br>
	<label for="commNaissance">Commune de naissance</label>
		<input type="text" name="commNaissance" id="commNaissance" maxlength="30" size="30" value="{$eleve.commNaissance}"><br>
	<label for="adresseEleve">Adresse</label>
		<input type="text" name="adresseEleve" id="adresseEleve" maxlenght="40" size="30" value="{$eleve.adresseEleve}"><br>
	<label for="cpostEleve">Code Postal</label>
		<input type="text" name="cpostEleve" id="cpostEleve" maxlength="6" size="6" value="{$eleve.cpostEleve}">
	<label for="localiteEleve">Commune</label>
		<input type="text" name="localiteEleve" id="localiteEleve" maxlength="30" size="20" value="{$eleve.localiteEleve}"><br>
	</fieldset>
	<hr>
	<fieldset><legend>Personne responsable</legend>
	<label for="nomResp">Responsable</label><input type="text" name="nomResp" id="nomResp" maxlength="50" size="40" value="{$eleve.nomResp}" class="majuscule"><br>
	<label for="courriel">Courriel</label><input type="text" name="courriel" id="courriel" maxlength="40" size="40" value="{$eleve.courriel}"><br>
	<label for="telephone1">Téléphone</label><input type="text" name="telephone1" id="telephone1" maxlength="20" size="20" value="{$eleve.telephone1}"><br>
	<label for="telephone2">GSM</label><input type="text" name="telephone2" id="telephone2" maxlength="20" size="20" value="{$eleve.telephone2}"><br>
	<label for="telephone3">Téléphone bis</label><input type="text" name="telephone3" id="telephone3" maxlength="20" size="20" value="{$eleve.telephone3}"><br>
	<label for="adresseResp">Adresse</label><input type="text" name="adresseResp" id="adresseResp" maxlenght="40" size="30" value="{$eleve.adresseResp}"><br>
	<label for="cpostResp">Code Postal</label><input type="text" name="cpostResp" id="cpostResp" maxlength="6" size="6" value="{$eleve.cpostResp}">
	<label for="localiteResp">Commune</label><input type="text" name="localiteResp" id="localiteResp" maxlength="30" size="20" value="{$eleve.localiteResp}"><br>
	</fieldset>
	<hr>
	<fieldset><legend>Père de l'élève</legend>
	<label for="nomPere">Nom</label><input type="text" name="nomPere" id="nomPere" maxlength="50" size="40" value="{$eleve.nomPere}" class="majuscule"><br>
	<label for="telPere">Téléphone</label><input type="text" name="telPere" id="telPere" maxlength="20" size="20" value="{$eleve.telPere}"><br>
	<label for="gsmPere">GSM</label><input type="text" name="gsmPere" id="gsmPere" maxlength="20" size="20" value="{$eleve.gsmPere}"><br>
	<label for="mailPere">Courriel</label><input type="text" name="mailPere" id="mailPere" maxlength="40" size="40" value="{$eleve.mailPere}"><br>
	</fieldset>
	<fieldset><legend>Mère de l'élève</legend>
	<label for="nomMere">Nom</label><input type="text" name="nomMere" id="nomMere" maxlength="50" size="40" value="{$eleve.nomMere}" class="majuscule"><br>
	<label for="telMere">Téléphone</label><input type="text" name="telMere" id="telMere" maxlength="20" size="20" value="{$eleve.telMere}"><br>
	<label for="gsmMere">GSM</label><input type="text" name="gsmMere" id="gsmMere" maxlength="20" size="20" value="{$eleve.gsmMere}"><br>
	<label for="mailMere">Courriel</label><input type="text" name="mailMere" id="mailMere" maxlength="40" size="40" value="{$eleve.mailMere}"><br>
	</fieldset>
	<fieldset><legend>Informatique</legend>
	<label>Nom d'utilisateur</label><span class="code">{$info.user|default:''}</span><br>
	<label>Mot de passe</label><span class="passwd code">{$info.passwd|default:''}</span><br>
	<label for="mailDomain">Domaine mail</label><span class="code">{$eleve.mailDomain|default:''}</span>
	</fieldset>
	<div style="text-align:center">
	<input name="enregistrer" id="enregistrer" value="Enregistrer" type="submit">
	<input name="annuler" value="Annuler" type="reset">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
	<input type="hidden" name="recordingType" value="{$recordingType}">
	<input type="hidden" name="laClasse" value="{$laClasse}">
	</div>
</form>

<script type="text/javascript">
{literal}
	$(document).ready(function(){

		$("#formEleve").validate({
		rules: {
            nom:    {required: true},
            prenom: {required: true},
            annee:   {required: true},
			section: {required: true},
			sexe: {required: true},
			classe: {required: true},
			matricule: {required: true},
			courriel: {email: true}
        },
		errorElement: "span"
	})

	$("#matricule").keyup(function (){
		var matricule = $(this).val();
		$.get("inc/verifMatricule.php",
                {'matricule': matricule},
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

	$("#formEleve").submit(function(){

		})


	$("input, textarea, select").each(function(i, value){
		$(this).attr("tabindex",i+1);
		})

		$(".passwd").hide();

		$(".passwd").prev().hover(function(){
			$(".passwd").toggle();
			})
		// forcer les majuscules à la sortie des champs de cette class
		$(".majuscule").on("blur",function(){
			$(this).val($(this).val().toUpperCase());
			})
		})
{/literal}
</script>
