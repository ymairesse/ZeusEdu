<div class="container-fluid">
	
	<h2>Votre envoi</h2>

	<div id="cadre">
	<p><strong class="enteteMail">Expéditeur:</strong> <span class="champ" title="{$detailsMail.post['mailExpediteur']}">{$detailsMail.post.nomExpediteur} ({$detailsMail.post['mailExpediteur']})</span> </p>
	<p><strong class="enteteMail">Objet:</strong> <span class="champ">{$detailsMail.post['objet']}</span></p>
	{assign var=nbMails value=count($detailsMail.post['mails'])}
	<p><strong class="enteteMail">Destinataire(s):</strong>
		{if $nbMails > 4}
		<span class="champ">{$nbMails} destinataires</span>
		{else}
		<span class="champ">{$destinatairesString}</span>
		{/if}
	</p>
	<strong>Texte</strong><br>
	<div class="champ">{$detailsMail.post['texte']}</div>
	<br>
	
	<strong>Fichiers joints:</strong><br>
	{assign var=n value=0}
	{foreach from=$detailsMail.files key=wtf item=data}
		{if $data.error != 4}
			{assign var=n value=n+1}
			<a href="upload/{$acronyme}/{$data.name}" target="_blank">{$data.name}</a>&nbsp;&nbsp;
		{/if}
	{/foreach}
	{if $n==0}
		aucun
	{/if}
	</div>

</div>  <!-- container -->
