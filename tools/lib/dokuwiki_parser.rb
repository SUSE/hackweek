class DokuwikiParser

  attr_reader :title, :content

  def self.remove_comments text
    out = ""

    comment = false
    skip = 0
    
    for i in 0..text.length-1 do
      skip -= 1
      next if skip >= 0
      
      token = text[i..i+1]
      if comment
        if token == "*/"
          comment = false
          skip = 1
        end
      else
        if token == "/*"
          comment = true
          skip = 1
        else
          out += text[i].chr
        end
      end
    end

    out
  end
  
  def initialize text
    @text = DokuwikiParser.remove_comments text
    @content = ""
  end

  def on text
    o text
    o "\n"
  end
  
  def o text
    @content += text
  end
  
  def parse_title
    if @line =~ /======(.*)======/
      @title = $1.strip
      return true
    end
    return false
  end
  
  def parse_sub_title level
    marker = "=" * ( 7 - level ) 
    if @line =~ /^#{marker}(.*)#{marker}/
      end_paragraph
      o "<h#{level}>#{$1.strip}</h#{level}>\n"
      return true
    end
    return false
  end
  
  def parse_tags
    if @line =~ /\{\{tag>(.*)\}\}/
      tags = $1.split
      o "<p><b>Tags:</b> #{tags.join(", ")}</p>\n"
      return true
    end
    return false
  end
  
  def parse_wiki_links
    @line.gsub! /\[\[(.*)\|(.*)\]\]/, '<a href="\1">\2</a>'
    @line.gsub! /\[\[(.*)\]\]/, '<a href="\1.html">\1</a>'
  end
  
  def end_paragraph
    if !@p.empty?
      o @p.chomp + "</p>\n"
      @p = ""
    end
    if !@ul.empty?
      on "<ul>"
      @ul.each do |li|
        on "<li>#{li}</li>"
      end
      on "</ul>"
      @ul.clear
    end
  end

  def parse_list
    if @line =~ /^\s*\*\s*(.*)/
      @ul.push $1
      return true
    end
    return false
  end
  
  def parse
    @p = ""
    @ul = Array.new
    @text.each_line do |line|
      @line = line
      parse_wiki_links
      next if parse_title
      next if parse_sub_title 2
      next if parse_sub_title 3
      next if parse_sub_title 4
      next if parse_sub_title 5
      next if parse_tags
      next if parse_list
      if @line.strip.empty?
        end_paragraph
      else
	if @p.empty?
	  @p += "<p>" + @line
	else
	  @p += @line
	end
      end
    end
    end_paragraph
  end
  
end
