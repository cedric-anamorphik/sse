<CFIF ListLen(Attributes.URLPath,"/") GT 1>
	<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "target">
		<CFQUERY NAME="qryPlanetInfo" DATASOURCE="#Application.DSN#">
		SELECT PlanetID, SearchName, ObjectName
		FROM sse3_planets_moons
		WHERE LOWER(SearchName) = '#LCase(ListGetAt(Attributes.URLPath,3,"/"))#'
			AND Status = 'Active'
		</CFQUERY>
		
		<CFIF qryPlanetInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "people">
			<CFSET PageOutput.Title = "People: #qryPlanetInfo.ObjectName#">
			<CFSET PageOutput.Path = Attributes.URLPath>
			<CFSET PageOutput.Content = "">
			
			<CFQUERY NAME="qryListPlanetPeople" DATASOURCE="#Application.DSN#">
			SELECT P.*
			FROM sse3_people P, sse3_planetsxpeople PXP
			WHERE P.PersonID = PXP.PersonID AND PXP.PlanetID = #qryPlanetInfo.PlanetID#
				AND P.Status = 'Active'
			ORDER BY P.LastName, P.FirstName
			</CFQUERY>
			
			<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "category">
				<CFSET t = QueryAddColumn(qryListPlanetPeople,"RandomOrder",ArrayNew(1))>
				<CFLOOP QUERY="qryListPlanetPeople">
					<CFSET t = QuerySetCell(qryListPlanetPeople,"RandomOrder",Hash("#qryListPlanetPeople.DirectoryName##Val(qryListPlanetPeople.RecordCount * Rand())#"),qryListPlanetPeople.CurrentRow)>
				</CFLOOP>

				<CFQUERY NAME="qryListPlanetPeople" DBTYPE="Query">
				SELECT *
				FROM qryListPlanetPeople
				ORDER BY RandomOrder
				</CFQUERY>
			</CFIF>
			
			<CFSET PageOutput.People = ArrayNew(1)>
			
			<CFLOOP QUERY="qryListPlanetPeople">
				<CFSET PageOutput.People[ArrayLen(PageOutput.People) + 1] = StructNew()>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Name = "#qryListPlanetPeople.FirstName# #qryListPlanetPeople.LastName#">
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Title = qryListPlanetPeople.OccupationShort>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Content = qryListPlanetPeople.ShortDesc>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].URL = "people/#qryListPlanetPeople.DirectoryName#">
				<CFIF FileExists(ExpandPath("../images/people/#qryListPlanetPeople.ImageFull#"))>
					<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Image = "images/people/#qryListPlanetPeople.ImageFull#">
				</CFIF>
			</CFLOOP>
		</CFIF>
	<CFELSEIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "mission">
		<CFQUERY NAME="qryMissionInfo" DATASOURCE="#Application.DSN#">
		SELECT MissionID, MissionDirectory, FullName
		FROM sse3_missions
		WHERE LOWER(MissionDirectory) = '#LCase(ListGetAt(Attributes.URLPath,3,"/"))#'
			AND Status = 'Active'
		</CFQUERY>
		
		<CFIF qryMissionInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "people">
			<CFSET PageOutput.Title = "People: #Replace(qryMissionInfo.FullName," 0"," ","All")#">
			<CFSET PageOutput.Path = Attributes.URLPath>
			<CFSET PageOutput.Content = "">
			
			<CFQUERY NAME="qryListMissionPeople" DATASOURCE="#Application.DSN#">
			SELECT P.*
			FROM sse3_people P, sse3_missionsxpeople MXP
			WHERE P.PersonID = MXP.PersonID AND MXP.MissionID = #qryMissionInfo.MissionID#
				AND P.Status = 'Active'
			ORDER BY P.LastName, P.FirstName
			</CFQUERY>
			
			<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "category">
				<CFSET t = QueryAddColumn(qryListMissionPeople,"RandomOrder",ArrayNew(1))>
				<CFLOOP QUERY="qryListMissionPeople">
					<CFSET t = QuerySetCell(qryListMissionPeople,"RandomOrder",Hash("#qryListMissionPeople.DirectoryName##Val(qryListMissionPeople.RecordCount * Rand())#"),qryListMissionPeople.CurrentRow)>
				</CFLOOP>

				<CFQUERY NAME="qryListMissionPeople" DBTYPE="Query">
				SELECT *
				FROM qryListMissionPeople
				ORDER BY RandomOrder
				</CFQUERY>
			</CFIF>
			
			<CFSET PageOutput.People = ArrayNew(1)>
			
			<CFLOOP QUERY="qryListMissionPeople">
				<CFSET PageOutput.People[ArrayLen(PageOutput.People) + 1] = StructNew()>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Name = "#qryListMissionPeople.FirstName# #qryListMissionPeople.LastName#">
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Title = qryListMissionPeople.OccupationShort>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Content = qryListMissionPeople.ShortDesc>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].URL = "people/#qryListMissionPeople.DirectoryName#">
				<CFIF FileExists(ExpandPath("../images/people/#qryListMissionPeople.ImageFull#"))>
					<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Image = "images/people/#qryListMissionPeople.ImageFull#">
				</CFIF>
			</CFLOOP>
		</CFIF>
	<CFELSEIF ListGetAt(Attributes.URLPath,2,"/") IS "archive" OR (ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "category")>
		<CFSET PageOutput.Section = "people">
		<CFSET PageOutput.Title = "People">
		<CFSET PageOutput.Path = Attributes.URLPath>
		<CFSET PageOutput.Content = "">
		
		<!--- TO DO: Make this search tag-based --->
		<CFQUERY NAME="qryListCategoryPeople" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_people
		WHERE Status = 'Active'
			<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "category">
				<CFSWITCH EXPRESSION="#ListGetAt(Attributes.URLPath,3,"/")#">
					<CFCASE VALUE="leadership">
						<CFSET PageOutput.Title = "People: Leadership">
						AND LeadershipOrder > 0
					</CFCASE>
					<CFCASE VALUE="tribute">
						<CFSET PageOutput.Title = "People: Tributes">
						AND TributeOrder > 0
					</CFCASE>
					<CFCASE VALUE="nextgen,under35,young">
						<CFSET PageOutput.Title = "People: Next Gen">
						AND YoungScientist > 0
					</CFCASE>
					<CFCASE VALUE="women">
						<CFSET PageOutput.Title = "People: Women in Science">
						AND Sex = 'F'
					</CFCASE>
				</CFSWITCH>
			</CFIF>
		ORDER BY LastName, FirstName
		</CFQUERY>
		
		<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "category">
			<CFSET t = QueryAddColumn(qryListCategoryPeople,"RandomOrder",ArrayNew(1))>
			<CFLOOP QUERY="qryListCategoryPeople">
				<CFSET t = QuerySetCell(qryListCategoryPeople,"RandomOrder",Hash("#qryListCategoryPeople.DirectoryName##Val(qryListCategoryPeople.RecordCount * Rand())#"),qryListCategoryPeople.CurrentRow)>
			</CFLOOP>

			<CFQUERY NAME="qryListCategoryPeople" DBTYPE="Query">
			SELECT *
			FROM qryListCategoryPeople
			ORDER BY RandomOrder
			</CFQUERY>
		</CFIF>
		
		<CFSET PageOutput.People = ArrayNew(1)>
		
		<CFLOOP QUERY="qryListCategoryPeople">
			<CFSET PageOutput.People[ArrayLen(PageOutput.People) + 1] = StructNew()>
			<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Name = "#qryListCategoryPeople.FirstName# #qryListCategoryPeople.LastName#">
			<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Title = qryListCategoryPeople.OccupationShort>
			<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Content = qryListCategoryPeople.ShortDesc>
			<CFSET PageOutput.People[ArrayLen(PageOutput.People)].URL = "people/#qryListCategoryPeople.DirectoryName#">
			<CFIF FileExists(ExpandPath("../images/people/#qryListCategoryPeople.ImageFull#"))>
				<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Image = "images/people/#qryListCategoryPeople.ImageFull#">
			</CFIF>
		</CFLOOP>
		
		<CFIF Request.ShowAdmin GT 0>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Person">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/people-edit.cfm">
		</CFIF>
	<CFELSE>
		<CFQUERY NAME="qryPersonInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_people
		WHERE LOWER(DirectoryName) = '#LCase(ListRest(Attributes.URLPath,"/"))#'
			AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedPlanets" DATASOURCE="#Application.DSN#">
		SELECT PM.*
		FROM sse3_planets_moons PM, sse3_planetsxpeople PXP
		WHERE PM.PlanetID = PXP.PlanetID
			AND <CFIF IsNumeric(qryPersonInfo.PersonID)>PXP.PersonID = #qryPersonInfo.PersonID#<CFELSE>1 = 0</CFIF>
			AND PM.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedMissions" DATASOURCE="#Application.DSN#">
		SELECT M.*
		FROM sse3_missions M, sse3_missionsxpeople MXP
		WHERE M.MissionID = MXP.MissionID
			AND <CFIF IsNumeric(qryPersonInfo.PersonID)>MXP.PersonID = #qryPersonInfo.PersonID#<CFELSE>1 = 0</CFIF>
			AND M.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedPlanetPeople" DATASOURCE="#Application.DSN#">
		SELECT P.PersonID
		FROM sse3_people P, sse3_planetsxpeople PXP
		WHERE P.PersonID = PXP.PersonID <CFIF IsNumeric(qryPersonInfo.PersonID)>AND P.PersonID != #qryPersonInfo.PersonID#</CFIF>
			AND <CFIF qryRelatedPlanets.RecordCount GT 0>PXP.PlanetID IN (#ValueList(qryRelatedPlanets.PlanetID)#)<CFELSE>1 = 0</CFIF>
			AND P.Status = 'Active'
		ORDER BY P.DateModified DESC, P.PersonID DESC
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedMissionPeople" DATASOURCE="#Application.DSN#">
		SELECT P.PersonID
		FROM sse3_people P, sse3_missionsxpeople MXP
		WHERE P.PersonID = MXP.PersonID <CFIF IsNumeric(qryPersonInfo.PersonID)>AND P.PersonID != #qryPersonInfo.PersonID#</CFIF>
			AND <CFIF qryRelatedMissions.RecordCount GT 0>MXP.MissionID IN (#ValueList(qryRelatedMissions.MissionID)#)<CFELSE>1 = 0</CFIF>
			AND P.Status = 'Active'
		ORDER BY P.DateModified DESC, P.PersonID DESC
		</CFQUERY>
		
		<CFSET PersonIDList = "0">
		<CFLOOP QUERY="qryRelatedPlanetPeople">
			<CFIF ListFind(PersonIDList,qryRelatedPlanetPeople.PersonID) IS 0>
				<CFSET PersonIDList = ListAppend(PersonIDList,qryRelatedPlanetPeople.PersonID)>
			</CFIF>
		</CFLOOP>
		<CFLOOP QUERY="qryRelatedMissionPeople">
			<CFIF ListFind(PersonIDList,qryRelatedMissionPeople.PersonID) IS 0>
				<CFSET PersonIDList = ListAppend(PersonIDList,qryRelatedMissionPeople.PersonID)>
			</CFIF>
		</CFLOOP>
		
		<CFQUERY NAME="qryListPeople" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_people
		WHERE PersonID IN (#PersonIDList#)
		ORDER BY DateModified DESC, PersonID DESC
		</CFQUERY>
		
		<CFSET t = QueryAddColumn(qryListPeople,"RandomOrder",ArrayNew(1))>
		<CFLOOP QUERY="qryListPeople">
			<CFSET t = QuerySetCell(qryListPeople,"RandomOrder",Hash("#qryListPeople.DirectoryName##Val(qryListPeople.RecordCount * Rand())#"),qryListPeople.CurrentRow)>
		</CFLOOP>

		<CFQUERY NAME="qryListPeople" DBTYPE="Query">
		SELECT *
		FROM qryListPeople
		ORDER BY RandomOrder
		</CFQUERY>
		
		<!--- <CFQUERY NAME="qryPlanetTrivia" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_trivia
		WHERE <CFIF qryRelatedPlanets.RecordCount GT 0>Category IN (#QuotedValueList(qryRelatedPlanets.SearchName)#)<CFELSE>1 = 0</CFIF>
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
		</CFQUERY> --->
		
		<CFIF qryPersonInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "people">
			<CFSET PageOutput.Title = "#qryPersonInfo.FirstName# #qryPersonInfo.LastName#">
			<CFSET PageOutput.Subtitle = qryPersonInfo.ShortDesc>
			<CFSET PageOutput.Path = "people/#qryPersonInfo.DirectoryName#">
			<CFSET PageOutput.UpdateDate = DateFormat(qryPersonInfo.DateModified,"d mmmm yyyy")>
			<CFSET PageOutput.Author = PageOutput.Title>
			<CFSET PageOutput.PubDate = DateFormat(qryPersonInfo.DateCreated,"d mmmm yyyy")>
			<CFIF FileExists(ExpandPath("../images/people/#qryPersonInfo.ImageFull#"))>
				<CFSET PageOutput.FeatureImage = "images/people/#qryPersonInfo.ImageFull#">
			</CFIF>
			<CFIF qryPersonInfo.ImageSubtitle IS NOT "">
				<CFSET PageOutput.FeatureCaption = Replace(Replace(qryPersonInfo.ImageSubtitle,"""","&quot;","All"),
"<br>","All")>
			</CFIF>
			<CFIF FileExists(ExpandPath("../text/people/#Replace(qryPersonInfo.DirectoryName,"/","-","All")#-long.txt"))>
				<CFFILE ACTION="Read" FILE="#ExpandPath("../text/people/#Replace(qryPersonInfo.DirectoryName,"/","-","All")#-long.txt")#" VARIABLE="PageText">
				<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
					OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
				<CFSET PageOutput.Content = CEval(PageTextModified)>
			<CFELSE>
				<CFSET PageOutput.Content = "">
			</CFIF>
			
			<CFSET SidebarOutput.People = ArrayNew(1)>
			<CFLOOP QUERY="qryListPeople">
				<CFSET SidebarOutput.People[ArrayLen(SidebarOutput.People) + 1] = StructNew()>
				<CFSET SidebarOutput.People[ArrayLen(SidebarOutput.People)].Name = "#qryListPeople.FirstName# #qryListPeople.LastName#">
				<CFSET SidebarOutput.People[ArrayLen(SidebarOutput.People)].Title = qryListPeople.OccupationShort>
				<CFSET SidebarOutput.People[ArrayLen(SidebarOutput.People)].Content = qryListPeople.ShortDesc>
				<CFSET SidebarOutput.People[ArrayLen(SidebarOutput.People)].URL = "people/#qryListPeople.DirectoryName#">
				<CFIF FileExists(ExpandPath("../images/people/#qryListPeople.ImageHeadshot#"))>
					<CFSET SidebarOutput.People[ArrayLen(SidebarOutput.People)].Image = "images/people/#qryListPeople.ImageHeadshot#">
				</CFIF>
			</CFLOOP>
			
			<!--- <CFSET SidebarOutput.Facts = ArrayNew(1)>
			<CFLOOP QUERY="qryPlanetTrivia">
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts) + 1] = StructNew()>
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts)].Title = qryPlanetTrivia.TriviaTitle>
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts)].Content = qryPlanetTrivia.TriviaDesc>
				<CFSET SidebarOutput.Facts[ArrayLen(SidebarOutput.Facts)].URL = "planets/#LCase(qryPlanetTrivia.Category)#/trivia">
			</CFLOOP> --->
			
			<CFSET SidebarOutput.Learn = ArrayNew(1)>
			<CFLOOP QUERY="qryRelatedPlanets">
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn) + 1] = StructNew()>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Title = qryRelatedPlanets.ObjectName>
				<CFIF FileExists(ExpandPath("../images/planets/#qryRelatedPlanets.SidebarImage#"))>
					<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Image = "images/planets/#qryRelatedPlanets.SidebarImage#">
				</CFIF>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].URL = "planets/#LCase(qryRelatedPlanets.SearchName)#">
				
				<CFSET MissionsArray = ArrayNew(1)>
				
				<CFQUERY NAME="qryPlanetCurrentMissions" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryRelatedPlanets.PlanetID#
					AND M.StartDate <= #CreateODBCDate(Now())# AND M.EndDate >= #CreateODBCDate(Now())#
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
				
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsTitle = qryRelatedPlanets.ObjectName>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsURL = "missions/target/#LCase(qryRelatedPlanets.SearchName)#">
				<CFLOOP QUERY="qryPlanetMissions" ENDROW="10">
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
				
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].GalleryTitle = qryRelatedPlanets.ObjectName>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].GalleryURL = "galleries/target/#LCase(qryRelatedPlanets.SearchName)#">
				<CFLOOP QUERY="qryPlanetImages">
					<CFIF FileExists(ExpandPath("../images/galleries/#qryPlanetImages.ImageThm#"))>
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
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Profile">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/people-edit.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Profile">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/people-delete.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFIF qryPersonInfo.Status IS "Pending">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Profile">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/people-publish.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				</CFIF>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Profile">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/people-edit.cfm">
			</CFIF>
		</CFIF>
	</CFIF>
<CFELSE>
	<!--- People Landing Page (Featured People) --->
	<CFSET PageOutput.Section = "people">
	<CFSET PageOutput.Title = "People">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFQUERY NAME="qryListFeaturedPeople" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_people
	WHERE Featured > 0 AND Status = 'Active'
	ORDER BY LastName, FirstName
	</CFQUERY>
	
	<CFSET t = QueryAddColumn(qryListFeaturedPeople,"RandomOrder",ArrayNew(1))>
	<CFLOOP QUERY="qryListFeaturedPeople">
		<CFSET t = QuerySetCell(qryListFeaturedPeople,"RandomOrder",Hash("#qryListFeaturedPeople.DirectoryName##Val(qryListFeaturedPeople.RecordCount * Rand())#"),qryListFeaturedPeople.CurrentRow)>
	</CFLOOP>

	<CFQUERY NAME="qryListFeaturedPeople" DBTYPE="Query">
	SELECT *
	FROM qryListFeaturedPeople
	ORDER BY RandomOrder
	</CFQUERY>
	
	<CFSET PageOutput.People = ArrayNew(1)>
	
	<CFLOOP QUERY="qryListFeaturedPeople">
		<CFSET PageOutput.People[ArrayLen(PageOutput.People) + 1] = StructNew()>
		<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Name = "#qryListFeaturedPeople.FirstName# #qryListFeaturedPeople.LastName#">
		<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Title = qryListFeaturedPeople.OccupationShort>
		<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Content = qryListFeaturedPeople.ShortDesc>
		<CFSET PageOutput.People[ArrayLen(PageOutput.People)].URL = "people/#qryListFeaturedPeople.DirectoryName#">
		<CFIF FileExists(ExpandPath("../images/people/#qryListFeaturedPeople.ImageFull#"))>
			<CFSET PageOutput.People[ArrayLen(PageOutput.People)].Image = "images/people/#qryListFeaturedPeople.ImageFull#">
		</CFIF>
	</CFLOOP>
	
	<CFIF Request.ShowAdmin GT 0>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Person">
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/people-edit.cfm">
	</CFIF>
</CFIF>