<CFSETTING ENABLECFOUTPUTONLY="Yes">

<CFINCLUDE TEMPLATE="page-query.cfm">

<CFCONTENT TYPE="text/json">

<CFOUTPUT>
{
  "section": "<CFIF IsDefined("PageOutput.Section")>#Replace(PageOutput.Section,"""","\""","All")#</CFIF>",
  "title": "<CFIF IsDefined("PageOutput.Title")>#Replace(PageOutput.Title,"""","\""","All")#</CFIF>",
  "subtitle": "<CFIF IsDefined("PageOutput.Subtitle")>#Replace(PageOutput.Subtitle,"""","\""","All")#</CFIF>",
  "path": [<CFLOOP FROM="1" TO="#ListLen(PageOutput.Path,"/")#" INDEX="p">"#ListGetAt(PageOutput.Path,p,"/")#"<CFIF p LT ListLen(PageOutput.Path,"/")>,</CFIF></CFLOOP>],
  "update_date": "<CFIF IsDefined("PageOutput.UpdateDate")>#PageOutput.UpdateDate#</CFIF>",
  "source": "<CFIF IsDefined("PageOutput.Source")>#Replace(PageOutput.Source,"""","\""","All")#</CFIF>",
  "credits": {
    "author": "<CFIF IsDefined("PageOutput.Author")>#Replace(PageOutput.Author,"""","\""","All")#</CFIF>",
    "editor": "<CFIF IsDefined("PageOutput.Editor")>#Replace(PageOutput.Editor,"""","\""","All")#</CFIF>",
    "credit": "<CFIF IsDefined("PageOutput.Credit")>#Replace(PageOutput.Credit,"""","\""","All")#</CFIF>",
	"pubdate": "<CFIF IsDefined("PageOutput.PubDate")>#PageOutput.PubDate#</CFIF>"
  },
  "admin": "<CFIF Request.ShowAdmin GT 0>1<CFELSE>0</CFIF>",
  "adminLinks": [
	<CFIF Request.ShowAdmin GT 0 AND IsDefined("PageOutput.AdminLinks")>
	<CFLOOP FROM="1" TO="#ArrayLen(PageOutput.AdminLinks)#" INDEX="a">
	{
		"title": "#Replace(PageOutput.AdminLinks[a].Title,"""","\""","All")#",
		"url": "#PageOutput.AdminLinks[a].URL#"
	}<CFIF a LT ArrayLen(PageOutput.AdminLinks)>,</CFIF>
	</CFLOOP>
	</CFIF>
  ],
  "main": {
	"featureImage": "<CFIF IsDefined("PageOutput.FeatureImage")>#PageOutput.FeatureImage#</CFIF>",
	"featureVideo": "<CFIF IsDefined("PageOutput.FeatureVideo")>#PageOutput.FeatureVideo#</CFIF>",
	"featureCaption": "<CFIF IsDefined("PageOutput.FeatureCaption")>#PageOutput.FeatureCaption#</CFIF>",
	<CFIF IsDefined("PageOutput.Slideshow")>
	  "slideshow": [
		<CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Slideshow)#" INDEX="s">
		{
		  "align": "#PageOutput.Slideshow[s].Align#"
		  <CFIF StructKeyExists(PageOutput.Slideshow[s],"Title")>,"title": "#Replace(PageOutput.Slideshow[s].Title,"""","\""","All")#"</CFIF>
		  <CFIF StructKeyExists(PageOutput.Slideshow[s],"Subtitle")>,"subtitle": "#Replace(PageOutput.Slideshow[s].Subtitle,"""","\""","All")#"</CFIF>
		  <CFIF StructKeyExists(PageOutput.Slideshow[s],"Content")>,"content": "#Replace(PageOutput.Slideshow[s].Content,"""","\""","All")#"</CFIF>
		  <CFIF StructKeyExists(PageOutput.Slideshow[s],"Image")>,"image": "#PageOutput.Slideshow[s].Image#"</CFIF>
		  <CFIF StructKeyExists(PageOutput.Slideshow[s],"VideoEmbed")>,"videoembed": "#PageOutput.Slideshow[s].Video#"</CFIF>
		  <CFIF StructKeyExists(PageOutput.Slideshow[s],"Links")>,"links": [
			<CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Slideshow[s].Links)#" INDEX="l">
			{
			  "title": "#Replace(PageOutput.Slideshow[s].Links[l].Title,"""","\""","All")#",
			  "url": "#PageOutput.Slideshow[s].Links[l].URL#"
			}<CFIF l LT ArrayLen(PageOutput.Slideshow[s].Links)>,</CFIF>
			</CFLOOP>
		  ]</CFIF>
		}<CFIF s LT ArrayLen(PageOutput.Slideshow)>,</CFIF>
		</CFLOOP>
	  ],
	</CFIF>
    "content": "<CFIF IsDefined("PageOutput.Content")>#REReplace(Replace(PageOutput.Content,"""","\""","All"),"[\s]+"," ","All")#</CFIF>",
	<CFIF IsDefined("PageOutput.MoreURL")>"moreurl": "#PageOutput.MoreURL#",</CFIF>
	<CFIF IsDefined("PageOutput.DownloadURL")>"downloadurl": "#PageOutput.DownloadURL#",</CFIF>
    "images": [
	  <CFIF IsDefined("PageOutput.Images")>
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Images)#" INDEX="i">
      {
        "markup": "#PageOutput.Images[i].Markup#"
        <CFIF StructKeyExists(PageOutput.Images[i],"Src")>,"src": "#PageOutput.Images[i].Src#"</CFIF>
        <CFIF StructKeyExists(PageOutput.Images[i],"Embed")>,"embed": "#PageOutput.Images[i].Embed#"</CFIF>
        <CFIF StructKeyExists(PageOutput.Images[i],"Width")>,"width": #PageOutput.Images[i].Width#</CFIF>
        <CFIF StructKeyExists(PageOutput.Images[i],"Height")>,"height": #PageOutput.Images[i].Height#</CFIF>
        <CFIF StructKeyExists(PageOutput.Images[i],"Alt")>,"alt": "#REReplace(Replace(PageOutput.Images[i].Alt,"""","\""","All"),"[\s]+"," ","All")#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Images[i],"Caption")>,"caption": "#REReplace(Replace(PageOutput.Images[i].Caption,"""","\""","All"),"[\s]+"," ","All")#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Images[i],"Align")>,"align": "#PageOutput.Images[i].Align#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Images[i],"Class")>,"class": "#PageOutput.Images[i].Class#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Images[i],"URL")>,"url": "#PageOutput.Images[i].URL#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Images[i],"Target")>,"target": "#PageOutput.Images[i].Target#"</CFIF>
      }<CFIF i LT ArrayLen(PageOutput.Images)>,</CFIF>
	  </CFLOOP>
	  </CFIF>
    ]
  },
  
  <!--- Planets Landing Page --->
  <CFIF IsDefined("PageOutput.Planets")>
    "planets_list": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Planets)#" INDEX="p">
	  {
		"title": "#Replace(PageOutput.Planets[p].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.Planets[p],"Image")>"image": "#PageOutput.Planets[p].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Planets[p],"URL")>"url": "#PageOutput.Planets[p].URL#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Planets[p],"Size")>"size": "#PageOutput.Planets[p].Size#",</CFIF>
		"active": #PageOutput.Planets[p].Active#
	  }<CFIF p LT ArrayLen(PageOutput.Planets)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.SmallBodies")>
    "smallbodies_list": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.SmallBodies)#" INDEX="p">
	  {
		"title": "#Replace(PageOutput.SmallBodies[p].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.SmallBodies[p],"Image")>"image": "#PageOutput.SmallBodies[p].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.SmallBodies[p],"URL")>"url": "#PageOutput.SmallBodies[p].URL#",</CFIF>
		<CFIF StructKeyExists(PageOutput.SmallBodies[p],"Size")>"size": "#PageOutput.SmallBodies[p].Size#",</CFIF>
		"active": #PageOutput.SmallBodies[p].Active#
	  }<CFIF p LT ArrayLen(PageOutput.SmallBodies)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.Moons")>
    "moons_list": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Moons)#" INDEX="p">
	  {
		"title": "#Replace(PageOutput.Moons[p].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.Moons[p],"Image")>"image": "#PageOutput.Moons[p].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Moons[p],"URL")>"url": "#PageOutput.Moons[p].URL#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Moons[p],"Size")>"size": "#PageOutput.Moons[p].Size#",</CFIF>
		"active": #PageOutput.Moons[p].Active#
	  }<CFIF p LT ArrayLen(PageOutput.Moons)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.Regions")>
    "regions_list": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Regions)#" INDEX="p">
	  {
		"title": "#Replace(PageOutput.Regions[p].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.Regions[p],"Image")>"image": "#PageOutput.Regions[p].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Regions[p],"URL")>"url": "#PageOutput.Regions[p].URL#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Regions[p],"Size")>"size": "#PageOutput.Regions[p].Size#",</CFIF>
		"active": #PageOutput.Regions[p].Active#
	  }<CFIF p LT ArrayLen(PageOutput.Regions)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.Stars")>
    "stars_list": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Stars)#" INDEX="p">
	  {
		"title": "#Replace(PageOutput.Stars[p].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.Stars[p],"Image")>"image": "#PageOutput.Stars[p].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Stars[p],"URL")>"url": "#PageOutput.Stars[p].URL#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Stars[p],"Size")>"size": "#PageOutput.Stars[p].Size#",</CFIF>
		"active": #PageOutput.Stars[p].Active#
	  }<CFIF p LT ArrayLen(PageOutput.Stars)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  
  <!--- Missions Landing Page/List View --->
  <CFIF IsDefined("PageOutput.MissionsList")>
    "missions_list": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.MissionsList)#" INDEX="m">
	  {
		"title": "#Replace(PageOutput.MissionsList[m].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.MissionsList[m],"Image")>"imgUrl": "#PageOutput.MissionsList[m].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.MissionsList[m],"URL")>"url": "#PageOutput.MissionsList[m].URL#"</CFIF>
	  }<CFIF m LT ArrayLen(PageOutput.MissionsList)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.MissionTargetsList")>
    "mission_targets": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.MissionTargetsList)#" INDEX="t">
	  {
		"title": "#Replace(PageOutput.MissionTargetsList[t].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.MissionTargetsList[t],"Image")>"imgUrl": "#PageOutput.MissionTargetsList[t].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.MissionTargetsList[t],"URL")>"url": "#PageOutput.MissionTargetsList[t].URL#"</CFIF>
	  }<CFIF t LT ArrayLen(PageOutput.MissionTargetsList)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.MissionTypesList")>
    "mission_types": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.MissionTypesList)#" INDEX="t">
	  {
		"title": "#Replace(PageOutput.MissionTypesList[t].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.MissionTypesList[t],"Image")>"imgUrl": "#PageOutput.MissionTypesList[t].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.MissionTypesList[t],"URL")>"url": "#PageOutput.MissionTypesList[t].URL#"</CFIF>
	  }<CFIF t LT ArrayLen(PageOutput.MissionTypesList)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  
  <!--- Planet/Mission Detail Page --->
  <CFIF IsDefined("PageOutput.VitalStats")>
	"vitalstats": "#PageOutput.VitalStats#",
  </CFIF>
  <CFIF IsDefined("PageOutput.Missions")>
	"missionnumber": #PageOutput.MissionNumber#,
	"missions": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Missions)#" INDEX="m">
	  {
		"title": "#Replace(PageOutput.Missions[m].Title,"""","\""","All")#"
		<CFIF StructKeyExists(PageOutput.Missions[m],"Content")>,"content": "#REReplace(Replace(PageOutput.Missions[m].Content,"""","\""","All"),"[\s]+"," ","All")#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Missions[m],"Type")>,"type": "#PageOutput.Missions[m].Type#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Missions[m],"URL")>,"url": "#PageOutput.Missions[m].URL#"</CFIF>
	  }<CFIF m LT ArrayLen(PageOutput.Missions)>,</CFIF>
	  </CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.MoonsContent")>"moonscontent": "#Replace(PageOutput.MoonsContent,"""","\""","All")#",</CFIF>
  <CFIF IsDefined("PageOutput.MoonsTitle")>"moonstitle": "#Replace(PageOutput.MoonsTitle,"""","\""","All")#",</CFIF>
  <CFIF IsDefined("PageOutput.MoonsURL")>"moonsurl": "#PageOutput.MoonsURL#",</CFIF>
  <CFIF IsDefined("PageOutput.Facts")>
    "facts": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Facts)#" INDEX="f">
	  {
		"title": "#Replace(PageOutput.Facts[f].Title,"""","\""","All")#",
		"content": "#Replace(PageOutput.Facts[f].Content,"""","\""","All")#"
	  }<CFIF f LT ArrayLen(PageOutput.Facts)>,</CFIF>
	</CFLOOP>
	]
  </CFIF>
  <CFIF IsDefined("PageOutput.Events")>
    "events": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Events)#" INDEX="e">
	  {
		"title": "#Replace(PageOutput.Events[e].Title,"""","\""","All")#",
		"date": "#Replace(PageOutput.Events[e].Date,"""","\""","All")#",
		"content": "#Replace(PageOutput.Events[e].Content,"""","\""","All")#",
		"url": "#Replace(PageOutput.Events[e].URL,"""","\""","All")#"
	  }<CFIF e LT ArrayLen(PageOutput.Events)>,</CFIF>
	</CFLOOP>
	]
  </CFIF>
  <CFIF IsDefined("PageOutput.Related")>
    "related_stories": [
      <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Related)#" INDEX="r">
      {
        "title": "#Replace(PageOutput.Related[r].Title,"""","\""","All")#",
        <CFIF StructKeyExists(PageOutput.Related[r],"PubDate")>"pubdate": "#PageOutput.Related[r].PubDate#",</CFIF>
        <CFIF StructKeyExists(PageOutput.Related[r],"Image")>"image": "#PageOutput.Related[r].Image#",</CFIF>
        "url": "#PageOutput.Related[r].URL#"
      }<CFIF r LT ArrayLen(PageOutput.Related)>,</CFIF>
	  </CFLOOP>
    ],
	<CFIF IsDefined("PageOutput.RelatedURL")>"related_url": "#PageOutput.RelatedURL#",</CFIF>
  </CFIF>
  <CFIF IsDefined("PageOutput.Timeline")>
	"timeline": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Timeline)#" INDEX="t">
	  {
		"title": "#Replace(PageOutput.Timeline[t].Title,"""","\""","All")#"
		<CFIF StructKeyExists(PageOutput.Timeline[t],"Content")>,"content": "#REReplace(Replace(PageOutput.Timeline[t].Content,"""","\""","All"),"[\s]+"," ","All")#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Timeline[t],"Date")>,"date": "#PageOutput.Timeline[t].Date#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Timeline[t],"Image")>,"image": "#PageOutput.Timeline[t].Image#"</CFIF>
		<CFIF StructKeyExists(PageOutput.Timeline[t],"URL")>,"url": "#PageOutput.Timeline[t].URL#"</CFIF>
	  }<CFIF t LT ArrayLen(PageOutput.Timeline)>,</CFIF>
	  </CFLOOP>
	],
  </CFIF>
  
  <!--- People Landing Page/Archive --->
  <CFIF IsDefined("PageOutput.People")>
	"people": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.People)#" INDEX="p">
	  {
		"name": "#Replace(PageOutput.People[p].Name,"""","\""","All")#",
		"title": "#Replace(PageOutput.People[p].Title,"""","\""","All")#",
		"content": "#Replace(PageOutput.People[p].Content,"""","\""","All")#",
		"url": "#PageOutput.People[p].URL#"
		<CFIF StructKeyExists(PageOutput.People[p],"Image")>
		  , "image": "#PageOutput.People[p].Image#"
		</CFIF>
	  }<CFIF p LT ArrayLen(PageOutput.People)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  
  <!--- News Landing Page/Archive --->
  <CFIF IsDefined("PageOutput.News")>
    "news": [
      <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.News)#" INDEX="n">
      {
        "title": "#Replace(PageOutput.News[n].Title,"""","\""","All")#",
        <CFIF StructKeyExists(PageOutput.News[n],"Content")>"content": "#REReplace(Replace(PageOutput.News[n].Content,"""","\""","All"),"[\s]+"," ","All")#",</CFIF>
        <CFIF StructKeyExists(PageOutput.News[n],"PubDate")>"pubdate": "#PageOutput.News[n].PubDate#",</CFIF>
        <CFIF StructKeyExists(PageOutput.News[n],"Image")>"image": "#PageOutput.News[n].Image#",</CFIF>
        "url": "#PageOutput.News[n].URL#"
      }<CFIF n LT ArrayLen(PageOutput.News)>,</CFIF>
	  </CFLOOP>
    ],
	<CFIF IsDefined("PageOutput.NewsURL")>"related_url": "#PageOutput.NewsURL#",</CFIF>
  </CFIF>
  
  <!--- Galleries Landing Page --->
  <CFIF IsDefined("PageOutput.CategoryGalleries")>
    "category_galleries": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.CategoryGalleries)#" INDEX="g">
	  {
		"title": "#Replace(PageOutput.CategoryGalleries[g].Title,"""","\""","All")#"
		<CFIF StructKeyExists(PageOutput.CategoryGalleries[g],"Image")>,"image": "#PageOutput.CategoryGalleries[g].Image#"</CFIF>
		<CFIF StructKeyExists(PageOutput.CategoryGalleries[g],"ImageFeed")>,"imagefeed": "#PageOutput.CategoryGalleries[g].ImageFeed#"</CFIF>
		<CFIF StructKeyExists(PageOutput.CategoryGalleries[g],"URL")>,"url": "#PageOutput.CategoryGalleries[g].URL#"</CFIF>
	  }<CFIF g LT ArrayLen(PageOutput.CategoryGalleries)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.PlanetGalleries")>
    "planet_galleries": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.PlanetGalleries)#" INDEX="g">
	  {
		"title": "#Replace(PageOutput.PlanetGalleries[g].Title,"""","\""","All")#"
		<CFIF StructKeyExists(PageOutput.PlanetGalleries[g],"Image")>,"image": "#PageOutput.PlanetGalleries[g].Image#"</CFIF>
		<CFIF StructKeyExists(PageOutput.PlanetGalleries[g],"ImageFeed")>,"imagefeed": "#PageOutput.PlanetGalleries[g].ImageFeed#"</CFIF>
		<CFIF StructKeyExists(PageOutput.PlanetGalleries[g],"URL")>,"url": "#PageOutput.PlanetGalleries[g].URL#"</CFIF>
	  }<CFIF g LT ArrayLen(PageOutput.PlanetGalleries)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.MissionGalleries")>
    "mission_galleries": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.MissionGalleries)#" INDEX="g">
	  {
		"title": "#Replace(PageOutput.MissionGalleries[g].Title,"""","\""","All")#"
		<CFIF StructKeyExists(PageOutput.MissionGalleries[g],"Image")>,"image": "#PageOutput.MissionGalleries[g].Image#"</CFIF>
		<CFIF StructKeyExists(PageOutput.MissionGalleries[g],"ImageFeed")>,"imagefeed": "#PageOutput.MissionGalleries[g].ImageFeed#"</CFIF>
		<CFIF StructKeyExists(PageOutput.MissionGalleries[g],"URL")>,"url": "#PageOutput.MissionGalleries[g].URL#"</CFIF>
	  }<CFIF g LT ArrayLen(PageOutput.MissionGalleries)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  <CFIF IsDefined("PageOutput.Gallery")>
    "gallery": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Gallery)#" INDEX="g">
	  {
		"title": "#Replace(PageOutput.Gallery[g].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.Gallery[g],"Date")>"date": "#Replace(PageOutput.Gallery[g].Date,"""","\""","All")#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Gallery[g],"Content")>"content": "#Replace(PageOutput.Gallery[g].Content,"""","\""","All")#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Gallery[g],"Image")>"image": "#PageOutput.Gallery[g].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Gallery[g],"URL")>"url": "#PageOutput.Gallery[g].URL#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Gallery[g],"ID")>"id": "#PageOutput.Gallery[g].ID#"</CFIF>
	  }<CFIF g LT ArrayLen(PageOutput.Gallery)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  
  <!--- Education --->
  <CFIF IsDefined("PageOutput.FastLessonFinder")>
	"fastlessonfinder": {
	  "action": "#PageOutput.FastLessonFinder.Action#",
	  "fields": [
		<CFLOOP FROM="1" TO="#ArrayLen(PageOutput.FastLessonFinder.Fields)#" INDEX="f">
		  {
			"fieldname": "#PageOutput.FastLessonFinder.Fields[f].Name#",
			"fieldtype": "#PageOutput.FastLessonFinder.Fields[f].Type#",
			"fieldlabel": "#Replace(PageOutput.FastLessonFinder.Fields[f].Label,"""","&quot;","All")#"
			<CFIF StructKeyExists(PageOutput.FastLessonFinder.Fields[f],"Value")>
			, "fieldvalue": "#Replace(PageOutput.FastLessonFinder.Fields[f].Value,"""","&quot;","All")#"
			</CFIF>
			<CFIF StructKeyExists(PageOutput.FastLessonFinder.Fields[f],"Options")>
			, "options": [
			  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.FastLessonFinder.Fields[f].Options)#" INDEX="o">
				{
				  "optionvalue": "#Replace(PageOutput.FastLessonFinder.Fields[f].Options[o].Value,"""","&quot;","All")#",
				  "optiontext": "#Replace(PageOutput.FastLessonFinder.Fields[f].Options[o].Text,"""","&quot;","All")#"
				  <CFIF StructKeyExists(PageOutput.FastLessonFinder.Fields[f].Options[o],"Selected")>
					, "optionselected": #PageOutput.FastLessonFinder.Fields[f].Options[o].Selected#
				  </CFIF>
				}<CFIF o LT ArrayLen(PageOutput.FastLessonFinder.Fields[f].Options)>,</CFIF>
			  </CFLOOP>
			]
			</CFIF>
		  }<CFIF f LT ArrayLen(PageOutput.FastLessonFinder.Fields)>,</CFIF>
		</CFLOOP>
	  ]
	  <CFIF IsDefined("PageOutput.FastLessonFinder.Lessons")>,
	  "lessons": [
	    <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.FastLessonFinder.Lessons)#" INDEX="l">
		  {
			"title": "#Replace(PageOutput.FastLessonFinder.Lessons[l].Title,"""","\""","All")#",
			"url": "#PageOutput.FastLessonFinder.Lessons[l].URL#",
			<!--- "topic": "#PageOutput.FastLessonFinder.Lessons[l].Topic#", --->
			"grade": "#Replace(PageOutput.FastLessonFinder.Lessons[l].Grade,"""","\""","All")#",
			"time": "#Replace(PageOutput.FastLessonFinder.Lessons[l].Time,"""","\""","All")#",
			"target": "#Replace(PageOutput.FastLessonFinder.Lessons[l].Target,"""","\""","All")#",
			"mission": "#Replace(PageOutput.FastLessonFinder.Lessons[l].Mission,"""","\""","All")#",
			"description": "#Replace(PageOutput.FastLessonFinder.Lessons[l].Description,"""","\""","All")#"
		  }<CFIF l LT ArrayLen(PageOutput.FastLessonFinder.Lessons)>,</CFIF>
		</CFLOOP>
	  ]
	  </CFIF>
	},
  </CFIF>
  
  <CFIF IsDefined("PageOutput.Links")>
    "links": [
	  <CFLOOP FROM="1" TO="#ArrayLen(PageOutput.Links)#" INDEX="l">
	  {
		"title": "#Replace(PageOutput.Links[l].Title,"""","\""","All")#",
		<CFIF StructKeyExists(PageOutput.Links[l],"Content")>"content": "#Replace(PageOutput.Links[l].Content,"""","\""","All")#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Links[l],"Image")>"image": "#PageOutput.Links[l].Image#",</CFIF>
		<CFIF StructKeyExists(PageOutput.Links[l],"URL")>"url": "#PageOutput.Links[l].URL#"</CFIF>
	  }<CFIF l LT ArrayLen(PageOutput.Links)>,</CFIF>
	</CFLOOP>
	],
  </CFIF>
  
  <!--- Sidebar --->
  "sidebar": {
	"subnav": [
	<CFIF IsDefined("SidebarOutput.Subnav")>
	  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Subnav)#" INDEX="s">
      {
		"title": "#Replace(SidebarOutput.Subnav[s].Title,"""","\""","All")#",
		"url": "#SidebarOutput.Subnav[s].URL#"
		<CFIF StructKeyExists(SidebarOutput.Subnav[s],"Target")>, "target": "#SidebarOutput.Subnav[s].Target#"</CFIF>
	  }<CFIF s LT ArrayLen(SidebarOutput.Subnav)>,</CFIF>
	  </CFLOOP>
	</CFIF>
	]
	
    <CFIF IsDefined("SidebarOutput.Facts")>,
    "facts": [
	  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Facts)#" INDEX="f">
	  {
		"title": "#Replace(SidebarOutput.Facts[f].Title,"""","\""","All")#",
		"content": "#Replace(SidebarOutput.Facts[f].Content,"""","\""","All")#",
		"url": "#SidebarOutput.Facts[f].URL#"
	  }<CFIF f LT ArrayLen(SidebarOutput.Facts)>,</CFIF>
	</CFLOOP>
	]
	</CFIF>
	
	<CFIF IsDefined("SidebarOutput.People")>,
	"people": [
	  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.People)#" INDEX="p">
	  {
		"name": "#Replace(SidebarOutput.People[p].Name,"""","\""","All")#",
		"title": "#Replace(SidebarOutput.People[p].Title,"""","\""","All")#",
		"content": "#Replace(SidebarOutput.People[p].Content,"""","\""","All")#",
		"url": "#SidebarOutput.People[p].URL#"
		<CFIF StructKeyExists(SidebarOutput.People[p],"Image")>
		  , "image": "#SidebarOutput.People[p].Image#"
		</CFIF>
	  }<CFIF p LT ArrayLen(SidebarOutput.People)>,</CFIF>
	</CFLOOP>
	]
	</CFIF>
	
	<CFIF IsDefined("SidebarOutput.Learn")>,
    "learn": [
	  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Learn)#" INDEX="l">
      {
        "title": "#Replace(SidebarOutput.Learn[l].Title,"""","\""","All")#",
        "image": "<CFIF StructKeyExists(SidebarOutput.Learn[l],"Image")>#SidebarOutput.Learn[l].Image#</CFIF>",
        "url": "#SidebarOutput.Learn[l].URL#"
		<CFIF StructKeyExists(SidebarOutput.Learn[l],"Missions")>,
		"related_missions": [
		  {
			"title": "<CFIF StructKeyExists(SidebarOutput.Learn[l],"MissionsTitle")>#Replace(SidebarOutput.Learn[l].MissionsTitle,"""","\""","All")#</CFIF>",
			"url": "<CFIF StructKeyExists(SidebarOutput.Learn[l],"MissionsURL")>#SidebarOutput.Learn[l].MissionsURL#</CFIF>",
			"missions": [
			  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Learn[l].Missions)#" INDEX="m">
			  {
				"title": "#Replace(SidebarOutput.Learn[l].Missions[m].Title,"""","\""","All")#",
				"url": "#SidebarOutput.Learn[l].Missions[m].URL#"
			  }<CFIF m LT ArrayLen(SidebarOutput.Learn[l].Missions)>,</CFIF>
			  </CFLOOP>
			]
		  }
		]
		</CFIF>
		<CFIF StructKeyExists(SidebarOutput.Learn[l],"Images")>,
		"related_images": [
		  {
			"title": "#Replace(SidebarOutput.Learn[l].Title,"""","\""","All")#",
			"url": "<CFIF StructKeyExists(SidebarOutput.Learn[l],"GalleryURL")>#SidebarOutput.Learn[l].GalleryURL#</CFIF>",
			"images": [
			  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Learn[l].Images)#" INDEX="i">
			  {
				"thumbnail": "<CFIF StructKeyExists(SidebarOutput.Learn[l].Images[i],"Thumbnail")>#SidebarOutput.Learn[l].Images[i].Thumbnail#</CFIF>",
				"browse": "<CFIF StructKeyExists(SidebarOutput.Learn[l].Images[i],"Browse")>#SidebarOutput.Learn[l].Images[i].Browse#</CFIF>",
				"alt": "<CFIF StructKeyExists(SidebarOutput.Learn[l].Images[i],"Alt")>#Replace(SidebarOutput.Learn[l].Images[i].Alt,"""","\""","All")#</CFIF>",
				"title": "<CFIF StructKeyExists(SidebarOutput.Learn[l].Images[i],"Title")>#Replace(SidebarOutput.Learn[l].Images[i].Title,"""","\""","All")#</CFIF>",
				"url": "<CFIF StructKeyExists(SidebarOutput.Learn[l].Images[i],"URL")>#SidebarOutput.Learn[l].Images[i].URL#</CFIF>",
				"imageid": #SidebarOutput.Learn[l].Images[i].ImageID#
			  }<CFIF i LT ArrayLen(SidebarOutput.Learn[l].Images)>,</CFIF>
			  </CFLOOP>
		    ]
		  }
		]
		</CFIF>
		<CFIF StructKeyExists(SidebarOutput.Learn[l],"People")>,
		"related_people": [
		  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Learn[l].People)#" INDEX="p">
		  {
			"name": "#Replace(SidebarOutput.Learn[l].People[p].Name,"""","\""","All")#",
			"title": "#Replace(SidebarOutput.Learn[l].People[p].Title,"""","\""","All")#",
			"content": "#Replace(SidebarOutput.Learn[l].People[p].Content,"""","\""","All")#",
			"url": "#SidebarOutput.Learn[l].People[p].URL#"
			<CFIF StructKeyExists(SidebarOutput.Learn[l].People[p],"Image")>
			  , "image": "#SidebarOutput.Learn[l].People[p].Image#"
			</CFIF>
		  }<CFIF p LT ArrayLen(SidebarOutput.Learn[l].People)>,</CFIF>
		  </CFLOOP>
		]
		</CFIF>
		<CFIF StructKeyExists(SidebarOutput.Learn[l],"Events")>,
		"related_events": [
		  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Learn[l].Events)#" INDEX="e">
		  {
			"title": "#Replace(SidebarOutput.Learn[l].Events[e].Title,"""","\""","All")#",
			"date": "#Replace(SidebarOutput.Learn[l].Events[e].Date,"""","\""","All")#",
			"url": "#SidebarOutput.Learn[l].Events[e].URL#"
		  }<CFIF e LT ArrayLen(SidebarOutput.Learn[l].Events)>,</CFIF>
		  </CFLOOP>
		]
		</CFIF>
	  }<CFIF l LT ArrayLen(SidebarOutput.Learn)>,</CFIF>
	  </CFLOOP>
	]
	</CFIF>
	
	<CFIF IsDefined("SidebarOutput.Events")>,
	"events": [
	  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Events)#" INDEX="e">
      {
		"title": "#Replace(SidebarOutput.Events[e].Title,"""","\""","All")#",
		"date": "#Replace(SidebarOutput.Events[e].Date,"""","\""","All")#",
		"url": "#SidebarOutput.Events[e].URL#"
	  }<CFIF e LT ArrayLen(SidebarOutput.Events)>,</CFIF>
	  </CFLOOP>
	]
	</CFIF>
	
	<CFIF IsDefined("SidebarOutput.Moons")>,
	"moons": [
	  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Moons)#" INDEX="m">
      {
		"listtitle": "<CFIF StructKeyExists(SidebarOutput.Moons[m],"Title")>#Replace(SidebarOutput.Moons[m].Title,"""","\""","All")#</CFIF>",
		"listitems": [
		  <CFLOOP FROM="1" TO="#ArrayLen(SidebarOutput.Moons[m].List)#" INDEX="l">
		  {
			"title": "#Replace(SidebarOutput.Moons[m].List[l].Title,"""","\""","All")#",
			"url": "#SidebarOutput.Moons[m].List[l].URL#"
			<CFIF StructKeyExists(SidebarOutput.Moons[m].List[l],"Target")>, "target": "#SidebarOutput.Moons[m].List[l].Target#"</CFIF>
		  }<CFIF l LT ArrayLen(SidebarOutput.Moons[m].List)>,</CFIF>
		  </CFLOOP>
		]
	  }<CFIF m LT ArrayLen(SidebarOutput.Moons)>,</CFIF>
	  </CFLOOP>
	]
	</CFIF>
	
	<CFIF IsDefined("SidebarOutput.Rings")>,
	"ringtitle": "#Replace(SidebarOutput.RingTitle,"""","\""","All")#",
	"ringcontent": "#Replace(SidebarOutput.Rings,"""","\""","All")#"
	</CFIF>
  }
}
</CFOUTPUT>
