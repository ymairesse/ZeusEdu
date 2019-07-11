<div class="container">

	<h3>Choix d'initialisation</h3>

	<p>Attention, les commandes <strong class="danger"><span>en rouge</span></strong> ne devraient plus être utilisées après le début de l'année scolaire. Danger de casser le système!!</p>

	<form name="choixInit" id="choixInit" action="index.php" method="POST" role="form" class="form-vertical">
		<ul class="list-unstyled">
			<li>
				<input type="radio" name="mode" value="archivageEleves"{if (isset($mode)) && ($mode == 'archivageEleves')} checked{/if}>
				<span>Archivage des élèves par classe pour l'année scolaire écoulée</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetSituations"{if (isset($mode)) && ($mode == 'resetSituations')} checked{/if}>
				<span>Initialisation des situations de {$ANNEESCOLAIRE} et des épreuves externes</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetDetailsCotes"{if (isset($mode)) && ($mode == 'resetDetailsCotes')} checked="checked"{/if}>
				<span>Effacement du détail des cotes de {$ANNEESCOLAIRE} par compétences dans les bulletins</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="delProfsElevesCours"{if (isset($mode)) && ($mode == 'delProfsElevesCours')} checked="checked"{/if}>
				<span>Effacement des liens profs/eleves avec les cours</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetHistorique"{if (isset($mode)) && ($mode == 'resetHistorique')} checked="checked"{/if}>
				<span>Effacement de l'historique des changements de cours</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetCommentProfs"{if (isset($mode) && ($mode == 'resetCommentProfs'))} checked="checked"{/if}>
					<span>Effacement des commentaires des profs aux bulletins</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetCommentTitus"{if (isset($mode) && ($mode == 'resetCommentTitus'))} checked="checked"{/if}>
				<span>Effacement des commentaires des titulaires aux bulletins</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="initCarnet"{if (isset($mode)) && ($mode == 'initCarnet')} checked="checked"{/if}>
					<span>Initialisation du carnet de cotes</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="delPonderations"{if (isset($mode)) && ($mode == 'delPonderations')} checked="checked"{/if}>
				<span>Suppression de toutes les pondérations des cours</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="ponderations"{if (isset($mode)) && ($mode == 'ponderations')} checked="checked"{/if}>
				<span>Initialisation des pondérations des cours (penser à supprimer les pondérations avant)</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetCoordin"{if (isset($mode)) && ($mode == 'resetCoordin')} checked="checked"{/if}>
				<span>Effacement des notices coordinateurs</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetAttitudes"{if (isset($mode)) && ($mode == 'resetAttitudes')} checked="checked"{/if}>
				<span>Initialisation des "Attitudes"</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetNotifications"{if (isset($mode)) && ($mode == 'resetNotifications')} checked="checked"{/if}>
				<span>Effacement des notifications de décisions Thot</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetEduc"{if isset($mode) && ($mode == 'resetEduc')} checked{/if}>
				<span>Effacement des remarques des éducateurs</span>
			</li>
			<li>
				<input type="radio" name="mode" value="initBulletinThot" {if (isset($mode)) && ($mode == 'initBulletinThot')} checked="checked"{/if}>
				<span>Réinitialisation des accès aux bulletins dans Thot</span>
			</li>
			<li>
				<input type="radio" name="mode" value="verrous"{if (isset($mode)) && ($mode == 'verrous')} checked="checked"{/if}>
				<span>Initialisation des verrous des cours</span>
			</li>
			<li>
				<input type="radio" name="mode" value="images"{if (isset($mode)) && ($mode == 'images')} checked="checked"{/if}>
				<span>Initialisation des images des cours</span>
			</li>
			<li>
				<input type="radio" name="mode" value=""{if (!isset($mode)) || ($mode == '')} checked="checked"{/if}>
				Ne rien faire
			</li>
		</ul>
	<input type="hidden" name="action" value="{$action}">
	{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
	<button type="submit" class="btn btn-primary pull-right" name="Submit">Initialiser</button>
	</form>

</div>


<script type="text/javascript">

$(document).ready(function(){

	$("#choixInit").submit(function(){
		var confirmation = true;
		if ($("#choixInit input:radio:checked").parent().hasClass("danger")) {
			confirmation = confirm("Vous savez ce que vous faites, n'est-ce pas?\nVous avez été assez averti!");
			}
		if (confirmation == true) {
			$.blockUI();
			$("#wait").show();
			}
		else return false;
		})

	})

</script>
