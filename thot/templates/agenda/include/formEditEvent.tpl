<form id="formEditAgenda">

    <div class="row">

        <div class="col-md-4 col-xs-12">
            <div class="form-group">
                <label for="startDate" class="sr-only">Date de début</label>
                <input placeholder="Date de début"
                    type="text"
                    name="startDate"
                    id="startDate"
                    value="{$event.startDate}"
                    data-keep="{$event.startDate}"
                    class="form-control {if ($editPossible)}datepicker{/if}"
                    {if !($editPossible)} readonly{/if}>
                <span class="help-block">Date début</span>
            </div>
        </div>
        <div class="col-md-3 col-xs-12">
            <div class="form-group">
                <label for="startTime" class="sr-only">Heure</label>
                <input placeholder="Heure de début"
                type="text"
                name="startTime"
                id="startTime"
                value="{$event.startTime|truncate:5:''}"
                data-keep="{$event.startTime}"
                class="form-control timepicker"
                {if $event.allDay == 1} disabled{/if}
                {if !($editPossible)} readonly{/if}>
                <span class="help-block">H. début</span>
            </div>
        </div>

        <div class="col-md-5 col-xs-12">
            <div class="form-group">
                <label for="selectCategorie" class="sr-only">Catégorie</label>
                <select class="form-control" name="categorie" id="selectCategorie"{if !($editPossible)} readonly{/if}>
                    <option value="">Veuillez choisir</option>
                    {foreach from=$categories key=idCat item=data}
                        <option data-classe="{$data.classe}"
                            value="{$idCat}"
                            {if ($idCat == $event.idCategorie)} selected{/if}
                            {if !($editPossible)} disabled{/if}>
                            {$data.categorie}
                        </option>
                    {/foreach}
                </select>
                <span class="help-block">Type d'événement</span>
            </div>

        </div>

        <div class="col-md-4 col-xs-12">
            <div class="form-group">
                <label for="endDate" class="sr-only">Date de fin</label>
                <input placeholder="Date de fin"
                    type="text"
                    name="endDate"
                    id="endDate"
                    value="{$event.endDate}"
                    data-keep="{$event.endDate}"
                    class="form-control{if $editPossible} datepicker{/if}"
                    {if !($editPossible)} readonly{/if}>
                <span class="help-block">Date Fin</span>
            </div>
        </div>
        <div class="col-md-3 col-xs-12">
            <div class="form-group">
                <label for="endTime" class="sr-only">Heure</label>
                <input placeholder="H. fin"
                    type="text"
                    name="endTime"
                    id="endTime"
                    value="{$event.endTime|truncate:5:''}"
                    data-keep="{$event.endTime|truncate:5:''}"
                    class="form-control {if $editPossible}timepicker{/if}"
                    {if $event.allDay == 1} disabled{/if}
                    {if !($editPossible)} readonly{/if}>
                <span class="help-block">Heure de Fin</span>
            </div>
        </div>
        <div class="col-md-5">
            <div class="checkbox">
                <label>
                    <input type="checkbox"
                        id="allDay"
                        name="allDay"
                        value="1"
                        {if $event.allDay == 1} checked{/if}
                        {if !($editPossible)} readonly{/if}>
                    Journée entière
                </label>
            </div>
        </div>

        <div class="col-xs-12">
            <div class="form-group">
                <label for="title" class="sr-only">Titre</label>
                <input type="text"
                    name="title"
                    id="title"
                    value="{$event.title}"
                    class="form-control"
                    placeholder="Titre de votre note"
                    {if !($editPossible)} readonly{/if}>
            </div>
        </div>

        <div class="col-xs-12">
            <div class="form-group">
                <label for="enonce">Texte de la note</label>
                <textarea name="enonce"
                    id="enonce"
                    class="form-control ckeditor"{if !($editPossible)} readonly{/if}>{$event.enonce}</textarea>
            </div>
        </div>

        <input type="hidden" name="idPost" value="{$event.idPost|default:''}">
        <input type="hidden" name="idAgenda" value="{$event.idAgenda}">

        <div class="clearfix"></div>
        {if $editPossible}
            <button type="button" class="btn btn-danger" id="btn-delete" data-idpost="{$event.idPost|default:''}"{if !(isset($event.idPost))} disabled{/if}>Effacer cette note</button>

            <div class="btn-group pull-right">
                <button type="reset" name="reset" class="btn btn-default">Annuler</button>
                <button type="button" class="btn btn-primary pull-right" name="button" id="saveEdit">Enregistrer</button>
            </div>
        {/if}

    </div>
</form>
