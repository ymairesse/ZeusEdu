<h3>Remarque pour la période {$bulletin}</h3>
{* si $blocage > 1, les commentaires sont verrouillés *}
{if $blocage > 1}
<div class="alert alert-danger" role="alert">
	<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
	Les commentaires pour <strong>{$unEleve.prenom} {$unEleve.nom}</strong> ne sont plus modifiables dans ce bulletin.
</div>
{/if}
<textarea
	{if $blocage > 1} readonly="readonly"{/if}
	class="remarque form-control"
	rows="8"
	name="commentaire-eleve_{$matricule}"
	tabIndex="{$tabIndexAutres}"
	>{$listeCommentaires.$matricule.$bulletin|default:Null}</textarea>
