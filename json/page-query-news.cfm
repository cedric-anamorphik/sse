<CFIF ListLen(Attributes.URLPath,"/") GT 1>
	<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListFindNoCase("target,mission,category",ListGetAt(Attributes.URLPath,2,"/"))>
		<!--- Filtered News Archive --->
		<CFSET PageOutput.Section = "news">
		<CFSET PageOutput.Title = "News & Events">
		<CFSET PageOutput.Path = Attributes.URLPath>
		<CFSET PageOutput.Content = "">
		
		<CFSET FilterType = ListGetAt(Attributes.URLPath,2,"/")>
		<CFSET FilterValue = ListGetAt(Attributes.URLPath,3,"/")>
		
		<CFSWITCH EXPRESSION="#FilterType#">
			<CFCASE VALUE="target">
				<CFQUERY NAME="qryNewsPlanetInfo" DATASOURCE="#Application.DSN#">
				SELECT *
				FROM sse3_planets_moons
				WHERE LOWER(SearchName) = '#LCase(FilterValue)#'
				AND Status = 'Active'
				</CFQUERY>
				<CFIF qryNewsPlanetInfo.RecordCount GT 0>
					<CFSET PageOutput.Title = "News & Events: #qryNewsPlanetInfo.ObjectName#">
				</CFIF>
			</CFCASE>
			<CFCASE VALUE="mission">
				<CFQUERY NAME="qryNewsMissionInfo" DATASOURCE="#Application.DSN#">
				SELECT *
				FROM sse3_missions
				WHERE LOWER(MissionDirectory) = '#LCase(FilterValue)#'
				AND Status = 'Active'
				</CFQUERY>
				<CFIF qryNewsMissionInfo.RecordCount GT 0>
					<CFSET PageOutput.Title = "News & Events: #Replace(qryNewsMissionInfo.FullName," 0"," ","All")#">
				</CFIF>
			</CFCASE>
			<CFCASE VALUE="category">
				<CFQUERY NAME="qryNewsCategoryInfo" DATASOURCE="#Application.DSN#">
				SELECT *
				FROM sse3_tags
				WHERE LOWER(URLPath) = '#LCase(FilterValue)#'
				AND Status = 'Active'
				</CFQUERY>
				<CFIF qryNewsCategoryInfo.RecordCount GT 0>
					<CFSET PageOutput.Title = "News & Events: #qryNewsCategoryInfo.TagName#">
				</CFIF>
			</CFCASE>
		</CFSWITCH>
		
		<CFIF Attributes.Limit IS -1 OR Attributes.Limit GT (Attributes.Start + 99)>
			<CFSET Attributes.Limit = (Attributes.Start + 99)>
		</CFIF>
		
		<CFQUERY NAME="qryListNews" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.Limit#">
		SELECT N.*
		FROM sse3_news N
			<CFSWITCH EXPRESSION="#FilterType#">
				<CFCASE VALUE="target">, sse3_newsxplanets NXP</CFCASE>
				<CFCASE VALUE="mission">, sse3_newsxmissions NXM</CFCASE>
				<CFCASE VALUE="category">, sse3_newsxtags NXT</CFCASE>
			</CFSWITCH>
		WHERE N.Status = 'Active'
			<CFSWITCH EXPRESSION="#FilterType#">
				<CFCASE VALUE="target">
					AND N.NewsID = NXP.NewsID AND <CFIF IsNumeric(qryNewsPlanetInfo.PlanetID)>NXP.PlanetID = #qryNewsPlanetInfo.PlanetID#<CFELSE>1 = 0</CFIF>
				</CFCASE>
				<CFCASE VALUE="mission">
					AND N.NewsID = NXM.NewsID AND <CFIF IsNumeric(qryNewsMissionInfo.MissionID)>NXM.MissionID = #qryNewsMissionInfo.MissionID#<CFELSE>1 = 0</CFIF>
				</CFCASE>
				<CFCASE VALUE="category">
					AND N.NewsID = NXT.NewsID AND <CFIF IsNumeric(qryNewsCategoryInfo.TagID)>NXT.TagID = #qryNewsCategoryInfo.TagID#<CFELSE>1 = 0</CFIF>
				</CFCASE>
			</CFSWITCH>
		ORDER BY N.NewsDate DESC, N.DateCreated DESC
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedPlanets" DATASOURCE="#Application.DSN#">
		SELECT PM.*, NXP.NewsID
		FROM sse3_planets_moons PM, sse3_newsxplanets NXP
		WHERE PM.PlanetID = NXP.PlanetID
			AND <CFIF qryListNews.RecordCount GT 0>NXP.NewsID IN (#ValueList(qryListNews.NewsID)#)<CFELSE>1 = 0</CFIF>
			AND PM.Status = 'Active'
		ORDER BY NXP.RelID
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedMissions" DATASOURCE="#Application.DSN#">
		SELECT M.*, NXM.NewsID
		FROM sse3_missions M, sse3_newsxmissions NXM
		WHERE M.MissionID = NXM.MissionID
			AND <CFIF qryListNews.RecordCount GT 0>NXM.NewsID IN (#ValueList(qryListNews.NewsID)#)<CFELSE>1 = 0</CFIF>
			AND M.Status = 'Active'
		ORDER BY NXM.RelID
		</CFQUERY>
		
		<CFSET PageOutput.News = ArrayNew(1)>
		<CFLOOP QUERY="qryListNews" STARTROW="#Attributes.Start#">
			<CFSET PageOutput.News[ArrayLen(PageOutput.News) + 1] = StructNew()>
			<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Title = qryListNews.NewsTitle>
			<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Content = qryListNews.MediumDesc>
			<CFSET PageOutput.News[ArrayLen(PageOutput.News)].PubDate = DateFormat(qryListNews.NewsDate,"d mmm yyyy")>
			<CFIF FileExists(ExpandPath("../images/news/#qryListNews.NewsImage#"))>
				<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Image = "images/news/#qryListNews.NewsImage#">
			<CFELSE>
				<CFQUERY NAME="qryCurrentNewsMissions" DBTYPE="Query">
				SELECT *
				FROM qryRelatedMissions
				WHERE NewsID = #qryListNews.NewsID#
				</CFQUERY>
				<CFLOOP QUERY="qryCurrentNewsMissions">
					<CFIF qryCurrentNewsMissions.MissionImage IS NOT "" AND FileExists(ExpandPath("../images/missions/#qryCurrentNewsMissions.MissionImage#"))>
						<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Image = "images/missions/#qryCurrentNewsMissions.MissionImage#">
						<CFBREAK>
					</CFIF>
				</CFLOOP>
				<CFIF StructKeyExists(PageOutput.News[ArrayLen(PageOutput.News)],"Image") IS 0>
					<CFQUERY NAME="qryCurrentNewsPlanets" DBTYPE="Query">
					SELECT *
					FROM qryRelatedPlanets
					WHERE NewsID = #qryListNews.NewsID#
					</CFQUERY>
					<CFLOOP QUERY="qryCurrentNewsPlanets">
						<CFIF qryCurrentNewsPlanets.PlanetImage IS NOT "" AND FileExists(ExpandPath("../images/planets/#qryCurrentNewsPlanets.PlanetImage#"))>
							<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Image = "images/planets/#qryCurrentNewsPlanets.PlanetImage#">
							<CFBREAK>
						</CFIF>
					</CFLOOP>
				</CFIF>
			</CFIF>
			<CFSET PageOutput.News[ArrayLen(PageOutput.News)].URL = "news/#qryListNews.URLPath#">
		</CFLOOP>
		
		<CFIF ArrayLen(PageOutput.News) IS (Attributes.Limit - (Attributes.Start - 1))>
			<CFSET PageOutput.MoreURL = "#ListFirst(Attributes.URLPath,"&")#&Start=#Val(Attributes.Limit + 1)#&Limit=#Val(Attributes.Limit + 100)#">
		</CFIF>
		
		<CFIF Request.ShowAdmin GT 0>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Article">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/news-edit.cfm">
		</CFIF>
	<CFELSE>
		<CFQUERY NAME="qryNewsInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_news
		WHERE LOWER(URLPath) = '#LCase(ListRest(Attributes.URLPath,"/"))#'
			AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedPlanets" DATASOURCE="#Application.DSN#">
		SELECT PM.*
		FROM sse3_planets_moons PM, sse3_newsxplanets NXP
		WHERE PM.PlanetID = NXP.PlanetID
			AND <CFIF IsNumeric(qryNewsInfo.NewsID)>NXP.NewsID = #qryNewsInfo.NewsID#<CFELSE>1 = 0</CFIF>
			AND PM.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedMissions" DATASOURCE="#Application.DSN#">
		SELECT M.*
		FROM sse3_missions M, sse3_newsxmissions NXM
		WHERE M.MissionID = NXM.MissionID
			AND <CFIF IsNumeric(qryNewsInfo.NewsID)>NXM.NewsID = #qryNewsInfo.NewsID#<CFELSE>1 = 0</CFIF>
			AND M.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedPlanetNews" DATASOURCE="#Application.DSN#" MAXROWS="500">
		SELECT N.NewsID
		FROM sse3_news N, sse3_newsxplanets NXP
		WHERE N.NewsID = NXP.NewsID <CFIF IsNumeric(qryNewsInfo.NewsID)>AND N.NewsID != #qryNewsInfo.NewsID#</CFIF>
			AND <CFIF qryRelatedPlanets.RecordCount GT 0>NXP.PlanetID IN (#ValueList(qryRelatedPlanets.PlanetID)#)<CFELSE>1 = 0</CFIF>
			<!--- AND N.NewsDate <= #qryNewsInfo.NewsDate# ---> AND N.Status = 'Active'
		ORDER BY N.NewsDate DESC, N.NewsID DESC
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedMissionNews" DATASOURCE="#Application.DSN#" MAXROWS="500">
		SELECT N.NewsID
		FROM sse3_news N, sse3_newsxmissions NXM
		WHERE N.NewsID = NXM.NewsID <CFIF IsNumeric(qryNewsInfo.NewsID)>AND N.NewsID != #qryNewsInfo.NewsID#</CFIF>
			AND <CFIF qryRelatedMissions.RecordCount GT 0>NXM.MissionID IN (#ValueList(qryRelatedMissions.MissionID)#)<CFELSE>1 = 0</CFIF>
			<!--- AND N.NewsDate <= #qryNewsInfo.NewsDate# ---> AND N.Status = 'Active'
		ORDER BY N.NewsDate DESC, N.NewsID DESC
		</CFQUERY>
		
		<CFSET NewsIDList = "0">
		<CFLOOP QUERY="qryRelatedPlanetNews">
			<CFIF ListFind(NewsIDList,qryRelatedPlanetNews.NewsID) IS 0>
				<CFSET NewsIDList = ListAppend(NewsIDList,qryRelatedPlanetNews.NewsID)>
			</CFIF>
		</CFLOOP>
		<CFLOOP QUERY="qryRelatedMissionNews">
			<CFIF ListFind(NewsIDList,qryRelatedMissionNews.NewsID) IS 0>
				<CFSET NewsIDList = ListAppend(NewsIDList,qryRelatedMissionNews.NewsID)>
			</CFIF>
		</CFLOOP>
		
		<CFQUERY NAME="qryRelatedNews" DATASOURCE="#Application.DSN#" MAXROWS="5">
		SELECT NewsID, NewsTitle, NewsDate, URLPath
		FROM sse3_news
		WHERE NewsID IN (#NewsIDList#)
		ORDER BY NewsDate DESC, NewsID Desc
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetTrivia" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_trivia
		WHERE <CFIF qryRelatedPlanets.RecordCount GT 0>LOWER(Category) IN (<CFLOOP QUERY="qryRelatedPlanets">'#LCase(qryRelatedPlanets.SearchName)#'<CFIF qryRelatedPlanets.CurrentRow LT qryRelatedPlanets.RecordCount>,</CFIF></CFLOOP>)<CFELSE>1 = 0</CFIF>
			AND TriviaType = 'Main Trivia' AND Status = 'Active'
		</CFQUERY>
		
		<CFSET t = QueryAddColumn(qryPlanetTrivia,"RandomOrder",ArrayNew(1))>
		<CFLOOP QUERY="qryPlanetTrivia">
			<CFSET t = QuerySetCell(qryPlanetTrivia,"RandomOrder",Hash("#qryPlanetTrivia.TriviaID##Val(qryPlanetTrivia.RecordCount * Rand())#"),qryPlanetTrivia.CurrentRow)>
		</CFLOOP>

		<CFQUERY NAME="qryPlanetTrivia" DBTYPE="Query" MAXROWS="10">
		SELECT *
		FROM qryPlanetTrivia
		ORDER BY RandomOrder
		</CFQUERY>
		
		<CFIF qryNewsInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "news">
			<CFSET PageOutput.Title = qryNewsInfo.NewsTitle>
			<CFSET PageOutput.Path = "news/#qryNewsInfo.URLPath#">
			<CFSET PageOutput.UpdateDate = DateFormat(qryNewsInfo.DateModified,"d mmmm yyyy")>
			<CFSET PageOutput.Source = qryNewsInfo.Source>
			<CFSET PageOutput.Author = qryNewsInfo.Author>
			<CFSET PageOutput.PubDate = DateFormat(qryNewsInfo.NewsDate,"d mmmm yyyy")>
			<CFIF FileExists(ExpandPath("../text/news/#Replace(qryNewsInfo.URLPath,"/","-","All")#.txt"))>
				<CFFILE ACTION="Read" FILE="#ExpandPath("../text/news/#Replace(qryNewsInfo.URLPath,"/","-","All")#.txt")#" VARIABLE="PageText">
				<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
					OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
				<CFSET PageOutput.Content = CEval(PageTextModified)>
			</CFIF>
			
			<CFSET PageOutput.Related = ArrayNew(1)>
			<CFLOOP QUERY="qryRelatedNews">
				<CFSET PageOutput.Related[ArrayLen(PageOutput.Related) + 1] = StructNew()>
				<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Title = qryRelatedNews.NewsTitle>
				<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].PubDate = DateFormat(qryRelatedNews.NewsDate,"d mmm yyyy")>
				<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].URL = "news/#qryRelatedNews.URLPath#">
			</CFLOOP>
			
			<CFSET SidebarOutput.Facts = ArrayNew(1)>
			<CFLOOP QUERY="qryPlanetTrivia">
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts) + 1] = StructNew()>
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts)].Title = qryPlanetTrivia.TriviaTitle>
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts)].Content = qryPlanetTrivia.TriviaDesc>
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts)].URL = "planets/#LCase(qryPlanetTrivia.Category)#/trivia">
			</CFLOOP>
			
			<CFSET SidebarOutput.Learn = ArrayNew(1)>
			<CFLOOP QUERY="qryRelatedPlanets">
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn) + 1] = StructNew()>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Title = qryRelatedPlanets.ObjectName>
				<CFIF FileExists(ExpandPath("../images/planets/#qryRelatedPlanets.SidebarImage#"))>
					<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Image = "images/planets/#qryRelatedPlanets.SidebarImage#">
				</CFIF>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].URL = "planets/#LCase(qryRelatedPlanets.SearchName)#">
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsTitle = qryRelatedPlanets.ObjectName>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsURL = "missions/#LCase(qryRelatedPlanets.SearchName)#">
				
				<CFSET MissionsArray = ArrayNew(1)>
				
				<CFQUERY NAME="qryPlanetCurrentMissions" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryRelatedPlanets.PlanetID#
					AND M.StartDate <= #CreateODBCDate(Now())# AND EndDate >= #CreateODBCDate(Now())#
					AND M.Status = 'Active'
				ORDER BY M.StartDate DESC, M.EndDate DESC
				</CFQUERY>
				
				<CFQUERY NAME="qryPlanetFutureMissions" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryRelatedPlanets.PlanetID#
					AND M.StartDate >= #CreateODBCDate(Now())#
					AND M.Status = 'Active'
				ORDER BY M.StartDate, M.EndDate
				</CFQUERY>
				
				<CFQUERY NAME="qryPlanetPastMissions" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryRelatedPlanets.PlanetID#
					AND M.EndDate <= #CreateODBCDate(Now())#
					AND M.Status = 'Active'
				ORDER BY M.StartDate DESC, M.EndDate DESC
				</CFQUERY>
				
				<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryPlanetCurrentMissions,qryPlanetFutureMissions,qryPlanetPastMissions" OUTPUT="qryPlanetMissions">
				
				<CFLOOP QUERY="qryPlanetMissions" ENDROW="10">
					<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsURL = "missions/target/#LCase(qryRelatedPlanets.SearchName)#">
					<CFSET MissionsArray[ArrayLen(MissionsArray) + 1] = StructNew()>
					<CFSET MissionsArray[ArrayLen(MissionsArray)].Title = Replace(qryPlanetMissions.FullName," 0","","All")>
					<CFSET MissionsArray[ArrayLen(MissionsArray)].URL = "missions/#LCase(qryPlanetMissions.MissionDirectory)#">
				</CFLOOP>
				
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Missions = MissionsArray>
				
				<CFQUERY NAME="qryPlanetImages" DATASOURCE="#Application.DSN#">
				SELECT G.*
				FROM sse3_gallery G, sse3_galleryxplanets GXP
				WHERE G.ImageID = GXP.ImageID AND GXP.PlanetID = #qryRelatedPlanets.PlanetID#
					AND G.Status = 'Active'
				ORDER BY G.ImageDate DESC, G.ImageID DESC
				</CFQUERY>
				
				<CFSET ImagesArray = ArrayNew(1)>
				
				<CFLOOP QUERY="qryPlanetImages">
					<CFIF FileExists(ExpandPath("../images/galleries/#qryPlanetImages.ImageThm#"))>
						<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].GalleryURL = "galleries/target/#LCase(qryRelatedPlanets.SearchName)#">
						<CFSET ImagesArray[ArrayLen(ImagesArray) + 1] = StructNew()>
						<CFSET ImagesArray[ArrayLen(ImagesArray)].Title = Replace(qryPlanetImages.ImageTitle," 0","","All")>
						<CFSET ImagesArray[ArrayLen(ImagesArray)].Alt = Replace(qryPlanetImages.ImageTitle," 0","","All")>
						<CFSET ImagesArray[ArrayLen(ImagesArray)].Thumbnail = "images/galleries/#qryPlanetImages.ImageThm#">
						<CFIF FileExists(ExpandPath("../images/galleries/#qryPlanetImages.ImageBrowse#"))>
							<CFSET ImagesArray[ArrayLen(ImagesArray)].Browse = "images/galleries/#qryPlanetImages.ImageBrowse#">
						</CFIF>
						<CFSET ImagesArray[ArrayLen(ImagesArray)].URL = "galleries/#qryPlanetImages.URLPath#">
						<CFSET ImagesArray[ArrayLen(ImagesArray)].ImageID = qryPlanetImages.ImageID>
					</CFIF>
					<CFIF ArrayLen(ImagesArray) IS 8>
						<CFBREAK>
					</CFIF>
				</CFLOOP>
				
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Images = ImagesArray>
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks = ArrayNew(1)>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Article">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/news-edit.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Article">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/news-delete.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFIF qryNewsInfo.Status IS "Pending">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Article">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/news-publish.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				</CFIF>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Article">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/news-edit.cfm">
			</CFIF>
		</CFIF>
	</CFIF>
