$(document).ready(function(){
  $("#signin-modal").modal("show");

  $('#find-account').on('click', function(){
    $("#signin-modal").modal("hide");
    $('#find-account-modal').modal("show");
  });

  $('#create-account').on('click', function(){
    $("#signin-modal").modal("hide");
    $('#signup-modal').modal('show');
  });

  // revert to previous status
  $('#find-account-cancel').on('click', function(){
    $('#find-account-modal').modal("hide");
    $("#signin-modal").modal("show");
  });
  $('#signup-cancel').on('click', function(){
    $('#signup-modal').modal('hide');
    $("#signin-modal").modal("show");
  });

  // submit form
  $('#signup-submit').on('click', function(){
    $('#signup-form').submit();
  });
  $('#signin-submit').on('click', function(){
    $('#signin-form').submit();
  });
  $("#find-account-submit").on("click", function(){
    $("#find-account-form").submit();
  });
});
