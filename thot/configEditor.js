CKEDITOR.replace('enonce', {
  toolbar: [
          { name: 'styles', items: [ 'Format' ] },
          { name: 'tools', items: [ 'Maximize' ] },
          { name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
          { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo' ] },
          { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Scayt' ] },
          '/',
          { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Strike','Underline','-', 'RemoveFormat' ] },
          { name: 'paragraph', groups: [ 'list', 'align' ], items: [ 'NumberedList', 'BulletedList' ] },
          { name: 'colors', items : [ 'TextColor','BGColor' ] },
          { name: 'links', items: [ 'Link', 'Unlink'] },
          { name: 'insert', items : [ 'Image','Table','HorizontalRule','Smiley' ] },
         ]
     }
 );