<CFELSE>
	<!--- News Landing Page --->
	<CFSET PageOutput.Section = "news">
	<CFSET PageOutput.Title = "News & Events">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFIF Attributes.Limit IS -1 OR Attributes.Limit GT (Attributes.Start + 99)>
		<CFSET Attributes.Limit = (Attributes.Start + 99)>
	</CFIF>
	
	<CFQUERY NAME="qryListNews" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.Limit#">
	SELECT *
	FROM sse3_news
	WHERE Status = 'Active'
	ORDER BY Featured DESC, NewsDate DESC, DateCreated DESC
	</CFQUERY>
	
	<CFQUERY NAME="qryRelatedPlanets" DATASOURCE="#Application.DSN#">
	SELECT PM.*, NXP.NewsID
	FROM sse3_planets_moons PM, sse3_newsxplanets NXP
	WHERE PM.PlanetID = NXP.PlanetID
		AND <CFIF qryListNews.RecordCount GT 0>NXP.NewsID IN (#ValueList(qryListNews.NewsID)#)<CFELSE>1 = 0</CFIF>
		AND PM.Status = 'Active'
	ORDER BY NXP.RelID
	</CFQUERY>
	
	<CFQUERY NAME="qryRelatedMissions" DATASOURCE="#Application.DSN#">
	SELECT M.*, NXM.NewsID
	FROM sse3_missions M, sse3_newsxmissions NXM
	WHERE M.MissionID = NXM.MissionID
		AND <CFIF qryListNews.RecordCount GT 0>NXM.NewsID IN (#ValueList(qryListNews.NewsID)#)<CFELSE>1 = 0</CFIF>
		AND M.Status = 'Active'
	ORDER BY NXM.RelID
	</CFQUERY>
	
	<CFSET PageOutput.News = ArrayNew(1)>
	<CFLOOP QUERY="qryListNews" STARTROW="#Attributes.Start#">
		<CFSET PageOutput.News[ArrayLen(PageOutput.News) + 1] = StructNew()>
		<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Title = qryListNews.NewsTitle>
		<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Content = qryListNews.MediumDesc>
		<CFSET PageOutput.News[ArrayLen(PageOutput.News)].PubDate = DateFormat(qryListNews.NewsDate,"d mmm yyyy")>
		<CFIF FileExists(ExpandPath("../images/news/#qryListNews.NewsImage#"))>
			<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Image = "images/news/#qryListNews.NewsImage#">
		<CFELSE>
			<CFQUERY NAME="qryCurrentNewsMissions" DBTYPE="Query">
			SELECT *
			FROM qryRelatedMissions
			WHERE NewsID = #qryListNews.NewsID#
			</CFQUERY>
			<CFLOOP QUERY="qryCurrentNewsMissions">
				<CFIF qryCurrentNewsMissions.MissionImage IS NOT "" AND FileExists(ExpandPath("../images/missions/#qryCurrentNewsMissions.MissionImage#"))>
					<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Image = "images/missions/#qryCurrentNewsMissions.MissionImage#">
					<CFBREAK>
				</CFIF>
			</CFLOOP>
			<CFIF StructKeyExists(PageOutput.News[ArrayLen(PageOutput.News)],"Image") IS 0>
				<CFQUERY NAME="qryCurrentNewsPlanets" DBTYPE="Query">
				SELECT *
				FROM qryRelatedPlanets
				WHERE NewsID = #qryListNews.NewsID#
				</CFQUERY>
				<CFLOOP QUERY="qryCurrentNewsPlanets">
					<CFIF qryCurrentNewsPlanets.PlanetImage IS NOT "" AND FileExists(ExpandPath("../images/planets/#qryCurrentNewsPlanets.PlanetImage#"))>
						<CFSET PageOutput.News[ArrayLen(PageOutput.News)].Image = "images/planets/#qryCurrentNewsPlanets.PlanetImage#">
						<CFBREAK>
					</CFIF>
				</CFLOOP>
			</CFIF>
		</CFIF>
		<CFSET PageOutput.News[ArrayLen(PageOutput.News)].URL = "news/#qryListNews.URLPath#">
	</CFLOOP>
	
	<CFIF ArrayLen(PageOutput.News) IS (Attributes.Limit - (Attributes.Start - 1))>
		<CFSET PageOutput.MoreURL = "news/&Start=#Val(Attributes.Limit + 1)#&Limit=#Val(Attributes.Limit + 100)#">
	</CFIF>
	
	<CFIF Request.ShowAdmin GT 0>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Article">
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/news-edit.cfm">
	</CFIF>
</CFIF>