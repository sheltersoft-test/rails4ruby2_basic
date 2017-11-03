$(document).ready(function(){

  submit_form = false;

  window['finalPhotos'] = new Object();
  var uniqueKey = 0;

  window['finalFiles'] = new Object();
  window['uniqueFileKey'] = new Object();

  initiateRemoteFileSave('body');

  window['finalCoords'] = new Object();
  window['cropPhoto'] = true;

  if (window['cropPhoto']) {
    $(document).on("click", "#reupload_photo", function (event) {
      $("#remove_photo").trigger('click');
      $("#upload_photos").trigger('click');
    });

    $(document).on("click", "#remove_photo", function (event) {
      if($('#user-photo').data('Jcrop')) {
        jcrop_api.destroy();
        if (Object.keys(window['finalPhotos']).length > 0) {
          delete window['finalPhotos'][uniqueKey];
        }
        $('#user-photo').removeAttr('style');
        $("#user-photo").attr("src","");
        $("#upload_photos")[0] = "";
        $('#user-photo').hide();
      }
    });

    $(document).on("change", "#upload_photos", function (event) {
        $('#user-image-crop').modal('show');
        var reader = new FileReader();
        reader.readAsDataURL($(this)[0].files[0]);
        reader.onloadend = function() {
        image_src = reader.result;
          setImageCrop(image_src)
        }
        uniqueKey += 1;
        window['finalPhotos'][uniqueKey] = $("#upload_photos")[0].files[0];
        $("#upload_photos").val("");
    });

    $(document).on("click", "#btnCrop", function (e) {
      parentEl = "#preview_files";
      id = "#upload_photos"
      var removePreviewFileEle = "<div class='col-xs-12 remove-preview-file' id=remove-preview-file-" + uniqueKey + "><i class='fa fa-times'></i></div>";
      var canvas_id = "preview_file_"+uniqueKey ;
      var preview_class = "image";
      var width = $('#imgWidth').val();
      var height = $('#imgHeight').val();
      //fixed height 120*120 for canvas and same for draw image
      $(parentEl).append("<li class='canvas canvas-file' id=file-" + uniqueKey+ ">" + removePreviewFileEle + "<div class='col-xs-12 col-sm-6'><canvas height='120' width='120' id="+canvas_id+" class='preview "+ preview_class +"'/></div></li>");
      add_crop_image_on_canvas(window['finalPhotos'][uniqueKey], canvas_id);
      $('#user-image-crop').modal('hide');
      $("#upload_photos").val("");
    });

    function setImageCrop(url){
      if($('#user-photo').data('Jcrop')) {
        jcrop_api.destroy();
      }

      if ($( window ).width() <= 991){
        boxWidth = 250;
        boxHeight = 300;
      }
      else{
        boxWidth = 380;
        boxHeight = 400;
      }

      $('#user-photo').attr('src', url).Jcrop({
        boxWidth: boxWidth,
        onChange: setCoordinates,
        onSelect: setCoordinates,
        setSelect: [10,10,250,200],
        allowSelect: true,
        allowMove: true,
        allowResize: true
      }, function(){ jcrop_api = this; });
    }

    function add_crop_image_on_canvas(src, canvas_id){
      var img = new Image;
      if (typeof(src) == "string"){
        img.src = src;
      }
      else{
        img.src = URL.createObjectURL(src);
      }
      img.onload = function(){
        var x1 = $('#imgX1').val();
        var y1 = $('#imgY1').val();
        var width = $('#imgWidth').val();
        var height = $('#imgHeight').val();
        var canvas = document.getElementById(canvas_id)
        var ctx = canvas.getContext('2d');
        if ((width == 0) && (height == 0)){
          // if user does not select any crop area then take the original image
          ctx.drawImage(img,0,0,img.width,img.height,0,0,120,120);
        }else{
          ctx.drawImage(img, x1, y1, width, height, 0, 0, 120, 120);
        }
      }
    }

    function setCoordinates(c) {
      $('#imgX1').val(c.x);
      $('#imgY1').val(c.y);
      $('#imgWidth').val(c.w);
      $('#imgHeight').val(c.h);
      if ((c.w != 0) && (c.h != 0)){
        window['finalCoords'][uniqueKey] = [c.w, c.h, c.x, c.y]
      }else{
        window['finalCoords'][uniqueKey] = []
      }
    }
  }
  else{
    $(document).on("change", "#upload_photos", function (event) {
      initiatePreviewPhotos(event, "#upload_photos", $("#preview_files"));
    });
  }
  // crop end

  $("#preview_files").on("click", ".canvas-file", function(event){
    if ($(this).attr("id")) {
      var idArr = this.id.split("-");
      var id = idArr[idArr.length - 1];
      delete window['finalPhotos'][id];  
      $("#file-"+id).remove();
    }
  });

  $(document).on("change", ".upload_files", function (event) {
    var formID = $(this).closest('form').attr('id');
    var uploadFileEleId = $(this).attr("id");
    initiatePreviewFiles(event, ".upload_files", $("#preview_attachments"+uploadFileEleId), formID, uploadFileEleId);
  }); 

  $(document).on("click", ".remove-preview-file, .remove-file", function(){    
    if ($(this).attr("id")) {
      var removeFile = $(this).attr('id');
      var removeFileArr = removeFile.split("-");
      var findex = removeFileArr[removeFileArr.length - 1];
      var uploadFileEleId = removeFileArr[removeFileArr.length - 2];
      //finalFiles[parseInt(index)] = '';
      var form = $(this).closest('form');
      var formID = $(form).attr('id');
      delete window['finalFiles'][formID][uploadFileEleId][parseInt(findex)];
      $(form).find("#file" + uploadFileEleId + "-" + findex).remove();
    }
  });
});

