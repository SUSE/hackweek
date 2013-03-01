$(function () {
  var projects = [
    {
      title: "<span class='welcome-message'>Make a nifty hackweek website</span>"
    },
    {
      title: "<span class='welcome-message'>Do something great</span>"
    }
  ];

  $.register_command('ls', function(){
    titles = $.map(projects, function(project, i){
      return project.title;
    });
    return titles.join('<br>');
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