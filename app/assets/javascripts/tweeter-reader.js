TWTR=window.TWTR||{};(function(){var A=0;var D;var B=["init","setDimensions","setRpp","setFeatures","setTweetInterval","setBase","setList","setProfileImage","setTitle","setCaption","setFooterText","setTheme","byClass","render","removeEvents","clear","start","stop","pause","resume","destroy"];function C(H){var E=0;var G;var F=["The Twitter API v1.0 is deprecated, and this widget has ceased functioning.","You can replace it with a new, upgraded widget from <https://twitter.com/settings/widgets/new/"+H+">","For more information on alternative Twitter tools, see <https://dev.twitter.com/docs/twitter-for-websites>"];if(!window.console){return }for(;G=F[E];E++){if(console.warn){console.warn("TWITTER WIDGET: "+G);continue}console.log(G)}}TWTR.Widget=function(E){switch(E.type){case"search":C("search?query="+escape(E.search));break;case"profile":this._profile=true;break;case"list":case"lists":C("list");break;default:return }};TWTR.Widget.ify={autoLink:function(){return{match:function(){return false}}}};TWTR.Widget.randomNumber=function(){};TWTR.Widget.prototype.isRunning=function(){return false};TWTR.Widget.prototype.setProfile=function(E){C("user?screen_name="+escape(E));return this};TWTR.Widget.prototype.setUser=function(E){if(this._profile){return this.setProfile(E)}C("favorites?screen_name="+escape(E));return this};TWTR.Widget.prototype.setSearch=function(E){C("search?query="+escape(E));return this};for(;D=B[A];A++){TWTR.Widget.prototype[D]=function(){return this}}})();

new TWTR.Widget({
  version: 2,
  type: 'search',
  search: '#britney',
  rpp: 10,
  interval: 10000,
  title: 'Latest Tweets',
  subject: 'Updated Live',
  width: 193,
  height: 96,
  theme: {
    shell: {
      background: '#000000',
      color: '#00fffc'
    },
    tweets: {
      background: '#000000',
      color: '#00fffc',
      links: '#ffc55c'
    }
  },
  features: {
    scrollbar: true,
    loop: true,
    live: true,
    hashtags: false,
    timestamp: false,
    avatars: false,
    toptweets: false,
    behavior: 'default'
  }
}).render().start();