function removeMedia(mediaId, removingElementId, ObjId, ObjType, msg) {
  var premission = confirm(msg);
  if (premission == true) {
    $.ajax({
      url: '/resources/'+ObjId+'/delete_media',
      method: 'POST',
      data: {'media_id': mediaId, 'type': ObjType},
      success: function(result){
        if (result["success"] == true) {
          if ($('#' + removingElementId).length > 0) {
            $('#' + removingElementId).remove();
          }
        }
        else {
          $("#save_delete_media_error").html("<div class='alert alert-dismissible alert-danger'><button class='close' data-dismiss='alert' type='button'>×</button>"+$('#error_msg').val()+"</div>")
        }
      },
      error: function(error){
        $("#save_delete_media_error").html("<div class='alert alert-dismissible alert-danger'><button class='close' data-dismiss='alert' type='button'>×</button>"+$('#error_msg').val()+"</div>")
      }
    })
  }
}

function saveFiles (event, btn, uploadFileEleId, formID) {
  if (submit_form == false) {      
    event.preventDefault();
    if (window['finalFiles'][formID][uploadFileEleId] != undefined) {
      if (Object.keys(window['finalFiles'][formID][uploadFileEleId]).length > 0) {
        var formData = new FormData();
        var keys = Object.keys(window['finalFiles'][formID][uploadFileEleId]);
        keys.forEach(function(key){
          var file = window['finalFiles'][formID][uploadFileEleId][key];
          formData.append('media[]', file);
        });

        var form = $("#" + formID);
        formData.append('resource_type', $(form).find("#resource_type_name"+uploadFileEleId).val());
        formData.append('resource_spec', $(form).find("#resource_spec_name"+uploadFileEleId).val());
        formData.append('type', $(form).find("#object_type"+uploadFileEleId).val());
        id = $(form).find("#object_id"+uploadFileEleId).val();
        var DataUrl = '/resources/'+id+'/save_media';
        var type = 'POST';
        
        $("#loader-image, .pre-icon").show();
        $.ajax({
          url: DataUrl,
          type: type,
          data: formData,
          processData: false,
          contentType: false,
          success: function(result){
            if ($("#form_submit").length > 0) {
              window.location = window.location.href;
            }
            formUploadFileEles = $("#" + formID).find(".upload_files");
            if (uploadFileEleId == $(formUploadFileEles[formUploadFileEles.length - 1]).attr('id')) {
              removeListenerAndSubmit(btn);
            }
          },
          error: function(error){
            $("#loader-image").hide();
            $("#save_delete_media_error").html("<div class='alert alert-dismissible alert-danger'><button class='close' data-dismiss='alert' type='button'>×</button>"+$('#error_msg').val()+"</div>")
          }
        });
      } else {
        formUploadFileEles = $("#" + formID).find(".upload_files");
        if (uploadFileEleId == $(formUploadFileEles[formUploadFileEles.length - 1]).attr('id')) {
          removeListenerAndSubmit(btn);
        }
      }
    } else {
      formUploadFileEles = $("#" + formID).find(".upload_files");
      if (uploadFileEleId == $(formUploadFileEles[formUploadFileEles.length - 1]).attr('id')) {
        removeListenerAndSubmit(btn);
      }     
    }
  }
  else {
    removeListenerAndSubmit(btn);
  }
}

