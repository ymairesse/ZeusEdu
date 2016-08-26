<h3>Vos connexions</h3>

<div class="col-md-8 col-sm-12">

    <div class="table-responsive">

        <table class="table table-condensed table-striped table-hover">
            <thead>
                <tr>
                    <th width="100">Date</th>
                    <th width="100">Heure</th>
                    <th width="150">Adresse IP *</th>
                    <th>Hôte</th>
                </tr>
            </thead>
            {foreach from=$logins item=unLogin}
            <tr>
                <td>{$unLogin.date}</td>
                <td>{$unLogin.heure}</td>
                <td>{$unLogin.ip}</td>
                <td>{$unLogin.host}</td>
            </tr>
            {/foreach}
        </table>

    </div>

</div>
<!-- col-md-.. -->

<div class="col-md-4 col-sm-12">

    <div class="notice">

        <p>* L'adresse IP est une adresse unique dans le monde, un peu semblable à un numéro de téléphone, et qui identifie une connexion à l'Internet.
        <br> Plusieurs ordinateurs peuvent partager la même adresse IP s'ils sont connectés au même modem (cas d'une école, par exemple).
        <br> Il peut arriver que l'adresse IP qui vous est attribuée change d'un jour à l'autre. Mais le nom du fournisseur d'accès reste fixe si vous gardez le même contrat.</p>
        <p>Si vous constatez des connexions qui ne sont manifestement pas de votre fait, modifiez immédiatement votre mot de passe et prévenez les administrateurs</p>

    </div>
    <!-- notice -->

</div>
<!-- col-md-...  -->
