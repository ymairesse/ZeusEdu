<div style="border: 1px solid red; padding: 0.5em;">
    {$nomParent}
    <p>Le rendez-vous avec <strong>{$nomProf}</strong> à la réunion de parents du <strong>{$infoRV.date} à {$infoRV.heure}</strong> a dû être annulé pour la raison suivante:</p>

    <div id="raison">
        <textarea name="raison" id="raisonDel" class="form-control" rows="2" placeholder="Votre texte ici" style="background:pink;"></textarea>
    </div>

    <p>Veuillez excuser le caractère impersonnel de ce courriel automatique. Si nécessaire, vous pouvez me recontacter en répondant simplement à ce mail.</p>
    <p>Merci pour votre compréhension.</p>
    <p>{$signature}</p>
</div>


<!-- Notes pour l'édition de ce texte -->

<!-- les informations entre les balises { } ne devraient pas être supprimées; elles seront remplacées avant l'envoi du mail
Le  bloc <div id="raison"> .... </div> ne doit pas être modifié -->
