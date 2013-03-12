$(function () {

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

  $.register_command('ls', function(){
    if(directory_stack.length == 0) {
      return ["agenda", "projects"].join("<br>");
    } else if(directory_stack[0] == "agenda") {
      if(directory_stack.length == 1) {
        return Object.keys(agenda_content).join("<br>");
      } else {
        return Object.keys(agenda_content[directory_stack[1]]).join("<br>");
      }
    } else if(directory_stack[0] == "projects") {
      titles = $.map(projects, function(project, i){
        return project.title;
      });
    }
  });

  $.register_command('cd', function(args){
    if(directory_stack.length === 0 && (args[1] === "agenda" || args[1] === "projects")) {
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
    } else {
      return "No such file or directory."
    }
  });

  $.register_command('exit', function(){
    toggle_terminal();
  });

  $.register_command( 'help', function() {
    return "<span class='welcome-message'>SUSEterm</span>" + '<br>' +
      "<span class='welcome-message'>ls - List All Projects</span><br>" +
      "<span class='welcome-message'>eval - Usage eval &lt;any javascript exression&gt;</span><br>" +
      "<span class='welcome-message'>date - Returns Current Date</span><br>" +
      "<span class='welcome-message'>cap - Usage cap &lt;string&gt; - Turns the string to upcase</span><br>" +
      "<span class='welcome-message'>go - Usage go &lt;url&gt; - Sets the browser location to URL</span><br>"
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