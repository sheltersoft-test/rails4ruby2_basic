$(document).ready(function(){

  common_events();

  $(document).on("change", ".UploadedMedia", function(){
    var id = getId(this.id);
    var reader = new FileReader();
    var ele = $(this).parent().parent().find('.preview_attachments').find('li');
    ele.html("<a href='#'>"+this.files.item(0).name+"</a>");
  });
  
  // scroll listing
  $('.scroll').jscroll({
    loadingHtml: '<img src="/loading.gif" alt="Loading" />',
    autoTrigger: true,
    padding: 20,
    nextSelector: 'a.jscroll-next:last',
    callback: common_events
  });

  $("#DBMEmailModal, #LoginInfoEmailModal").on('shown.bs.modal', function() {
    $('.ckeditorCustom').ckeditor({
    });
  });

  // open DBM email modal
  $(document).on('input propertychange paste click', '#user_email',  function() {
    userEmail = $(this).val();
    if (validateEmail(userEmail)) {
      $("#dbmEmailbtn").attr('disabled', false);
    }else{
      $("#dbmEmailbtn").attr('disabled', true);
    }
  })
  if ($("#user_email").val() != ""){
    $("#dbmEmailbtn").attr('disabled', false);
  }
  $(document).on('click', '#dbmEmailbtn',  function() {
    userVal = $('#user_email').val();
    msgText = $("#old_message").val();
    msgText = msgText.replace("userEmail", userVal);
    msgText = msgText.replace(/^\s+|\s+$/gm,'');
    $("#message").html(msgText);
  })

  // order email recipient box add remove
  $(function(){
    var dbmrecipient = $('#input_dbm_recipient');
    var count = $('#input_dbm_recipient p').size();
    $(document).on("click", "#add_recipient_for_dbm_email",  function() {
      $('<p><input type="email" id="recipient_email" name="recipient_email['+ count +']" class="form-control"/><a href="#" id="removedbminput">Remove</a></p>').appendTo(dbmrecipient);
      count++;
      return false;
    });
    $(document).on("click","#removedbminput", function() {
      if( count > 1 )
        {
          $(this).parents('p').remove();
          count--;
        }
      return false;
    });
  });

  // user contract until show/hide
  if ((".contract_until").length > 0) {
    $('.contract_type_time_limited, .contract_probation_true').click(function(){
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $('#contract_until_' + id).show('slow');
    });

    $('.contract_probation_false').click(function(){
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      if(!$('#contract_type_time_limited_' + id).is(":checked")) {
        $('#contract_until_' + id).hide('slow');
      }
    });

    $('.contract_type_indefinitely_valid').click(function(){
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      if(!$('#contract_probation_true_' + id).is(":checked")) {
        $('#contract_until_' + id).hide('slow');
      }
    });

    var time_limited_contract_types = $(".contract_type_time_limited");
    for(var i=0; i<time_limited_contract_types.length; i++){
      var idArr = time_limited_contract_types[i].id.split("_");
      var id = idArr[idArr.length - 1];
      if ($("#contract_type_time_limited_" + id).is(":checked")){
        $('#contract_until_' + id).show('slow');
      }
      else{
        if ($("#contract_probation_true_" + id).is(":checked")){
          $('#contract_until_' + id).show('slow');
        }
        else {
          $('#contract_until_' + id).hide('slow');
        }
      }
    }
  }

  //add aditional languages
  if ($("#add_new_language").length > 0){
    var total_added_languages = 0;
    $(document).on("click", "#add_new_language",  function() {
      var count = ++total_added_languages;
      $('#input_add_language').append('<div class="added_language" id="added_language_wrapper_' + count + '"><div class="col-xs-12 col-sm-8 col-md-10 form-group"><input type="text" id="input_add_language_'+count+'" name="languages['+ count +']" class="form-control"/></div><div class="col-xs-12 col-sm-3 col-md-2 form-group text-right pt10"><label class="remove_language"  id="remove_language_' + count + '"><a href="javascript:void(0)" class="addLink remove_fields dynamic"><i class="removeIcon"></i>Remove</a></label></div></div>')
    });
    $(document).on("click",".remove_language", function() {
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $("#added_language_wrapper_"+ id).remove();
    });
  }

  //add aditional job role
  if ($("#add_new_job_role").length > 0){
    $(document).on("click", "#add_new_job_role",  function() {
      $('#input_add_job_role').append('<div class="added_job_role" id="added_job_role_wrapper"><div class="col-xs-12 col-sm-8 col-md-10 form-group"><input type="text" id="input_add_job_role" name="other_job_role" class="form-control"/></div><div class="col-xs-12 col-sm-3 col-md-2 form-group text-right pt10"><label class="remove_job_role"  id="remove_job_role"><a href="javascript:void(0)" class="addLink remove_fields dynamic"><i class="removeIcon"></i>Remove</a></label></div></div>')
    });
    $(document).on("click",".remove_job_role", function() {
      $("#added_job_role_wrapper").remove();
    });
  }
});