function savePhotos (event, btn, index) {
  if (submit_form == false) {      
    event.preventDefault();
    var f_files = window['finalPhotos'];

    if (f_files != undefined) {
      if (Object.keys(f_files).length > 0) {
        var formData = new FormData();
        var keys = Object.keys(f_files);
        keys.forEach(function(key){
          var file = f_files[key];
          formData.append('media[]', file);
          if (window['cropPhoto']){
            var file_cooridinate = window['finalCoords'][key];
            formData.append('coordinate[]', file_cooridinate);
          }
        });
        formData.append('resource_type', $("#resource_type_name").val());
        formData.append('resource_spec', $("#resource_spec_name").val());
        formData.append('type', $("#object_type").val());
        id = $("#object_id").val();
        $("#loader-image, .pre-icon").show();
        $.ajax({
          url: '/resources/'+id+'/save_media',
          type: 'POST',
          data: formData,
          processData: false,
          contentType: false,
          success: function(result){
            removeListenerAndSubmit(btn);
          },
          error: function(error){
            $("#loader-image").hide();
            $("#save_delete_media_error").html("<div class='alert alert-dismissible alert-danger'><button class='close' data-dismiss='alert' type='button'>×</button>"+$('#error_msg').val()+"</div>")
          }
        });
      } else {
        removeListenerAndSubmit(btn);
      }
    } else {
      removeListenerAndSubmit(btn);
    }
  }
  else {
    removeListenerAndSubmit(btn);
  }
}

function initiateRemoteFileSave(mainParentEle){

  var allForms = $(mainParentEle).find('form');

  var formsWithResources = [];

  $.each(allForms, function(index, form){
    if ($(form).find('.upload_files').length > 0 || $(form).find('#upload_photos').length > 0){
      formsWithResources.push($(form));
      $(form).attr('class', 'form-with-resource');
    }
  });

  var startIndexForFormWithoutId = $('.form-with-resource').length;

  if (formsWithResources.length > 0){
    $.each(formsWithResources, function(index, formEle){
      var form = $(formEle);
      var formID = $(form).attr('id');
      window['finalFiles'][formID] = {};
      window['uniqueFileKey'][formID] = {};
      $.each($(form).find('.upload_files'), function(index, uploadFileEle){
        uploadFileEleId = $(uploadFileEle).attr('id');
        window['finalFiles'][formID][uploadFileEleId] = {};
        window['uniqueFileKey'][formID][uploadFileEleId] = 0;
      });

      var submitBtns = $(form).find("[type=submit]");
      $.each(submitBtns, function(index, submitBtn){
        $(submitBtn).on('click', function(event){
          if ($(form).find("#upload_photos").length > 0) {
            savePhotos(event, submitBtn, '');
          }
          if ($(form).find(".upload_files").length > 0) {
            submit_form = false
            $.each($(form).find('.upload_files'), function(index, uploadFileEle){
              uploadFileEleId = $(uploadFileEle).attr('id');
              saveFiles(event, submitBtn, uploadFileEleId, formID);
            });
          } 
        });
      });
    });
  }
}

function removeListenerAndSubmit(btn){
  $(btn).off("click");
  submit_form = true;
  $(btn).click();
}

