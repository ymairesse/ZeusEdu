<h2>J'ai oublié mon mot de passe ÉTAPE 1</h2>

<div class="row">

    <h3>Obtenir le lien pour changer mon mot de passe</h3>

    <div class="col-md-3 col-sm-6">

        <p>Il nous faut votre nom d'utilisateur.</p>

        <form name="user" id="user" method="POST" action="index.php" autocomplete="off" role="form" class="form-vertical">

            <div class="input-group">
                <label for="userName" class="sr-only">Nom d'utilisateur</label>
                <input type="text" name="userName" id="userName" value="" placeholder="Nom d'utilisateur" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary">Envoyer la demande</button>
            <input type="hidden" name="action" value="{$action}">

        </form>

    </div>

    <div class="col-md-5 col-sm-6">

        <p>Nous n'avons aucun moyen de connaître votre mot de passe. Il est donc impossible de vous le rappeler.</p>
        <p>Par contre, nous pouvons vous transmettre par mail le lien vers une page sur laquelle vous pourrez changer de mot de passe.</p>
        <p>Le message contenant le lien sera envoyé sur votre adresse mail professionnelle; en principe, il s'agit de votre adresse liée à l'école, celle qui figure dans votre "profil".</p>
        <p>Le lien que vous recevrez vous permettra de changer de mot de passe dans un délai de 48h à dater du moment où vous faites la demande. Au-delà, il faudra que vous fassiez une nouvelle demande.</p>

    </div>

    <div class="col-md-2 col-sm-12 img-responsive">

        <img src="images/Password.png" alt="passwd">

    </div>

</div>  <!-- row -->

<script type="text/javascript">

$(document).ready(function(){

    $("#user").validate();

})


</script>
