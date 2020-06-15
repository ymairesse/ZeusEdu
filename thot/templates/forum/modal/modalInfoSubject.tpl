<div id="modalInfoSubject" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalInfoSubjectLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalInfoSubjectLabel">Informations</h4>
            </div>
            <div class="modal-body">
                <div class="row">

                <div class="col-xs-6">
                    <h4>Catégorie</h4>

                    <p>{if $infoCategorie.userStatus == 'eleves'}<i class="fa fa-user"></i>{else}<i class="fa fa-mortar-board"></i>{/if}
                        <strong>{$infoCategorie.libelle}</strong></p>
                    <h4>Sujet</h4>
                    <p><strong>{$infoSujet.sujet}</strong><br>créé par <strong>{$infoSujet.nomProf}</strong><br>le {$infoSujet.ladate} à {$infoSujet.heure}</p>

                </div>

                <div class="col-xs-6">

                    <h4>Sujet pour</h4>
                    <p>{if $infoCategorie.userStatus == 'eleves'}<strong class="eleves">Élèves et professeurs{else}<strong class="profs">Professeurs{/if}</strong></p>


                    <strong>
                    {if $infoSujet.forumActif == 1}
                        <span class="text-success">Visible par tous les invités <i class="fa fa-user"></i> <i class="fa fa-mortar-board"></i></span>
                        {elseif $infoSujet.forumActif == 2}
                        <span class="text-danger">Invisible pour les élèves <i class="fa fa-user"></i></span>/<span class="text-success">Visible pour les profs <i class="fa fa-mortar-board"></i></span>
                        {else}
                        <span class="text-danger">Invisible pour tous <i class="fa fa-user"></i> <i class="fa fa-mortar-board"></i></span>
                        {/if}
                    </strong>

                    <h4>Invités à cette conversation</h4>

                    <div style="max-height:10em; overflow:auto;">
                        {foreach from=$listeAbonnes key=type item=dataAbonnes}

                            {if $type == 'prof'}
                                <ul>
                                    {foreach from=$dataAbonnes key=acronyme item=nomProf}
                                    <li>{$nomProf}</li>
                                    {/foreach}
                                </ul>
                            {/if}

                            {if $type == 'ecole'}
                                <strong>Tous les élèves de l'école</strong>
                            {/if}

                            {if $type == 'niveau'}
                                <ul>
                                {foreach from=$dataAbonnes key=niveau item=niveau}
                                    <li>{$niveau}e année</li>
                                {/foreach}
                                </ul>
                            {/if}

                            {if $type == 'coursGrp'}
                            <ul>
                            {foreach from=$dataAbonnes key=coursGrp item=wtf}
                                <li>Les élèves du cours {$coursGrp}</li>
                            {/foreach}
                            </ul>
                            {/if}

                            {if $type == 'classe'}
                                <ul>
                                {foreach from=$dataAbonnes key=groupe item=groupe}
                                <li>Classe {$groupe}</li>
                                {/foreach}
                                </ul>
                            {/if}

                        {/foreach}
                    </div>
                </div>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btn-okSubject">Terminer</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#btn-okSubject').click(function(){
            $('.close').trigger('click');
        })
    })

</script>
