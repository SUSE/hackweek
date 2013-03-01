$(function () {
  var projects = [
    {
      title: "<span class='welcome-message'>Make a nifty hackweek website<span>"
    },
    {
      title: "<span class='welcome-message'>Do something great<span>"
    }
  ];

  $.register_command('ls', function(){
    titles = $.map(projects, function(project, i){
      return project.title;
    });
    return titles.join('<br>');
  });
});