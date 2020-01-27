<div class="panel">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-target="#collapse5" href="#collapse5">Informatique</a>
        </h4>
    </div>

    <div id="collapse5" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-4 col-sm-6">

                <div class="form-group">
                    <label for="userName">Nom d'utilisateur</label>
                    <p id="userName" class="code form-control-static">{$info.user|default:''}</p>
                </div>
            </div>

            <div class="col-md-4 col-sm-6">

                <div class="form-group">
                    <label for="mailDomain">Domaine mail</label>
                    <p class="code form-control-static">{$eleve.mailDomain|default:''}</p>
                </div>

            </div>

            <div class="col-md-4 col-sm-6">

                <div class="form-group">
                    <label for="mdp">Mot de passe</label>
                    <div class="input-group">
                        <input type="password" class="form-control" value="{$info.passwd|default:''}" id="passwd" disabled>
                        <span class="input-group-btn">
                           <button class = "btn btn-primary" id="eye" type = "button">
                              <i class="fa fa-eye"></i>
                           </button>
                        </span>
                    </div>
                    <p class="help-block">Cliquer pour voir</p>
                </div>
                <button type="button" class="btn btn-primary pull-right" id="resetPasswd">Réinitialiser le mdp</button>

            </div>

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
