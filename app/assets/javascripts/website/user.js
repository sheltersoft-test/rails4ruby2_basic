$(document).ready(function(){

  if($(".add_introduction_text").length > 0){
    $(".add_introduction_text").click(function() {
      var idArr = this.id.split("_");
      var id = idArr[idArr.length - 1];
      $(".add_introduction_text" + id).remove();
      $("#introduction_text_area" + id).removeClass('hide');
    });
  }

  if($("#user_introduction").val() != ""){
    $(".add_introduction_text").remove();
    $("#introduction_text_area").removeClass('hide');
  }

  $(document).on("click",".job_role", function() {
    $(".other_job_role").prop("checked", false);
  });

  $(document).on("click",".other_job_role", function() {
    $(".job_role").prop("checked", false);
  });

  // user certificates show div on link click
  $(".certificate").on('click',function(){
    var id = $(this).attr('id').split("_")[1];
    $("#UserCertificate_"+id).removeClass('hide')
  });

  // check if files are present then unhide div
  if ($(".preview_attachments").length > 0){
    if ($(".preview_attachments")[0].childElementCount > 1) {
      if ($(".certificate").length > 0){
        var id = $(".certificate").attr('id').split("_")[1];
        $("#UserCertificate_"+id).removeClass('hide')  
      }
    } else {
      if ($(".certificate").length > 0){
        var id = $(".certificate").attr('id').split("_")[1];
        $("#UserCertificate_"+id).addClass('hide')
      }
    }
  } 
});