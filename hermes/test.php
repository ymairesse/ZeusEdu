<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title></title>
    <script type="text/javascript" src='../js/jquery-2.1.3.js'></script>
    <script src="../dropzone/dropzone.js" charset="utf-8"></script>
    <link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="../bootstrap/js/bootstrap.js"></script>
    <link href="../bootstrap/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="../bootstrap/fa/css/font-awesome.min.css" type="text/css" media="screen, print">

</head>

<body>
    <form id="myDropzone" class="dropzone">
        <div class="dropzone-previews"></div>
        <!-- this is were the previews should be shown. -->

        <!-- Now setup your input fields -->
        <input type="email" name="username" />
        <input type="password" name="password" />

        <button type="submit" id="submitBtn">Submit data and files!</button>
    </form>


<script type="text/javascript">
    $(document).ready(function() {

        Dropzone.options.myDropzone = {

            autoProcessQueue: false,
            uploadMultiple: true,
            parallelUploads: 100,
            maxFiles: 100,
            url: 'inc/uploadDS.php',

            // The setting up of the dropzone
            init: function() {
                var myDropzone = this;

                this.on("addedfile", function(file) {
                    var removeButton = Dropzone.createElement("<button type='button' class='btn btn-xs btn-block'><i class='fa fa-plus'></i></button>");
                    // Capture the Dropzone instance as closure.
                    var _this = this;

                    removeButton.addEventListener("click", function(e) {
                        // Remove the file preview.
                        _this.removeFile(file);
                    });

                    // Add the button to the file preview element.
                    file.previewElement.appendChild(removeButton);
                });

                // First change the button to actually tell Dropzone to process the queue.
                $("#submitBtn").click(function(event){
                    // Make sure that the form isn't actually being sent.
                    event.preventDefault();
                    event.stopPropagation();
                    myDropzone.processQueue();
                });


                // Listen to the sendingmultiple event. In this case, it's the sendingmultiple event instead
                // of the sending event because uploadMultiple is set to true.
                this.on("sendingmultiple", function() {
                    // Gets triggered when the form is actually being sent.
                    // Hide the success button or the complete form.
                });
                this.on("successmultiple", function(files, response) {
                    // Gets triggered when the files have successfully been sent.
                    // Redirect user or notify of success.
                });
                this.on("errormultiple", function(files, response) {
                    // Gets triggered when there was an error sending the files.
                    // Maybe show form again, and notify user of error
                });
            }

        }

    })
</script>

</body>
</html>
