
<form class="form-vertical" id="evalTravail">

    <div class="row">

        <div class="col-sm-2">
            <img src="{$BASEDIR}photos/{$photo}.jpg" alt="{$matricule}" class="img-responsive">
        </div>

        <div class="col-sm-10">
            <button type="button" class="btn btn-info btn-sm pull-right" id="consignes" title="Consignes" data-idtravail="{$infoTravail.idTravail|default:'-'}"><i class="fa fa-graduation-cap"></i></button>
            <p>
              <strong id="fileName" class="nomFichier">
                  <a href="inc/download.php?type=pTrEl&amp;idTravail={$infoTravail.idTravail}&amp;matricule={$matricule}">
                  {$fileInfos.fileName|default:'-'}
                  </a>
              </strong>
               -> <strong id="fileSize">{$fileInfos.size}</strong><br>
               Remis le: <strong id="dateRemise">{$fileInfos.dateRemise|default:'-'}</strong>
           </p>

           <div class="form-group">
             <label for="remarque">Remarque de l'élève</label>
             <p id="remarque">{$evaluationsTravail.data.remarque|default:'-'}</p>
           </div>

        </div>

    </div>

    <table class="table table-condensed">
        <thead>
            <tr>
                <th style="width:70%">Compétences</th>
                <th style="width:10%">Form/Cert</th>
                <th style="width:10%">Cote</th>
                <th style="width:10%">Max</th>
            </tr>
        </thead>
        <tbody>
            {assign var=n value=2}
            {foreach from=$competencesTravail key=idCompetence item=data}
            <tr>
                <td>{$data.libelle}</td>
                <td>{if $data.formCert == 'form'}Formatif{else}Certificatif{/if}</td>
                <td><input type="text" name="cote_{$idCompetence}" class="form-control input-sm" value="{$evaluationsTravail.cotes.$idCompetence.cote|default:''}"
                    tabindex="{$n}"></td>
                <td>
                    <strong>/ {$data.max}</strong>
                    <input type="hidden" name="max_{$idCompetence}" class="maxCompetence" value="{$data.max|default:''}">
                </td>
            </tr>
            {assign var=n value=$n+1}
            {/foreach}
        </tbody>
    </table>

    <button type="button" tabindex="1" class="btn btn-primary btn-block" id="saveEval">Enregistrer</button>

    <div class="form-group">
        <label for="evaluation">Évaluation du professeur</label>
        <textarea name="evaluation" class="form-control" id="editeurEvaluation" tabindex="{$n}">{$evaluationsTravail.commentaire|default:''}</textarea>
    </div>

    <input type="hidden" name="idTravail" value="{$infoTravail.idTravail}">
    <input type="hidden" name="matricule" id="matriculeEval" value="{$matricule}">

</form>

<script type="text/javascript">

    $(document).ready(function(){

        CKEDITOR.replace('editeurEvaluation');

        $("input").tabEnter();

    })

</script>
