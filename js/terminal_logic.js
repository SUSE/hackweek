$(function () {
  var projects = [
    {
      title: "Make a nifty hackweek website"
    },
    {
      title: "Do something great"
    }
  ];

  $.register_command('ls', function(){
    titles = $.map(projects, function(project, i){
      return project.title;
    });
    return titles.join('<br>');
  });
});