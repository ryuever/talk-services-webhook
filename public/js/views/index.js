$(document).ready(function(){

  // add a service
  $('#service-add-btn').on("click", function(){
    $('#add-service .modal-input').val('');
    $('#add-service').modal("show");
  });

  $('#add-service-submit').on("click", function(){
    $('#add-service').modal("hide");

    $.ajax({
      url: '/webhook/add',
      type: 'POST',
      dataType: 'json',
      data: {name: $('#add-service-name').val().trim(), refer: $('#add-service-refer').val().trim()}
    })
      .done(function(data, textStatus, jqXHR){

        var name = data.name ? data.name : data.refer;


        var new_service ='<div class="opt-item"><span class="delete-service"> X </span>' +
              '<button class="service-link-btn" refer="' + data.refer + '" hashId="' + data.hashId + '">' + name + '</button></div>';

        $(new_service).insertBefore($('#service-add-btn'));

        // set up window location
        var window_domain = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port: '');
        var service = data.refer;
        var hashId = data.hashId;
        var newLoc = window_domain + '/webhook/info/' + service +'/' + hashId;
        window.history.pushState('', 'Testing webhook', newLoc);

        // set up content
        var webhook = window_domain + '/webhook/' + service + '/' + hashId;
        $('#prompt').html(webhook);
        $('#message').html('');
      })
      .fail(function(jqXHR, textStatus){
      });
  });

  // click a service
  // $('.service-link-btn').on('click', '#navi-main', function(){

  $("#message").on('click', '.msg-block', function(){
    $(this).children('p.msg-prev').toggle();
    $(this).children('pre').toggle();
  });

  $('#navi-main').on('click', '.service-link-btn', function(){
    $.ajax({
      url: "/webhook/message/" + $(this).attr('refer') + "/" + $(this).attr('hashId'),
      type: 'GET'
    })
      .done(function(data, textStatus, jqXHR){
        var window_domain = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port: '');
        var service = data.refer;
        var hashId = data.hashId;
        var content = data.content;
        var newLoc = window_domain + '/webhook/info/' + service +'/' + hashId;
        window.history.pushState('', 'New Page Title', newLoc);

        var webhook = window_domain + '/webhook/' + service + '/' + hashId;

        $('#prompt').html(webhook);
        $('#message').html('');

        content.forEach(function(item){
          var time = (new Date(item.msgTime)).toLocaleString();

          var msg_preview = '<p class="msg-prev">' + time + '</p>';

          var header = JSON.stringify(JSON.parse(item.headers), null, 2);
          var body = JSON.stringify(JSON.parse(item.body), null, 2);
          var msg_content_time = '<p class=msg-time>' + time + '</p>';
          var msg_content_header = '<span class=tag>header</span><div class=msg-header>' + header + '</div>';
          var msg_content_body = '<span class=tag>body</span><div class=msg-body>' + body + '</div>';
          var msg_content = '<pre style="display:none">' + msg_content_time + msg_content_header + msg_content_body + '</pre>';

          var msg_block = '<div class=msg-block>' + msg_preview + msg_content +'</div>';

          $('#message').append(msg_block);
        });
      })
      .fail(function(jqXHR, textStatus){
        $('.modal-alert .modal-header h3').html("Service Info");
        $('.modal-alert .modal-body p').html("Invalid service");
        $('.modal-alert').modal('show');
      });
  });

  // delete a service
  $('#navi-main').on("click",'.delete-service', function(){
    var hashId = $(this).parent().children("button").attr('hashId');
    var serviceName = $(this).parent().children("button").text();

    var modal_body = 'Are you sure to delete service : ' + serviceName + '!<span style="display: none" id="delete-hashId">' + hashId + '</span>';

    $('.modal-confirm .modal-body p').html(modal_body);
    $("#delete-service-modal").modal("show");

  });

  $('#delete-service-submit').on('click', function(){
    $.ajax({
      url: '/webhook/delete/' + $(".modal-confirm span#delete-hashId").text(),
      type: 'DELETE'
    })
      .done(function(data, textStatus, jqXHR){
        $("#delete-service-modal").modal("hide");

        $('.modal-alert .modal-header h3').html("Remove service");
        $('.modal-alert .modal-body p').html("Service " + data.name + " is already deleted !");
        $('.modal-alert').modal('show');

        var hashId = data.hashId;
        $('button[hashId="'+hashId+'"]').remove();
      })

      .fail(function(jqXHR, textStatus){
        $("#delete-service-modal").modal("hide");

        $('.modal-alert .modal-header h3').html("Remove service");
        $('.modal-alert .modal-body p').html("Service delete error !");
        $('.modal-alert').modal('show');
      });
  });
});