function validateEmail(email) {
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}

function fadeOutFlashMessage(id){
  $("#" + id).delay(3000).fadeOut(500);
}

function getId(id){
  var idArr = id.split("_");
  return idArr[idArr.length - 1];
}

function setFlashMessage(parentId, flashId, msg, fadeOut, animate){
  $("#" + parentId).html(getFlashMessageEle(msg, flashId));
  if (animate != false){
    SetFocusOnTopOfPage()
    //$('html, body').animate({scrollTop:$('#' + parentId).position().top}, 'slow');
  }
  if (fadeOut != false) {
    fadeOutFlashMessage(flashId);
  }
}

function getFlashMessageEle(msg, flashId){
  return "<div id='" + flashId + "' class='alert alert-dismissible alert-success'><button class='close' data-dismiss='alert' type='button'>×</button>" + msg + "</div>"
}

function common_events(){

  $('.fileUploadMedia').on( 'change', function(){
    if (this.files && this.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('.preview_file_box').html('<img src='+e.target.result+'>');
      }
      reader.readAsDataURL(this.files[0]);
    }
  });

  // virtual keyboard
  $('.container').on('cocoon:after-insert', function(e, insertedItem) {
    if ($("#pc_browser").val() != 'true') {
      $('.virtualKeyboard').attr('readonly', true);
    }    
    $('.virtualKeyboard').keyboard({
      layout: 'custom',
      restrictInput : true, // Prevent keys not in the displayed keyboard from being typed in
      preventPaste : true,  // prevent ctrl-v and right click
      autoAccept : true, 
      keyBinding: 'mousedown touchstart',   
      position: {
        of: null, // null = attach to input/textarea; use $(sel) to attach elsewhere
        my: 'center top',
        at: 'center top',
        at2: 'center bottom', // used when "usePreview" is false
        collision: 'flipfit flipfit'
      },
      usePreview: true,
      initialFocus: true,
      reposition: true,
    });
  });

  if ($("#pc_browser").val() != 'true') {
    $('.virtualKeyboard').attr('readonly', true);
  }

  $('.virtualKeyboard').keyboard({
    layout: 'custom',
    restrictInput : true, // Prevent keys not in the displayed keyboard from being typed in
    preventPaste : true,  // prevent ctrl-v and right click
    autoAccept : true,
    keyBinding: 'mousedown touchstart',
    position: {
      of: null, // null = attach to input/textarea; use $(sel) to attach elsewhere
      my: 'center top',
      at: 'center top',
      at2: 'center bottom', // used when "usePreview" is false
      collision: 'flipfit flipfit'
    },
    usePreview: true,
    initialFocus: true,
    reposition: true,
  });

  if ($("#pc_browser").val() != 'true') {
    $('.virtualKeyboard, .virtualKeyboardRoom').attr('readonly', true);
  } 

  if ($("#pc_browser").val() == "true"){
    var userPreview = true
  }
  else{
    var userPreview = false
  }

  $("#flash_msg").delay(4000).fadeOut(500);

  $(".filter-btn-cls, #filter-btn, #saveMedia, #saveMediaNext").click(function(){
    $("#loader-image").show();
  });
  
  $(".pre-icon-load").click(function(){
    $(".pre-icon").show();
  });

  $(".pre-load-form").submit(function(){    
    $(".pre-icon").show();
  });

  $('.navbar-toggle').click(function(){
    $(this).toggleClass('active');
    $('.navbar-collapse').toggleClass('active');
    $('.menuOverlay').toggleClass('active');
  });

  $('.menuOverlay').click(function(){
    $('.navbar-toggle').click();
    // $(this).removeClass('active');
    // $('.navbar-collapse').toggleClass('active');
    // $('.navbar-toggle').toggleClass('active');
  });
}
