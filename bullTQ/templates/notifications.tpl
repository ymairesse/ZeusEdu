<div class="container">
<h3>Notifications des décisions de délibération {$classe}</h3>

<form name="notification" id="notification" method="POST" action="index.php">
<table class="table table-condensed table-striped">
	<thead>
		<tr>
			<th>Nom</th>
			<th>Décision</th>
			<th>Restrictions</th>
			<th>Mail</th>
			<th>Envoi mail</th>
			<th>Notifier</th>
			<th>Envoyé</th>
			<th><input type="checkbox" id="conf" checked title="Tout cocher/décocher"></th>
		</tr>
	</thead>

{foreach from=$listeEleves key=matricule item=unEleve}
	{assign var=decision value=$listeDecisions.$matricule}
	<tr>
		<td class="pop"
			data-html="true"
			data-original-title="{$unEleve.nom} {$unEleve.prenom}"
			data-content="<img src='../photos/{$unEleve.photo}.jpg' alt='{$matricule}' style='width:100px'><br>{$matricule}"
			data-placement="top"
			data-container="body">
			{$decision.nom}
		</td>
		<td>{$decision.decision}</td>
		<td>{$decision.restriction}</td>
		<td>{if !(isset($decision.adresseMail)) || ($decision.adresseMail == '')}
				{$decision.user}@{$decision.mailDomain}
				{else}
				{$decision.adresseMail}
			{/if}
		</td>
		<td>
			{if $decision.mail != Null}
				{if $decision.mail == 1}
				<i class="fa fa-bell text-success"
					title="Un mail d'avertissement sera envoyé"
					data-container="body"></i>
				 <input type="hidden" name="mail_{$matricule}" value="true">
				{else}
				<i class="fa fa-bell-slash-o text-danger"></i>
				{/if}
				{else}
			-
			{/if}
		</td>
		<td>
			{if $decision.notification != Null}
				{if $decision.notification == 1}
				<i class="fa fa-bell text-success"
					title="Notification Thot prévue"
					data-container="body"></i>
				<input type="hidden" name="notif_{$matricule}" value="true">
				{else}
				<i class="fa fa-bell-slash-o text-danger"></i>
				{/if}
				{else}
			-
			{/if}
		</td>
		<td>{if $decision.quand != Null}<span title="Date d'envoi" data-container="body">{$decision.quand}</span>{else}-{/if}</td>
		<td><input type="checkbox"
					name="conf_{$matricule}"
					{if $decision.okEnvoi == true} checked{else} disabled{/if}
					id="conf_{$matricule}"
					class="conf"
					value="true">
		</td>
	</tr>
{/foreach}
</table>

<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="envoyer">

<div class="btn-group pull-right">
	<button class="btn btn-default" type="reset">Annuler</button>
	<button class="btn btn-primary" type="submit">Envoyer</button>
</div>

</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#conf").click(function(){
		$(".conf").trigger('click');
	})

})

</script>
