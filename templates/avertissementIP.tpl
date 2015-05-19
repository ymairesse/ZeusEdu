<div id="avertissement" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Avertissement</h4>
            </div>
            <div class="modal-body">
                <p>Votre connexion provient de l'adresse IP <strong>{$ip} - {$hostname}</strong>. Ces informations sont enregistrées sur notre serveur.</p>
				<p>Vous n'avez encore jamais été connecté(e) par cette adresse.</p>
				<p><strong>C'est peut-être normal</strong>! C'est peut-être aussi l'indice d'un accès frauduleux à la plate-forme.</p>
				<p>Un mail d'information vient d'être envoyé à votre adresse professionnelle et aux administrateurs; la date et l'heure de connexion y sont indiquées.</p>
				<p>Si nécessaire, suivez les instructions qui vous sont données dans ce mail.</p>
				<p>Sinon, vous pouvez négliger ce message.</p>
				<p>Pour plus d'explications, voyez <a href="manuel/index.php?page=info&amp;cible=ip" target="_blank">la page d'informations</a>.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
	
	$('document').ready(function(){
		$('#avertissement').modal('show');
		})
	
</script>