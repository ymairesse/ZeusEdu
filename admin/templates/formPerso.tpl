<fieldset style="clear:both"><legend>Informations Personnelles</legend>
	<form method="post" action="index.php" name="form" autocomplete="off" id="formPerso">
		<div class="blocGauche">
        <div id="photo"></div>
		
        <p><label for="acronyme">Nom d'utilisateur:</label>
		{if $dejaConnu}
			<input name="acronyme" type="hidden" value="{$userIdentite.acronyme|default:''}">
			<strong>{$userIdentite.acronyme|default:''}</strong>
			{else}
			<input type="text" maxlength="3" size="5" name="acronyme" id="acronyme" value="{$userIdentite.acronyme|default:''}" class="required">
		{/if}
		<span id="acronymeOK"></span>
		</p>
        <p>
        <label for="nom">Nom: </label>
        <input type="text" maxlength="20" size="15" name="nom" id="nom" value="{$userIdentite.nom|default:''}" class="required"/>
        </p>
        <p>
        <label for="prenom">Prénom: </label>
        <input type="text" maxlength="20" size="15" name="prenom" id="prenom" value="{$userIdentite.prenom|default:''}" class="required"/>
        </p>
        <p>
        <label for="sexe">Sexe:</label>
        <input name="sexe" type="radio" value="M" {if isset($userIdentite.sexe) && ($userIdentite.sexe =="M")} checked="checked"{/if} class="required" />M&nbsp;
        <input name="sexe" type="radio" value="F" {if isset($userIdentite.sexe) && ($userIdentite.sexe =="F")} checked="checked"{/if} class="required" />F
        </p>
        <p>
		</div>
		
		<div class="blocDroit">
        <label for="mail">Mail: </label>
        <input type="text" maxlength="40" size="15" name="mail" id="mail" value="{$userIdentite.mail|default:''}" class="required mail" />
        </p>
        <p>
        <label for="telephone">Téléphone: </label>
        <input type="text" maxlength="40" size="15" name="telephone" id="telephone" value="{$userIdentite.telephone|default:''}" />
        </p>
        <p>
        <label for="GSM">GSM: </label>
        <input maxlength="40" size="15" name="GSM" id="GSM" value="{$userIdentite.GSM|default:''}" />
        </p>
		<p>
        <label for="mdp">Mot de passe: </label>
        {* Le mot de passe est obligatoire pour les nouveaux utilisateurs seulement *}
        <input type="passwd" maxlenght="20" size="12" name="mdp" id="mdp" value=""
			{if $dejaConnu eq false} class="required" {else} title="Laisser vide pour ne pas modifier le mot de passe"{/if} />
		<input type="hidden" name="oldUser" value="{$dejaConnu}">
		<input type="hidden" name="action" value="gestUsers">
        </p>
		
		<label for="statut">Statut global</label>
		{assign var=statut value=$userIdentite.statut|default:Null}
		<select name="statut" id="statut">
			<option value="user"
				{if ($statut == 'user') || ($statut == Null)} selected="selected"{/if}>Utilisateur
			</option>
			<option value="admin"{if ($statut == 'admin')} selected="selected"{/if}>Administrateur</option>
		</select>
		</div>
		<hr style="clear:both" />
		<div>
		<table width="100%"class="tableauAdmin">
		<tr>
			<th>Application</th>
			{foreach from=$applicationDroits item=unStatut}
				<th id="{$unStatut}" class="statut" title="statut '{$unStatut}'  pour toutes les applications"><a href="javascript:void(0)">{$unStatut}</a></th>
			{/foreach}
		</tr>
		
		{foreach from=$applications key=nomApplication item=uneApplication}
			<tr bgcolor="{cycle values="#eeeeee,#d0d0d0"}" {if $uneApplication.active == 0}class="inactif" title="Application inactive"{/if}>
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
		</div>
		<div style="clear:both">
		<input type="hidden" name="mode" value="saveUser">
	<input name="submit" id="submit" value="Enregistrer" type="submit">
    <input name="reset" value="Annuler" type="reset">
	</div>
	</form>
</fieldset>


<script type="text/javascript">
{literal}
$(document).ready(function(){
    // validation du formulaire de modification des données personnelles
    $("#formPerso").validate({
        errorElement: "span"
    })
	
	$("#formPerso").submit(function(){
		$.blockUI();
		$("#wait").show();
		
		})
    
	// formulaire d'inscription d'un nouvel utilisateur
    $("#acronyme").keyup(function(){
		$(this).val($(this).val().toUpperCase());
		$.get("inc/verifUserExists.inc.php",
			{acronyme: $(this).val()},
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
{/literal}
</script>