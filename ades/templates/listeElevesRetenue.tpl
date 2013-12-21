<h3>{$infosRetenue.jourSemaine|ucfirst}, le {$infosRetenue.dateRetenue}</h3>
<h4>{$infosRetenue.titrefait}: {$infosRetenue.local} {$infosRetenue.heure} durée: {$infosRetenue.duree}h</h4>
<p>Nombre d'élèves {$infosRetenue.occupation} / {$infosRetenue.places}</p>

<table class="tableauAdmin" style="width:100%">
	<tr>
		<th>&nbsp;</th>
		<th>Nom de l'élève</th>
		<th>Classe</th>
		<th>Travail à effectuer</th>
		<th>Professeur</th>
		<th>Présent</th>
		<th>Signé</th>
	</tr>
	{assign var=n value=1}
	{foreach from=$listeEleves key=matricule item=unEleve}
		<tr>
		<th>{$n}</th>
		<td title="{$matricule}">{$unEleve.nom} {$unEleve.prenom}</td>
		<td>{$unEleve.groupe|default:'&nbsp;'}</td>
		<td>{$unEleve.travail|default:'&nbsp;'}</td>
		<td>{$unEleve.professeur|default:'&nbsp;'}</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		{assign var=n value=$n+1}
		</tr>
	{/foreach}
	
</table>

