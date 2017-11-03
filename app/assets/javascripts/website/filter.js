$(document).ready(function(){
  var t;

  // common filter event
  $('#filterFormId').on( 'change', 'select', function(){
    $('#loader-image').show();
    $('#filterFormId').submit();
  });

  $(document).on('keyup', '#search',  function() {
    clearTimeout(t);    
    t = setTimeout(function () {
      $('#filterFormId').submit();
      $("#loader-image").show();
    }, 500);
  });  
});