function initiatePreviewPhotos(event, id, parentEl){
  if ($(id).val() != ""){
    var tgt = event.target || window.event.srcElement;
    var files = tgt.files;
    if (FileReader && files && files.length) {
      for(var i=0; i < files.length; i++) {
        var removePreviewFileEle = ""
        if (id == "#upload_photos"){
          window['finalPhotos'][uniqueKey]=files[i];
          removePreviewFileEle = "<div class='col-xs-12 remove-preview-file' id=remove-preview-file-" + uniqueKey.toString() + "><i class='fa fa-times'></i></div>";
        }
        var canvas_id = "preview_file_" + uniqueKey.toString();
        var preview_class = getPreviewClassFromName(files[i].name);
        var view_name = files[i].name;
        if (view_name.length > 17){
          var view_name_arr = view_name.split(".")
          view_name =  view_name.slice(0,8) + "[...]." + view_name_arr[view_name_arr.length-1]
        }
        $(parentEl).append("<li class='canvas canvas-file' id=file-" + uniqueKey.toString() + ">" + removePreviewFileEle + "<div class='col-xs-12 col-sm-6'><canvas height=212 width=149 id="+canvas_id+" class='preview "+ preview_class +"'/></div></li>");
        if (preview_class == "image_canvas"){
          add_image_on_canvas(files[i], canvas_id);
        }
        else if (preview_class == "pdf_canvas"){
          add_canvas(files, i, uniqueKey);
        }
        uniqueKey += 1;
      }
    }
  }
  if (id == "#upload_photos"){
    $(id).val("");
  }
};

function add_canvas(files,i,uniqueKey){
  var fr = new FileReader();
  fr.readAsArrayBuffer(files[i]);
  fr.onload = function(e) {
    load_and_set_canvas(fr.result, uniqueKey, files[i].name)
  }
}

function load_and_set_canvas(data, uniqueKey, file_name){
  PDFJS.disableWorker = true;
  PDFJS.getDocument(data).then(function getPdf(pdf) {
    var parentEl = $("#preview_files");
    pdf.getPage(1).then(function getPage(page) {
      var scale = 0.25;
      var viewport = page.getViewport(scale);
      // Prepare canvas using PDF page dimensions
      var canvases = $("#preview_file_" + uniqueKey.toString());
      var canvas = canvases[0];
      var context = canvas.getContext('2d');
      // Render PDF page into canvas context
      var renderContext = {
        canvasContext: context,
        viewport: viewport
      };
      page.render(renderContext);
    });
  });
}

function getPreviewClassFromName(name){
  var nameArr = name.split(".");
  var ext = nameArr[nameArr.length - 1];
  if (["jpg","jpeg","png"].indexOf(ext.toLowerCase()) >= 0){
    return "image_canvas";
  }
  else if(["pdf"].indexOf(ext.toLowerCase()) >= 0){
    return "pdf_canvas";
  }
  else{
    return "unknown_canvas"
  }
}

function add_image_on_canvas(src, canvas_id){
  var img = new Image;
  if (typeof(src) == "string"){
    img.src = src;
  }
  else{
    img.src = URL.createObjectURL(src);
  }
  img.onload = function(){
    var ctx = document.getElementById(canvas_id).getContext('2d');
    ctx.drawImage(img,0,0,img.width,img.height,0,0,149,212);
  }
}

function initiatePreviewFiles(event, id, parentEl, formID, uploadFileEleId){
  if ($(formID).find("#"+uploadFileEleId).val() != ""){
    var tgt = event.target || window.event.srcElement;
    var files = tgt.files;
    var u_key = '';
    if (FileReader && files && files.length) {
      for(var i=0; i < files.length; i++) {
        u_key = window['uniqueFileKey'][formID][uploadFileEleId];
        window['finalFiles'][formID][uploadFileEleId][u_key]=files[i];
        
        var removePreviewFileEle = ""

        removePreviewFileEle = "<a class='remove-file dib' href='javascript:void(0);'><div class='remove-preview-file remove' id='remove-file-" + uploadFileEleId + "-" + u_key.toString() + "'><i class='fa fa-times'></i></div></a>";
        var view_name = files[i].name;
        $(parentEl).append("<li class='form-group' id=file" + uploadFileEleId + "-" + u_key.toString() + "><a href='javascript:void(0);'>" + view_name + "</a> " + removePreviewFileEle + "</li>");
        window['uniqueFileKey'][formID][uploadFileEleId] += 1;
      }
    }
    $("#" + formID).find("#"+uploadFileEleId).val("");
  }
}