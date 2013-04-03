require 'test/unit'

require File.expand_path('../../lib/dokuwiki_parser.rb', __FILE__)

class DokuwikiParserTest < Test::Unit::TestCase

  def test_remove_comments
    
    text_in = <<EOT
Hello
/**/
EOT
    text_expected = <<EOT
Hello

EOT
    text_out = DokuwikiParser.remove_comments text_in    
    assert_equal text_expected, text_out

    text_in = <<EOT
1/*/2*/3
EOT
    text_expected = <<EOT
13
EOT
    text_out = DokuwikiParser.remove_comments text_in    
    assert_equal text_expected, text_out

    text_in = <<EOT
1/**/2*/3
EOT
    text_expected = <<EOT
12*/3
EOT
    text_out = DokuwikiParser.remove_comments text_in    
    assert_equal text_expected, text_out

    text_in = <<EOT
Hello
/* one line */
Huhu
/* multi line
more multi line */
In/* wah */line
Haha
/*
newline
*/
Hola
EOT
    text_expected = <<EOT
Hello

Huhu

Inline
Haha

Hola
EOT
    text_out = DokuwikiParser.remove_comments text_in 
    assert_equal text_expected, text_out
  end


  def test_parser
    
    text_in = <<EOT
====== My Project ======
=== Sub title ===
==== More SUB ====
EOT
    text_expected = <<EOT
<h4>Sub title</h4>
<h3>More SUB</h3>
EOT
    parser = DokuwikiParser.new text_in
    parser.parse
    assert_equal "My Project", parser.title
    assert_equal text_expected, parser.content

    text_in = <<EOT
====== Audio CD metadata in HAL ======

/* If this is your first time using the Idea Pool, please take a second to read the  comment at the end of this template, which explains how
 to use tags.  

Topic tags: Community, Security, Kernel, Desktop, Virtualization, Web20, Mobile, Management, Network, UnixFeature, Server, LowPower, Perform
ance, LAMP, Graphics, DevTool, Mono, IdeaPool
Product tags: openSUSE, SLES, SLED, SLERT, SLEPOS, SLETC
Status tags: Idea, InProgress, TryMe, InBuildService, Done, Shipped
Help tags: HelpWanted, HW-Hacker, HW-Tester, HW-Designer, HW-PM, HW-Docs, HW-Packaging

Separate tags with a space.
*/

===== Description =====
/* Describe your idea here. */

It would be nice

GNOME VFS could also read

==== Some potential issues ====
EOT
    text_expected = <<EOT
<h2>Description</h2>
<p>It would be nice</p>
<p>GNOME VFS could also read</p>
<h3>Some potential issues</h3>
EOT
    parser = DokuwikiParser.new text_in
    parser.parse
    assert_equal "Audio CD metadata in HAL", parser.title
    assert_equal text_expected, parser.content

    text_in = <<EOT
====== Audio CD metadata in HAL ======

{{tag>Desktop openSUSE SLED Idea}}

===== Description =====
EOT
    text_expected = <<EOT
<p><b>Tags:</b> Desktop, openSUSE, SLED, Idea</p>
<h2>Description</h2>
EOT
    parser = DokuwikiParser.new text_in
    parser.parse
    assert_equal "Audio CD metadata in HAL", parser.title
    assert_equal text_expected, parser.content

    text_in = <<EOT
Hello [[link]].

Hello [[http://example.com|external link]].
EOT
    text_expected = <<EOT
<p>Hello <a href="link.html">link</a>.</p>
<p>Hello <a href="http://example.com">external link</a>.</p>
EOT
    parser = DokuwikiParser.new text_in
    parser.parse
    assert_equal text_expected, parser.content

    text_in = <<EOT
===== Related Ideas =====

  * One
  * Two
  * Three
  * and more...
EOT
    text_expected = <<EOT
<h2>Related Ideas</h2>
<ul>
<li>One</li>
<li>Two</li>
<li>Three</li>
<li>and more...</li>
</ul>
EOT
    parser = DokuwikiParser.new text_in
    parser.parse
    assert_equal text_expected, parser.content

    text_in = <<EOT
===== Related Ideas =====

  * [[nas-web-interface-for-servers]]
  * [[useful-thinclient-image-in-less-than-70mb]]

===== People =====
EOT
    text_expected = <<EOT
<h2>Related Ideas</h2>
<ul>
<li><a href="nas-web-interface-for-servers.html">nas-web-interface-for-servers</a></li>
<li><a href="useful-thinclient-image-in-less-than-70mb.html">useful-thinclient-image-in-less-than-70mb</a></li>
</ul>
<h2>People</h2>
EOT
    parser = DokuwikiParser.new text_in
    parser.parse
    assert_equal text_expected, parser.content

  end
  
end
