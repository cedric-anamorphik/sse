<CFSETTING ENABLECFOUTPUTONLY="Yes">

<!--- Planets Sidebar and Planet Pages --->
<CFQUERY NAME="qryListAllBodies" DATASOURCE="#Application.DSN#">
SELECT PlanetID, ObjectName, SearchName, ParentID, PlanetOrder, BodyType
FROM sse3_planets_moons
WHERE Status = 'Active'
ORDER BY ParentID, PlanetOrder
</CFQUERY>

<CFMODULE TEMPLATE="../utilities/Make_Tree.cfm" QUERY="#qryListAllBodies#" UNIQUE="PlanetID" PARENT="ParentID" RESULT="qryListAllBodies">

<CFQUERY NAME="qryListAllPlanets" DBTYPE="Query">
SELECT *
FROM qryListAllBodies
WHERE BodyType = 'planet'
</CFQUERY>

<CFQUERY NAME="qryListSmallBodies" DBTYPE="Query">
SELECT *
FROM qryListAllBodies
WHERE BodyType = 'group' AND SearchName IN ('Meteors','Asteroids','Dwarf','Comets') AND ParentID = 0
</CFQUERY>

<CFQUERY NAME="qryListOtherBodies" DBTYPE="Query">
SELECT *
FROM qryListAllBodies
WHERE BodyType = 'group' AND PlanetID NOT IN (#ValueList(qryListSmallBodies.PlanetID)#) AND ParentID = 0
</CFQUERY>

<CFQUERY NAME="qryListStars" DBTYPE="Query">
SELECT *
FROM qryListAllBodies
WHERE BodyType = 'star'
</CFQUERY>

<CFQUERY NAME="qryListAllMoons" DBTYPE="Query">
SELECT *
FROM qryListAllBodies
WHERE BodyType IN ('moon','moon_prov')
</CFQUERY>

<CFQUERY NAME="qryListNamedMoons" DBTYPE="Query">
SELECT *
FROM qryListAllMoons
WHERE BodyType = 'moon'
</CFQUERY>
<CFQUERY NAME="qryListProvMoons" DBTYPE="Query">
SELECT *
FROM qryListAllMoons
WHERE BodyType = 'moon_prov'
</CFQUERY>

<CFQUERY NAME="qryListDwarfPlanets" DBTYPE="Query">
SELECT *
FROM qryListAllBodies
WHERE BodyType IN ('dwarf')
</CFQUERY>

<CFSET TotalMoonCount = (qryListNamedMoons.RecordCount + qryListProvMoons.RecordCount)>

<CFTRY>
	<CFHTTP URL="http://ssd.jpl.nasa.gov/dat/body_count.xml">
	<CFSET XMLBodyCount = XMLParse(CFHTTP.FileContent)>
	<CFLOOP FROM="1" TO="#ArrayLen(XMLBodyCount.ssdBodyCount.countData)#" INDEX="a">
		<CFSWITCH EXPRESSION="#XMLBodyCount.ssdBodyCount.countData[a].tag.XMLText#">
			<CFCASE VALUE="ast">
				<CFSET Application.AsteroidCount = NumberFormat(XMLBodyCount.ssdBodyCount.countData[a].count.XMLText,"___,___")>
				<CFMODULE TEMPLATE="../utilities/NumberToString.cfm" INPUTNUMBER="#Application.AsteroidCount#" OUTPUT="Application.AsteroidCountText">
				<CFSET "Application.AsteroidCountCap" = "#UCase(Left(Application.AsteroidCountText,1))##Right(Application.AsteroidCountText,Len(Application.AsteroidCountText)-1)#">
			</CFCASE>
			<CFCASE VALUE="com">
				<CFSET Application.CometCount = NumberFormat(XMLBodyCount.ssdBodyCount.countData[a].count.XMLText,"___,___")>
				<CFMODULE TEMPLATE="../utilities/NumberToString.cfm" INPUTNUMBER="#Application.CometCount#" OUTPUT="Application.CometCountText">
				<CFSET "Application.CometCountCap" = "#UCase(Left(Application.CometCountText,1))##Right(Application.CometCountText,Len(Application.CometCountText)-1)#">
			</CFCASE>
		</CFSWITCH>
	</CFLOOP>
	<CFCATCH TYPE="Any"></CFCATCH>
</CFTRY>

<CFSET PlanetOnDeck = "Ceres">

<!--- Missions Sidebar --->
<CFQUERY NAME="qryListCurrentMissions" DATASOURCE="#Application.DSN#">
SELECT MissionID, FullName, ShortName
FROM sse3_missions
WHERE StartDate <= #CreateODBCDateTime(Now())# 
	AND (EndDate >= #CreateODBCDateTime(Now())# OR EndDate IS NULL)
	AND Status = 'Active'
ORDER BY StartDate, EndDate
</CFQUERY>

<CFQUERY NAME="qryListCompletedMissions" DATASOURCE="#Application.DSN#">
SELECT MissionID, FullName, ShortName
FROM sse3_missions
WHERE DisplayStatus IN ('Completed','Successful','Partial Success') AND Status = 'Active'
ORDER BY StartDate, EndDate
</CFQUERY>

<CFQUERY NAME="qryListDevelMissions" DATASOURCE="#Application.DSN#">
SELECT MissionID, FullName, ShortName
FROM sse3_missions
WHERE DisplayStatus = 'In Development' AND Status = 'Active'
ORDER BY StartDate, EndDate
</CFQUERY>

<CFQUERY NAME="qryListConceptMissions" DATASOURCE="#Application.DSN#">
SELECT MissionID, FullName, ShortName
FROM sse3_missions
WHERE (DisplayStatus = 'Conceptual Mission' OR MissionConcept = 1)
	AND Status = 'Active'
ORDER BY StartDate, EndDate
</CFQUERY>

<CFQUERY NAME="qryListOnDeckMissions" DATASOURCE="#Application.DSN#">
SELECT MissionID, FullName, ShortName
FROM sse3_missions
WHERE DisplayStatus = 'On Deck' AND Status = 'Active'
ORDER BY StartDate, EndDate
</CFQUERY>

<CFSET CountdownTitle = "Comet Sliding Spring Mars Encounter">
<CFSET CountdownDate = CreateDateTime(2015,1,5,1,0,0)>

<!--- Most Popular Sidebar --->
<CFPARAM NAME="Attributes.NumMostPopular" DEFAULT="5">

<CFQUERY NAME="qryPlanetStats" DATASOURCE="#Application.DSN#"  MAXROWS="#Attributes.NumMostPopular#">
SELECT MP.*, PM.SearchName, PM.ObjectName, PM.PlanetImage, PM.MediumDesc
FROM sse3_mostpopular MP, sse3_planets_moons PM
WHERE MP.PageCategory = 'planets' AND MP.Status = 'Active'
	AND LOWER(MP.PageID) = LOWER(PM.SearchName) AND PM.Status = 'Active'
ORDER BY MP.ItemOrder
</CFQUERY>

<CFQUERY NAME="qryMissionStats" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.NumMostPopular#">
SELECT MP.*, M.MissionDirectory, M.ShortName, M.MissionImage, M.MediumDesc
FROM sse3_mostpopular MP, sse3_missions M
WHERE MP.PageCategory = 'missions' AND MP.Status = 'Active'
	AND LOWER(MP.PageID) = LOWER(M.MissionDirectory) AND M.Status = 'Active'
ORDER BY MP.ItemOrder
</CFQUERY>

<CFQUERY NAME="qryGalleryStats" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.NumMostPopular#">
SELECT MP.*, G.ImageID, G.URLPath, G.ImageTitle, G.ImageBrowse, G.MediumDesc
FROM sse3_mostpopular MP, sse3_gallery G
WHERE MP.PageCategory = 'galleries' AND MP.Status = 'Active'
	AND MP.PageID = G.ImageID AND G.Status = 'Active'
ORDER BY MP.ItemOrder
</CFQUERY>

<CFQUERY NAME="qryDownloadStats" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.NumMostPopular#">
SELECT MP.*, D.DownloadID, D.URLPath, D.DownloadTitle, D.DownloadImage, D.MediumDesc
FROM sse3_mostpopular MP, sse3_downloads D
WHERE MP.PageCategory = 'downloads' AND MP.Status = 'Active'
	AND MP.PageID = D.DownloadID AND D.Status = 'Active'
ORDER BY MP.ItemOrder
</CFQUERY>

<!--- Featured People Sidebar --->
<CFQUERY NAME="qryFeaturedPeople" DATASOURCE="#Application.DSN#">
SELECT *
FROM sse3_people
WHERE Featured > 0 AND Status = 'Active'
ORDER BY Featured, DateModified DESC, PersonID DESC
</CFQUERY>

<CFSET t = QueryAddColumn(qryFeaturedPeople,"RandomOrder",ArrayNew(1))>
<CFLOOP QUERY="qryFeaturedPeople">
	<CFSET t = QuerySetCell(qryFeaturedPeople,"RandomOrder",Hash("#qryFeaturedPeople.DirectoryName##Val(qryFeaturedPeople.RecordCount * Rand())#"),qryFeaturedPeople.CurrentRow)>
</CFLOOP>

<CFQUERY NAME="qryFeaturedPeople" DBTYPE="Query">
SELECT *
FROM qryFeaturedPeople
ORDER BY RandomOrder
</CFQUERY>

<CFCONTENT TYPE="text/json">

<CFOUTPUT>{
	<!--- Solar System Scoreboard --->
	"ssTitle":"Our Solar System",
	"ssPlanets":"#qryListAllPlanets.RecordCount#",
	"ssKnownMoons":"#TotalMoonCount#",
	"ssDwarfPlanets":"#qryListDwarfPlanets.RecordCount#",
	"ssAsteroids":"#Application.AsteroidCount#",
	"ssComets":"#Application.CometCount#",
	"ssOnDeck":"#PlanetOnDeck#",
	
	<!--- Missions Scoreboard --->
	"mTitle":"Missions",
	"mInFlight":"#qryListCurrentMissions.RecordCount#",
	"mCompleted":"#qryListCompletedMissions.RecordCount#",
	"mInDevelopment":"#qryListDevelMissions.RecordCount#",
	"mConcepts":"#qryListConceptMissions.RecordCount#",
	"mOnDeck":"#qryListOnDeckMissions.ShortName#",
	
	<!--- Countdown --->
	"cTitle":"Countdown",
	"cSubhead":"#CountdownTitle#",
	"cEventDate":"#DateFormat(CountdownDate,"mm/dd/yyyy")#:#TimeFormat(CountdownDate,"H:m:s")#",
	
	<!--- Most Popular Planets --->
	"popPlanets":[
	<CFLOOP QUERY="qryPlanetStats">
		{
			"name":"#Replace(qryPlanetStats.ObjectName,"""","\""","All")#",
			"description":"#Replace(REReplace(qryPlanetStats.MediumDesc,"[\s]+"," ","All"),"""","\""","All")#",
			<CFIF FileExists(ExpandPath("../images/planets/#qryPlanetStats.ImageFileName#"))>
				"imgUrl":"images/planets/#qryPlanetStats.ImageFileName#",
			<CFELSEIF FileExists(ExpandPath("../images/planets/#qryPlanetStats.PlanetImage#"))>
				"imgUrl":"images/planets/#qryPlanetStats.PlanetImage#",
			</CFIF>
			"pageUrl":"planets/#LCase(qryPlanetStats.SearchName)#/"
		}<CFIF qryPlanetStats.CurrentRow LT qryPlanetStats.RecordCount>,</CFIF>
	</CFLOOP>
	],
	"popMissions":[
	<CFLOOP QUERY="qryMissionStats">
		{
			"name":"#Replace(qryMissionStats.ShortName,"""","\""","All")#",
			"description":"#Replace(REReplace(qryMissionStats.MediumDesc,"[\s]+"," ","All"),"""","\""","All")#",
			<CFIF FileExists(ExpandPath("../images/missions/#qryMissionStats.ImageFileName#"))>
				"imgUrl":"images/missions/#qryMissionStats.ImageFileName#",
			<CFELSEIF FileExists(ExpandPath("../images/missions/#qryMissionStats.MissionImage#"))>
				"imgUrl":"images/missions/#qryMissionStats.MissionImage#",
			</CFIF>
			"pageUrl":"missions/#LCase(qryMissionStats.MissionDirectory)#/"
		}<CFIF qryMissionStats.CurrentRow LT qryMissionStats.RecordCount>,</CFIF>
	</CFLOOP>
	],
	"popImages":[
	<CFLOOP QUERY="qryGalleryStats">
		{
			"name":"#Replace(qryGalleryStats.ImageTitle,"""","\""","All")#",
			"description":"#Replace(REReplace(qryGalleryStats.MediumDesc,"[\s]+"," ","All"),"""","\""","All")#",
			<CFIF FileExists(ExpandPath("../images/galleries/#qryGalleryStats.ImageFileName#"))>
				"imgUrl":"images/galleries/#qryGalleryStats.ImageFileName#",
			<CFELSEIF FileExists(ExpandPath("../images/galleries/#qryGalleryStats.ImageBrowse#"))>
				"imgUrl":"images/galleries/#qryGalleryStats.ImageBrowse#",
			</CFIF>
			"pageUrl":"galleries/#LCase(qryGalleryStats.URLPath)#/"
		}<CFIF qryGalleryStats.CurrentRow LT qryGalleryStats.RecordCount>,</CFIF>
	</CFLOOP>
	],
	"popDownloads":[
	<CFLOOP QUERY="qryDownloadStats">
		{
			"name":"#Replace(qryDownloadStats.DownloadTitle,"""","\""","All")#",
			"description":"#Replace(REReplace(qryDownloadStats.MediumDesc,"[\s]+"," ","All"),"""","\""","All")#",
			<CFIF FileExists(ExpandPath("../images/downloads/#qryDownloadStats.ImageFileName#"))>
				"imgUrl":"images/downloads/#qryDownloadStats.ImageFileName#",
			<CFELSEIF FileExists(ExpandPath("../images/downloads/#qryDownloadStats.DownloadImage#"))>
				"imgUrl":"images/downloads/#qryDownloadStats.DownloadImage#",
			</CFIF>
			"pageUrl":"galleries/downloads/#LCase(qryDownloadStats.URLPath)#/"
		}<CFIF qryDownloadStats.CurrentRow LT qryDownloadStats.RecordCount>,</CFIF>
	</CFLOOP>
	],
	
	<!--- Featured People --->
	"people":[
	<CFLOOP QUERY="qryFeaturedPeople">
		{
			"name":"#Replace("#qryFeaturedPeople.FirstName# #qryFeaturedPeople.LastName#","""","\""","All")#",
			"title":"#Replace(qryFeaturedPeople.OccupationShort,"""","\""","All")#",
			"quote":"#Replace(qryFeaturedPeople.ShortDesc,"""","\""","All")#",
			"imgUrl":"images/people/#qryFeaturedPeople.ImageHP#",
			"pageUrl":"people/#qryFeaturedPeople.DirectoryName#/"
		}<CFIF qryFeaturedPeople.CurrentRow LT qryFeaturedPeople.RecordCount>,</CFIF>
	</CFLOOP>
	],
	
	<!--- Planet Pages --->
    "galPlanets":[
	<CFLOOP QUERY="qryListAllPlanets">
		{
			"name":"#qryListAllPlanets.ObjectName#",
			"imgUrl":"images/planets/galpic_#LCase(qryListAllPlanets.SearchName)#.jpg",
			"pageUrl":"planets/#LCase(qryListAllPlanets.SearchName)#/"
		}<CFIF qryListAllPlanets.CurrentRow LT qryListAllPlanets.RecordCount>,</CFIF>
	</CFLOOP>
	],
	"galSmallBodies":[
	<CFLOOP QUERY="qryListSmallBodies">
		{
			"name":"#qryListSmallBodies.ObjectName#",
			"imgUrl":"images/planets/galpic_#LCase(qryListSmallBodies.SearchName)#.jpg",
			"pageUrl":"planets/#LCase(qryListSmallBodies.SearchName)#/"
		}<CFIF qryListSmallBodies.CurrentRow LT qryListSmallBodies.RecordCount>,</CFIF>
	</CFLOOP>
	],
	"galMoons":[
	<CFLOOP QUERY="qryListNamedMoons">
		<CFIF qryListNamedMoons.SearchName IS "Moon">
		{
			"name":"#qryListNamedMoons.ObjectName#",
			"imgUrl":"images/planets/galpic_#LCase(qryListNamedMoons.SearchName)#.jpg",
			"pageUrl":"planets/#LCase(qryListNamedMoons.SearchName)#/"
		},
		<CFBREAK>
		</CFIF>
	</CFLOOP>
		{
			"name":"Other Moons",
			"imgUrl":"images/planets/galpic_othermoons.jpg",
			"pageUrl":"planets/othermoons/"
		}
	],
	"galRegions":[
	<CFLOOP QUERY="qryListOtherBodies">
		{
			"name":"#qryListOtherBodies.ObjectName#",
			"imgUrl":"images/planets/galpic_#LCase(qryListOtherBodies.SearchName)#.jpg",
			"pageUrl":"planets/#LCase(qryListOtherBodies.SearchName)#/"
		}<CFIF qryListOtherBodies.CurrentRow LT qryListOtherBodies.RecordCount>,</CFIF>
	</CFLOOP>
	],
	"galStars":[
	<CFLOOP QUERY="qryListStars">
		{
			"name":"#qryListStars.ObjectName#",
			"imgUrl":"images/planets/galpic_#LCase(qryListStars.SearchName)#.jpg",
			"pageUrl":"planets/#LCase(qryListStars.SearchName)#/"
		}<CFIF qryListStars.CurrentRow LT qryListStars.RecordCount>,</CFIF>
	</CFLOOP>
	]
}</CFOUTPUT>