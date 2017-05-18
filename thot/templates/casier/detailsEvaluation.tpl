<form class="form-vertical" id="evalTravail">

    <div class="row">

        <div class="col-sm-2">
            <img src="../photos/{$photo|default:'nophoto'}.jpg" alt="{$evaluationsTravail.data.matricule}" style="width:75px" class="pull-right">
        </div>

        <div class="col-sm-10">
          <p>
              <strong id="fileName" class="nomFichier">
                  <a href="inc/download.php?type=pTrEl&amp;idTravail={$evaluationsTravail.data.idTravail}&amp;matricule={$evaluationsTravail.data.matricule}">
                  {$fileInfos.fileName}
                  </a>
              </strong>
               -> <strong id="fileSize">{$fileInfos.size}</strong><br>
               Remis le: <strong id="dateRemise">{$fileInfos.dateRemise}</strong>
           </p>

           <div class="form-group">
             <label for="remarque">Remarque de l'élève</label>
             <p id="remarque">{$evaluationsTravail.data.remarque|default:'-'}</p>
           </div>

        </div>

    </div>

    <div class="row">

        <div class="col-sm-12">

            <button type="button" tabindex="1" class="btn btn-primary btn-block" id="saveEval">Enregistrer</button>

        </div>
    </div>

    <table class="table table-condensed">
        <thead>
            <tr>
                <th style="width:80%">Compétences</th>
                <th style="width:10%">Cote</th>
                <th style="width:10%">Max</th>
            </tr>
        </thead>
        <tbody>
            {assign var=n value=2}
            {foreach from=$competencesTravail key=idCompetence item=data}
            <tr>
                <td>{$data.libelle}</td>
                <td><input type="text" name="cote_{$idCompetence}" class="form-control input-sm" value="{$evaluationsTravail.cotes.$idCompetence.cote|default:''}"
                    tabindex="{$n}"></td>
                <td>
                    <strong>/ {$data.max}</strong>
                    <input type="hidden" name="max_{$idCompetence}" class="maxCompetence" value="{$data.max}">
                </td>
            </tr>
            {assign var=n value=$n+1}
            {/foreach}
        </tbody>

    </table>

    <div class="form-group">
        <label for="evaluation">Évaluation du professeur</label>
        <textarea name="evaluation" class="form-control" id="editeurEvaluation" tabindex="{$n}">{$evaluationsTravail.data.evaluation|default:''}</textarea>
    </div>

    <input type="hidden" name="idTravail" value="{$evaluationsTravail.data.idTravail}">
    <input type="hidden" name="matricule" id="matriculeEval" value="{$evaluationsTravail.data.matricule}">

</form>

<script type="text/javascript">

    $(document).ready(function(){

        CKEDITOR.replace('editeurEvaluation');

        $("input").tabEnter();

    })

</script>
