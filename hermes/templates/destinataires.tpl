<div class="panel panel-default">

	<div class="panel-header">
		<h3>Destinataires</h3>
	</div>

	<div class="panel-body">

	{assign var=noListe value=1}
	<!--	tous les utilisateurs -->
	{if isset($listeProfs)}
		<div style="width:100%">
			<input type="checkbox" class="checkListe" name="liste_{$noListe}" style="float: left; margin-right:0.5em">
			<h4 class="teteListe" title="Cliquer pour ouvrir">{$listeProfs.nomListe}</h4>
		</div>

		<ul class="listeMails" style="display:none">
		{assign var=membresProfs value=$listeProfs.membres}
		{foreach from=$membresProfs key=acro item=prof}
			<li><input class="selecteur mails" type="checkbox" name="mails[]" value="{$prof.prenom} {$prof.nom|truncate:15:'...'}#{$prof.mail}">
				<span class="labelProf">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
			</li>
		{/foreach}
		</ul>
	{/if}
	{if isset($listeTitus)}
		{assign var=noListe value=$noListe+1}
		<!--	tous les titulaires (profs principaux) -->
		<div style="width:100%">
			<input type="checkbox" class="checkListe" name="liste_{$noListe}" style="float: left; margin-right:0.5em">
			<h4 class="teteListe" title="Cliquer pour ouvrir">{$listeTitus.nomListe}</h4>
		</div>
		<ul class="listeMails" style="display:none">
		{assign var=membresProfs value=$listeTitus.membres}
		{foreach from=$membresProfs key=acro item=prof}
			<li><input class="selecteur mails" type="checkbox" name="mails[]" value="{$prof.prenom} {$prof.nom|truncate:15:'...'}#{$prof.mail}">
				<span class="labelProf">{$prof.classe} {$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
			</li>
		{/foreach}
		</ul>
	{/if}

	<!-- 	toutes les autres listes personnelles ou publiées -->
	{foreach from=$listesAutres key=idListe item=listePerso}
	{assign var=noListe value=$noListe+1}
	{assign var=membresProfs value=$listePerso.membres}

	<div style="width:100%">
		<input type="checkbox" class="checkListe" name="liste_{$noListe}" style="float: left; margin-right:0.5em">
		<h4 class="teteListe" title="{if $membresProfs == Null}Liste vide{else}Cliquer pour ouvrir{/if} :
			{if $listePerso.statut == 'publie'}Publié{elseif $listePerso.statut == 'abonne'}Abonné{else}Personnel{/if}">{$listePerso.nomListe}
			{if $listePerso.statut == 'publie'}<img src="../images/shared.png" alt="part">{/if}
			{if $listePerso.statut == 'prive'}<img src="../images/personal.png" alt="pers">{/if}
			{if $listePerso.statut == 'abonne'}<img src="../images/abonne.png" alt="abo">{/if}
		</h4>
	</div>

	{if $membresProfs != Null}
	<ul class="listeMails" style="display:none">
			{foreach from=$membresProfs key=acro item=prof}
		<li>
			<input class="selecteur mails" type="checkbox" name="mails[]" value="{$prof.prenom} {$prof.nom|truncate:15:'...'}#{$prof.mail}">
			<span class="labelProf">{$prof.nom|truncate:15:'...'} {$prof.prenom} {$prof.classe|default:''}</span>
		</li>
		{/foreach}
	</ul>
	{/if}
	{/foreach}

</div>  <!-- panel-body -->

</div>  <!-- panel -->
