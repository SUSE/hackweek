Mousetrap.bind('j', function() { ProjectNext(); });
Mousetrap.bind('k', function() { ProjectPrevious(); });

function ProjectPrevious() {  
        hash = window.location.hash
        all = $("td[id^='project-']").length
        if (hash == "")
          window.location.hash = "#project-1";
	else
	  var blah = hash.split('-')
          next = parseInt(blah[1])
	  if(next > 1)
	    next--
          else
            next = all - 1 
          
	  window.location.hash = "#project-" + next;
    }  

function ProjectNext() {  
        hash = window.location.hash
        all = $("td[id^='project-']").length
        if (hash == "")
          window.location.hash = "#project-1";
        else
          var blah = hash.split('-')
          next = parseInt(blah[1])
          if(next == (all - 1))
	    next = 1
	  else
            next++
          window.location.hash = "#project-" + next;
    }  
 
