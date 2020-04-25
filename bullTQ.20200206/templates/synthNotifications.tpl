<div class="container">
	
<h3>Notifications des décisions de délibération {$classe} <a type="button" class="btn btn-primary pull-right" href="index.php?action=delibe&amp;mode=notifications">Retour à la classe</a></h3>

{if $listeSynthDecisions != Null}
	<table class="table table-condensed table-striped">

		<thead>
			<tr>
				<th>Nom de l'élève</th>
				<th>Décision</th>
				<th>Restrictions</th>
				<th>Notification</th>
				<th>Mail</th>
				<th>Adresse mail</th>
				<th>Quand</th>
			</tr>
		</thead>
		
		{foreach from=$listeSynthDecisions key=matricule item=decision}
		<tr>
			<td class="pop"
				data-html="true"
				data-original-title="{$decision.nom} {$decision.matricule}"
				data-content="<img src='../photos/{$decision.photo}.jpg' alt='$matricule' style='width:100px'>"
				data-placement="top"
				data-container="body">
				{$decision.nom} {$decision.prenom}
			</td>
			<td>{$decision.decision}</td>
			<td>{$decision.restriction}</td>
			<td>
			{if $decision.notification != Null}
				{if $decision.notification == 1}
				<i class="fa fa-bell text-success"></i>
				<input type="hidden" name="notif_{$matricule}" value="true">
				{else}
				<i class="fa fa-bell-slash-o text-danger"></i>
				{/if}
				{else}
			-
			{/if}
			</td>
			<td>
			{if $decision.mail != Null}
				{if $decision.mail == 1}
				<i class="fa fa-bell text-success pop"
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
			<td>{if $decision.mail == 1}
					{if $decision.adresseMail != ''}
						{$decision.adresseMail}
						{else}
						{$decision.user}@{$decision.mailDomain}
					{/if}
					{else}
					&nbsp;
					{/if}
			</td>
			<td>{$decision.quand}</td>
		</tr>
		{/foreach}
		
	</table>
	
	{else}
	<p>Aucune nouvelle décision n'a été prise.</p>
{/if}

</div>