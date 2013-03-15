$(function () {

  var home_content = ["agenda", "projects"];

  var set_directory_prompt = function(dirs) {
    if(dirs.length === 0) {
      $.set_prompt("geeko@hackweek:~ >");
    } else {
      $.set_prompt("geeko@hackweek:~/" + dirs.join("/") + " >");
    }
  };

  var projects = [
    {
      title: "<span class='welcome-message'>Make a nifty hackweek website</span>"
    },
    {
      title: "<span class='welcome-message'>Do something great</span>"
    }
  ];

  var directory_stack = [];

  var to_directories = function(dirs) {
    return $.map(dirs, function(e){
      return "<span class='directory'>" + e + "</span>";
    }).join("<br>");
  };

  var to_files = function(files) {
    return $.map(files, function(e){
      return "<span class='file'>" + e + "</span>";
    }).join("<br>");
  };

  $.register_command('ls', function(){
    if(directory_stack.length == 0) {
      return to_directories(home_content);
    } else if(directory_stack[0] == "agenda") {
      if(directory_stack.length == 1) {
        return to_directories(Object.keys(agenda_content));
      } else {
        return to_files(Object.keys(agenda_content[directory_stack[1]]));
      }
    } else if(directory_stack[0] == "projects") {
      return to_files(Object.keys(projects_content));
    }
  });

  $.register_command('cd', function(args){
    if(directory_stack.length === 0 && $.inArray(args[1], home_content) >= 0) {
      directory_stack.push(args[1]);
    } else if(directory_stack.length === 1 &&
        directory_stack[0] === "agenda" &&
        $.inArray(args[1], Object.keys(agenda_content)) >= 0) {
      directory_stack.push(args[1]);
    } else if(args[1] === "..") {
      directory_stack.pop();
    } else {
      return "No such file or directory."
    }
    set_directory_prompt(directory_stack);
    return " ";
  });

  $.register_command('cat', function(args){
    if(directory_stack.length == 2 &&
        directory_stack[0] == "agenda" &&
        $.inArray(args[1], Object.keys(agenda_content[directory_stack[1]])) >= 0) {
      return agenda_content[directory_stack[1]][args[1]].replace(/\n/g, "<br>");
    } else if(directory_stack.length == 1 &&
        directory_stack[0] == "projects" &&
        $.inArray(args[1], Object.keys(projects_content)) >= 0) {
      return projects_content[args[1]]
    } else {
      return "No such file or directory."
    }
  });

  $.register_command('open', function(args){
    if(directory_stack.length == 1 &&
        directory_stack[0] == "projects" &&
        $.inArray(args[1], Object.keys(projects_content)) >= 0) {
      var win = window.open(projects_content[args[1]], '_blank');
      win.focus();
      return "done";
    } else {
      return "No such file or directory."
    }
  });

  $.register_command('exit', function(){
    toggle_terminal();
  });

  $.register_command( 'help', function() {
    return "<span class='welcome-message'>SUSEterm</span>" + '<br>' +
      "<span class='welcome-message'>ls - List all content.</span><br>" +
      "<span class='welcome-message'>cd - Change working directory</span><br>" +
      "<span class='welcome-message'>cat &lt;FILE&gt; - Concatenate FILE, or standard input, to standard output.</span><br>" +
      "<span class='welcome-message'>date - Returns Current Date</span><br>" +
      "<span class='welcome-message'>open &lt;filename&gt; - Open the target in a new tab</span><br>" +
      "<span class='welcome-message'>exit - Close Terminal shell.</span><br>"
  });

// COPY AND PASTED FUNCTIONS, REMOVE ON PRODUCTION
  var command_directory = {
    'eval': function( tokens ) {
      tokens.shift();
      var expression = tokens.join( ' ' );
      var result = '';
      try {
        result = eval( expression );
      } catch( e ) {
        result = 'Error: ' + e.message;
    }
    return "<span class='welcome-message'>" + result + "</span>";
  },
    'date': function( tokens ) {
      var now = new Date();
      return "<span class='welcome-message'>" + now.getDate() + '-' +
      now.getMonth() + '-' +
      ( 1900 + now.getYear() ) + "</span>"
    },
    'cap': function( tokens ) {
      tokens.shift();
      return "<span class='welcome-message'>" + tokens.join( ' ' ).toUpperCase() + "</span>";
    },
    'go': function( tokens ) {
      var url = tokens[1];
      document.location.href = url;
    }
  };

  for( var j in command_directory ) {
    $.register_command( j, command_directory[j] );
  } 

});