App.messages = App.cable.subscriptions.create('EventsChannel', {
  received: function(data) {
    console.log(data);
    switch(data.event) {
        case 'task_created':
            this.refreshTaskList();
            break;
        case 'show_task':
            window.location = "/tasks/" + data.id;
            break;
        case 'list_tasks':
            window.location = "/tasks/";
            break;
    }
  },
  refreshTaskList: function(data) {
      if(window.location.toString().endsWith("tasks")) {
          $.getJSON('/tasks', function(data) {
              console.log(data);
              var tbody = $('#task-table tbody');
              tbody.empty();
              for(var i = 0, count = data.length; i < count; i +=1) {
                  var tr = $('<tr></tr>');
                  var td = $('<td></td>');
                  var link = $('<a></a>');
                  link.attr("href",  "/tasks/" + data[i].id); 
                  link.text(data[i].code);
                  td.append(link);
                  tr.append(td);
                  
                  td = $('<td></td>');
                  link = $('<a></a>');
                  link.attr("href",  "/tasks/" + data[i].id); 
                  link.text(data[i].name);
                  td.append(link);
                  tr.append(td);

                  tr.append($('<td class="btn-small-wrapper"><a class="waves-effect waves-light btn btn-small" href="/tasks/'
                              + data[i].id + '/edit"><i class="material-icons">create<i></i></i></a></td>'));
                  tr.append($('<td class="btn-small-wrapper"><a data-confirm="Are you sure?" class="waves-effect waves-light btn btn-small"'
                              + ' rel="nofollow" data-method="delete" href="/tasks/'
                              + data[i].id + '"><i class="material-icons">delete<i></i></i></a></td>'));
                  
                  tbody.append(tr);
              }
          });
      }
  }
});
