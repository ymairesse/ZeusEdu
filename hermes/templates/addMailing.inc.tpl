<div class="gauche">
<h3>Création d'une liste</h3>
<form name="creation" id="creation" method="POST" action="index.php">
<input type="text" placeholder="Nom de la liste à créer" size="20" maxlenght="32" id="nomListe" name="nomListe">
<input type="submit" name="submit" value="Créer la liste" class="fauxBouton">
<input type="reset" name="reset" value="Annuler">
<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="creationListe">
{if $listesPerso|count > 0}
	<p>Listes existantes</p>
	<table class="tableauHermes">
	<tr>
		<th>Listes</th>
		<th>Membres</th>
	</tr>
	{foreach from=$listesPerso key=idListe item=liste}
	<tr>
		<td title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">{$liste.nomListe}</td>
		<td>{$liste.membres|count}</td>
	</tr>
	{/foreach}
	</table>
{/if}
</form>
<div id="dialogNom" title="Ouuups">
Veuillez donner un nom à cette nouvelle liste
</div>
</div>

<div class="droit">
<h3>Ajout de membres à une liste</h3>
{if $listesPerso|count > 0}
	<form name="ajoutMembres" id="ajoutMembres" method="POST" action="index.php">

	<div style="float:left; border: 1px solid #777; padding: 0.5em">
		Liste existante<br>
		<div class="selectMail">
			<select name="idListe" id="selectListe">
				<option value=''>Veuillez choisir une liste</option>
				{foreach from=$listesPerso key=idListe item=liste}
					<option value="{$idListe}">{$liste.nomListe} -> {$liste.membres|count} membres</li>
				{/foreach}
			</select><br>
			<input type="submit" name="submit" id="submit" value="Ajouter" class="fauxBouton">
			<input type="reset"  name="reset"  id="resetAdd" value="Annuler">
			<input type="hidden" class="onglet" name="onglet" value="{$onglet|default:0}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="ajoutMembres"><br>
			<div style="float:left; width:15em;" id="listeExistants"></div>

		</div>
	</div>

	<div style="float:left; border: 1px solid #777; padding: 0.5em">
		Destinataires à ajouter<br>
		<div class="selectMail">
			<!--	tous les utilisateurs -->
			<ul class="listeMails">
			{assign var=membresProfs value=$listeProfs.membres}
			{foreach from=$membresProfs key=acronyme item=prof}
				<li><input class="selecteur mails mailsAjout" type="checkbox" name="mails[]" value="{$acronyme}">
					<span class="label">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
				</li>
			{/foreach}
			</ul>
		</div>
	</div>
	<p style="clear:both">Sélections: <strong id="selectionAdd">0</strong> destinataire(s)</p>
	</form>

{else}
	<p>Aucune liste définie</p>
{/if}
</div>

<div id="dialogNomListe" title="Choix d'une liste">
	Veuillez choisir une liste de mailing
</div>

<div id="dialogueMembres" title="Choix des destinataires">
	Veuillez choisir au moins un destinataire à ajouter
</div>


<hr style="clear:both">

