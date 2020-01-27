<div class="container">
<fieldset>
	<legend>Informations Personnelles</legend>

	<form method="post" action="index.php" name="form" autocomplete="off" id="formPerso" class="form-vertical" role="form">

		<div class="row">

			<div class="col-md-6 col-sm-12">

				<div id="photo"></div>

				<div class="form-group">
					<label for="acronyme">Nom d'utilisateur:</label>
					{if $dejaConnu}
						<input name="acronyme" type="hidden" value="{$userIdentite.acronyme|default:''}">
						<strong class="form-control-static">{$userIdentite.acronyme|default:''}</strong>
						{else}
						<input type="text" maxlength="7" name="acronyme" id="acronyme" value="{$userIdentite.acronyme|default:''}" class="required form-control">
						<div class="help-block" id="acronymeOK"></div>
					{/if}
				</div>

				<div class="form-group">
					<label>Sexe:</label>
					<div class="radio-inline">
						<label for="M" class="radio-inline">
							<input name="sexe" type="radio" id="M" value="M" {if isset($userIdentite.sexe) && ($userIdentite.sexe =="M")} checked="checked"{/if} class="required">M
						</label>
					</div>

					<div class="radio-inline">
						<label for="F" class="radio-inline">
						<input name="sexe" type="radio" id="F" value="F" {if isset($userIdentite.sexe) && ($userIdentite.sexe =="F")} checked="checked"{/if} class="required">F
						</label>
					</div>
				</div>

				<div class="form-group">
					<label for="nom">Nom: </label>
					<input type="text" maxlength="40" name="nom" id="nom" value="{$userIdentite.nom|default:''}" class="required form-control">
				</div>

				<div class="form-group">
					<label for="prenom">Prénom: </label>
					<input type="text" maxlength="40" name="prenom" id="prenom" value="{$userIdentite.prenom|default:''}" class="required form-control">
				</div>

				<div class="form-group">
					<label for="mdp">Mot de passe: </label>
					{* Le mot de passe est obligatoire pour les nouveaux utilisateurs seulement *}
					<input type="passwd" maxlenght="20" name="mdp" id="mdp" value=""
						{if $dejaConnu == false} class="required form-control" {else} class="form-control"{/if}>
					<div class="help-block">Laisser vide pour ne pas modifier le mot de passe</div>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-6 col-sm-12">
				<div class="form-group">
					<label for="mail">Mail: </label>
					<input type="text" maxlength="40" name="mail" id="mail" value="{$userIdentite.mail|default:''}" class="required mail form-control">
				</div>

				<div class="form-group">
					<label for="telephone">Téléphone:</label>
					<input type="text" maxlength="40" name="telephone" id="telephone" value="{$userIdentite.telephone|default:''}" class="form-control">
					<div class="help-block">Téléphone fixe</div>
				</div>

				<div class="form-group">
					<label for="GSM">GSM: </label>
					<input type="text" maxlength="40" name="GSM" id="GSM" value="{$userIdentite.GSM|default:''}" class="form-control">
					<div class="help-block">Téléphone portable</div>
				</div>

				<div class="form-group">
					<label for="statut">Statut global</label>
					{assign var=statut value=$userIdentite.statut|default:Null}
					<select name="statut" id="statut" class="form-control">
						<option value="user"
							{if ($statut == 'user') || ($statut == Null)} selected="selected"{/if}>Utilisateur
						</option>
						<option value="admin"{if ($statut == 'admin')} selected="selected"{/if}>Administrateur</option>
					</select>
					<div class="help-block">L'administrateur global reçoit les notifications "admin"</div>
				</div>
				<input type="hidden" name="oldUser" value="{$dejaConnu}">
				<input type="hidden" name="action" value="gestUsers">
				</p>

			</div>

		</div>  <!-- row -->

		<div class="row">

		<table width="100%" class="table table-striped table-condensed">
		<tr>
			<th>&nbsp;</th>
			<th>Application</th>
			{foreach from=$applicationDroits item=unStatut}
				<th id="{$unStatut}" class="statut" title="statut '{$unStatut}'  pour toutes les applications" data-container="body" style="text-align:center"><a href="javascript:void(0)">{$unStatut}</a></th>
			{/foreach}
		</tr>

		{foreach from=$applications key=nomApplication item=uneApplication}
			<tr {if $uneApplication.active == 0}class="inactif" title="Application inactive"{/if}>
			<td>{if $uneApplication.active == 0}<i class="fa fa-minus-circle fa-lg"></i>{else}&nbsp;{/if}</td>
			<td>{$uneApplication.nomLong}</td>
			{foreach from=$applicationDroits item=unStatut}
				<td style="text-align:center">
					<input type="radio" name="{$nomApplication}" value="{$unStatut}" class="check_{$unStatut}"
						{if isset($userApplications.$nomApplication)}
						   {if $unStatut == $userApplications.$nomApplication.userStatus} checked{/if}>
						{else}
							{if $unStatut == 'none'} checked{/if}>
						{/if}
				</td>
			{/foreach}
			</tr>
		{/foreach}

		</table>

		</div>  <!-- row -->

		<div style="clear:both">
			<input type="hidden" name="mode" value="saveUser">
				<div class="btn-group pull-right">
					<button class="btn btn-default" type="reset">Annuler</button>
					<button class="btn btn-primary" type="Submit">Enregistrer</button>
				</div>
		</div>
	</form>
</fieldset>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){

    // validation du formulaire de modification des données personnelles
    $("#formPerso").validate({
        errorElement: "span"
    })


	// formulaire d'inscription d'un nouvel utilisateur
    $("#acronyme").keyup(function(){
		$(this).val($(this).val().toUpperCase());
		$.get("inc/verifUserExists.inc.php", {
			acronyme: $(this).val()},
			function (resultat) {
				if (resultat != '') {
					$("#submit").attr("disabled","disabled");
					$("#acronymeOK").html("Existe déjà ");
				}
				else {
					$("#submit").removeAttr("disabled");
					$("#acronymeOK").html(":o)");
					}
				}
			)
		})

	$(".statut").click(function(){
		var id=$(this).attr("id");
		$(".check_"+id).trigger("click");
		})
})

</script>
