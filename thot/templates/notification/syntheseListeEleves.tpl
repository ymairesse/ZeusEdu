<div class="panel panel-default">

    <div class="panel-heading">
        <h4 class="panel-title" id="titrePanneau">
            {if $notification.type == 'cours'}
        	Notification pour le cours {$notification.destinataire} {/if}
        	{if $notification.type == 'classes'}
        	Notification pour la classe {$notification.destinataire} {/if}
        	{if $notification.type == 'niveau'}
        	Notification pour tous les élèves de {$notification.destinataire}e {/if}
        	{if $notification.type == 'ecole'}
        	Notification pour tous les élèves {/if}
        </h4>

    </div>

    <div class="panel-body">

            <div style="height:35em; overflow:auto;">
                {if $listeMatricules != ''}
                    <ul style="padding-left:1em">
                    {foreach from=$listeEleves key=matricule item=eleve}
                        {if in_array($matricule, array_keys($listeMatricules))}
                            <li><strong>{$eleve.nom} {$eleve.prenom}</strong></li>
                        {/if}
                    {/foreach}
                    </ul>
                {else}
                    <strong>Tous les élèves</strong>
                {/if}
            </div>

    </div>

</div>
