<h2>{$dataEleve.nom} {$dataEleve.prenom} : {$dataEleve.classe}</h2>

<ul class="nav nav-tabs nav-justified" id="tabs">
    <li><a data-toggle="tab" href="#perso">Données personnelles</a></li>
    <li><a data-toggle="tab" href="#parents">Parents et responsables</a></li>
    <li><a data-toggle="tab" href="#infoMedic">Informations médicales {if $medicEleve.info != ''}<i class="fa fa-heartbeat faa-pulse animated" style="font-size:1.2em; color: red"></i>{/if}</a></li>
    <li><a data-toggle="tab" href="#visites">Visites à l'infirmerie <span class="badge" style="color:red; background: white">{$consultEleve|@count}</span></a></li>
</ul>

<div class="tab-content">
    <div id="perso" class="tab-pane fade in active">
        {include file="donneesPerso.tpl"}
    </div>

    <div id="parents" class="tab-pane fade in">
        {include file="donneesParents.tpl"}
    </div>

    <div id="infoMedic" class="tab-pane fade in">
        {include file="infoMedic.tpl"}
    </div>

    <div id="visites" class="tab-pane fade in">
        {include file="visitesInfirmerie.tpl"}
    </div>
</div>
