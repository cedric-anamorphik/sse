<CFIF ListLen(Attributes.URLPath,"/") GT 1>
	<CFQUERY NAME="qryPlanetInfo" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_planets_moons
	WHERE LOWER(SearchName) = '#LCase(ListGetAt(Attributes.URLPath,2,"/"))#'
		AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
	</CFQUERY>
	
	<CFIF qryPlanetInfo.RecordCount GT 0>
		<CFQUERY NAME="qryParentPlanet" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_planets_moons
		WHERE PlanetID = #qryPlanetInfo.ParentID#
			AND Status = 'Active'
		</CFQUERY>
	
		<CFQUERY NAME="qryPlanetMoons" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_planets_moons
		WHERE ParentID = #qryPlanetInfo.PlanetID#
			AND Status = 'Active'
		ORDER BY BodyType, PlanetOrder
		</CFQUERY>
		
		<CFIF qryPlanetInfo.MoonsLongDesc IS NOT "">
			<CFSET PageOutput.MoonsContent = qryPlanetInfo.MoonsLongDesc>
		</CFIF>
		<CFIF ListFindNoCase("planet,dwarf,plutoid,watch,moon_moon_prov",qryPlanetInfo.BodyType)>
			<CFIF qryPlanetMoons.RecordCount GT 0 OR FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-moons.txt"))>
				<CFSET PageOutput.MoonsURL = "planets/#LCase(qryPlanetInfo.SearchName)#/moons">
				<CFSET PageOutput.MoonsTitle = "Moons">
			</CFIF>
		<CFELSE>
			<CFIF qryPlanetMoons.RecordCount GT 0 OR FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-moons.txt"))>
				<CFSET PageOutput.MoonsURL = "planets/#LCase(qryPlanetInfo.SearchName)#/sats">
				<CFSWITCH EXPRESSION="#qryPlanetInfo.SearchName#">
					<CFCASE VALUE="SolarSystem">
						<CFSET PageOutput.MoonsTitle = "Planets">
					</CFCASE>
					<CFDEFAULTCASE>
						<CFSET PageOutput.MoonsTitle = "Science Targets">
					</CFDEFAULTCASE>
				</CFSWITCH>
			</CFIF>
		</CFIF>
		
		<CFQUERY NAME="qryPlanetRings" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_planet_rings
		WHERE ObjectName = '#qryPlanetInfo.ObjectName#'
			AND Status = 'Active'
		ORDER BY RingOrder
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetImages" DATASOURCE="#Application.DSN#" MAXROWS="8">
		SELECT G.*
		FROM sse3_gallery G, sse3_galleryxplanets GXP
		WHERE G.ImageID = GXP.ImageID AND GXP.PlanetID = #qryPlanetInfo.PlanetID#
			AND G.Status = 'Active'
		ORDER BY G.ImageDate DESC, G.ImageID DESC
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetHomework" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_homework_categories
		WHERE LOWER(PlanetSearchName) = '#LCase(qryPlanetInfo.ObjectName)#'
			AND Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetTrivia" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_trivia
		WHERE LOWER(Category) = '#LCase(qryPlanetInfo.SearchName)#'
			AND TriviaType = 'Main Trivia' AND Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryRelatedNews" DATASOURCE="#Application.DSN#" MAXROWS="3">
		SELECT N.*
		FROM sse3_news N, sse3_newsxplanets NXP
		WHERE N.NewsID = NXP.NewsID
			AND NXP.PlanetID = #qryPlanetInfo.PlanetID#
			<!--- AND N.NewsDate <= #qryNewsInfo.NewsDate# ---> AND N.Status = 'Active'
		ORDER BY N.NewsDate DESC, N.NewsID DESC
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetPresentMissions" DATASOURCE="#Application.DSN#">
		SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate, M.MType, M.MediumDesc
		FROM sse3_missions M, sse3_missionsxplanets MXP
		WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryPlanetInfo.PlanetID#
			AND M.StartDate <= #CreateODBCDate(Now())# AND M.EndDate >= #CreateODBCDate(Now())#
			AND M.Status = 'Active'
		ORDER BY M.StartDate DESC, M.EndDate DESC
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetFutureMissions" DATASOURCE="#Application.DSN#">
		SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate, M.MType, M.MediumDesc
		FROM sse3_missions M, sse3_missionsxplanets MXP
		WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryPlanetInfo.PlanetID#
			AND M.StartDate >= #CreateODBCDate(Now())#
			AND M.Status = 'Active'
		ORDER BY M.StartDate, M.EndDate
		</CFQUERY>
		
		<CFQUERY NAME="qryPlanetPastMissions" DATASOURCE="#Application.DSN#">
		SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate, M.MType, M.MediumDesc
		FROM sse3_missions M, sse3_missionsxplanets MXP
		WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryPlanetInfo.PlanetID#
			AND M.EndDate <= #CreateODBCDate(Now())#
			AND M.Status = 'Active'
		ORDER BY M.StartDate DESC, M.EndDate DESC
		</CFQUERY>
		
		<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryPlanetPresentMissions,qryPlanetFutureMissions,qryPlanetPastMissions" OUTPUT="qryPlanetMissions">
		<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryPlanetPresentMissions,qryPlanetPastMissions" OUTPUT="qryPlanetMissionsNoFuture">
		
		<CFSET PageOutput.Section = "planets">
		<CFSET PageOutput.Title = qryPlanetInfo.ObjectName>
		<CFIF qryPlanetInfo.Slogan IS NOT "">
			<CFSET PageOutput.Subtitle = qryPlanetInfo.Slogan>
		</CFIF>
		<CFIF ListLen(Attributes.URLPath,"/") GT 2>
			<CFSET PageOutput.Path = "planets/#qryPlanetInfo.SearchName#/#ListGetAt(Attributes.URLPath,3,"/")#">
			<CFSET ContentSection = ListGetAt(Attributes.URLPath,3,"/")>
		<CFELSE>
			<CFSET PageOutput.Path = "planets/#qryPlanetInfo.SearchName#">
			<CFSET ContentSection = "">
		</CFIF>
		<CFSET PageOutput.UpdateDate = DateFormat(qryPlanetInfo.DateModified,"d mmmm yyyy")>
		<CFIF ContentSection IS "">
			<CFSET ContentSection = "Overview">
		</CFIF>
		<CFSWITCH EXPRESSION="#ContentSection#">
			<CFCASE VALUE="Overview">
				<!--- Landing Page --->
				<CFQUERY NAME="qrySlideshowInfo" DATASOURCE="#Application.DSN#">
				SELECT *
				FROM sse3_feature_rotators
				WHERE RotatorURL = '#Attributes.URLPath#' AND Status = 'Active'
				</CFQUERY>
				
				<CFIF qrySlideshowInfo.RecordCount GT 0>
					<CFQUERY NAME="qryListSlides" DATASOURCE="#Application.DSN#">
					SELECT *
					FROM sse3_features
					WHERE RotatorID = #qrySlideshowInfo.RotatorID# AND FeatureOrder GT 0 AND Status = 'Active'
					ORDER BY FeatureOrder
					</CFQUERY>
					
					<CFSET PageOutput.Slideshow = ArrayNew(1)>
					<CFLOOP QUERY="qryListSlides">
						<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow) + 1] = StructNew()>
						<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].Title = qryListSlides.FeatureTitle>
						<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].Subtitle = qryListSlides.FeatureSubtitle>
						<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].Content = qryListSlides.FeatureText>
						<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].Align = qryListSlides.FeatureAlign>
						<CFIF FileExists(ExpandPath("../images/slideshow/#qryListSlides.FeatureImage#"))>
							<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].Image = "images/slideshow/#qryListSlides.FeatureImage#">
						</CFIF>
						<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].VideoEmbed = qryListSlides.VideoEmbed>
						<CFSET LinksArray = ArrayNew(1)>
						<CFLOOP FROM="1" TO="4" INDEX="l">
							<CFIF Evaluate("qryListSlides.FeatureLink#l#URL") IS NOT "">
								<CFSET LinksArray[l] = StructNew()>
								<CFSET LinksArray[l].Title = Evaluate("qryListSlides.FeatureLink#l#Title")>
								<CFSET LinksArray[l].URL = Evaluate("qryListSlides.FeatureLink#l#URL")>
							</CFIF>
						</CFLOOP>
						<CFIF ArrayLen(LinksArray) GT 0>
							<CFSET PageOutput.Slideshow[ArrayLen(PageOutput.Slideshow)].Links = LinksArray>
						</CFIF>
					</CFLOOP>
				</CFIF>
				
				<CFSET PageOutput.Content = qryPlanetInfo.LongDesc>
				
				<CFIF FileExists(ExpandPath("../includes/planets/vitalstats-#LCase(qryPlanetInfo.SearchName)#.html"))>
					<CFSET PageOutput.VitalStats = "includes/planets/vitalstats-#LCase(qryPlanetInfo.SearchName)#.html">
				</CFIF>
				
				<CFIF qryPlanetMissionsNoFuture.RecordCount GT 0>
					<CFSET MissionsArray = ArrayNew(1)>
					<CFLOOP QUERY="qryPlanetMissionsNoFuture">
						<CFSET MissionsArray[ArrayLen(MissionsArray) + 1] = StructNew()>
						<CFSET MissionsArray[ArrayLen(MissionsArray)].Title = Replace(qryPlanetMissionsNoFuture.FullName," 0","","All")>
						<CFSET MissionsArray[ArrayLen(MissionsArray)].Content = qryPlanetMissionsNoFuture.MediumDesc>
						<CFSET MissionsArray[ArrayLen(MissionsArray)].Type = qryPlanetMissionsNoFuture.MType>
						<CFSET MissionsArray[ArrayLen(MissionsArray)].URL = "missions/#LCase(qryPlanetMissionsNoFuture.MissionDirectory)#">
					</CFLOOP>
					<CFIF ArrayLen(MissionsArray) GT 0>
						<CFSET PageOutput.Missions = MissionsArray>
						<CFSET PageOutput.MissionNumber = ArrayLen(MissionsArray)>
					</CFIF>
				</CFIF>
				
				<CFSET PageOutput.Related = ArrayNew(1)>
				<CFLOOP QUERY="qryRelatedNews">
					<CFSET PageOutput.Related[ArrayLen(PageOutput.Related) + 1] = StructNew()>
					<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Title = qryRelatedNews.NewsTitle>
					<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].PubDate = DateFormat(qryRelatedNews.NewsDate,"d mmm yyyy")>
					<CFIF FileExists(ExpandPath("../images/news/#qryRelatedNews.NewsImage#"))>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Image = "images/news/#qryRelatedNews.NewsImage#">
					<CFELSEIF FileExists(ExpandPath("../images/planets/#qryPlanetInfo.PlanetImage#"))>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Image = "images/planets/#qryPlanetInfo.PlanetImage#">
					</CFIF>
					<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].URL = "news/#qryRelatedNews.URLPath#">
				</CFLOOP>
				
				<CFSET PageOutput.RelatedURL = "news/target/#LCase(qryPlanetInfo.SearchName)#">
				
				<CFQUERY NAME="qryListTimelineEntries" DATASOURCE="#Application.DSN#">
				SELECT *
				FROM sse3_feature_timeline
				WHERE LOWER(EventCategory) = '#LCase(qryPlanetInfo.SearchName)#' AND Status = 'Active'
				ORDER BY StartYear, StartMonth, StartDay, EndYear, EndMonth, EndDay
				</CFQUERY>
				
				<CFSET PageOutput.Timeline = ArrayNew(1)>
				<CFLOOP QUERY="qryListTimelineEntries">
					<CFSET PageOutput.Timeline[ArrayLen(PageOutput.Timeline) + 1] = StructNew()>
					<CFSET PageOutput.Timeline[ArrayLen(PageOutput.Timeline)].Title = qryListTimelineEntries.EventTitle>
					<CFSET PageOutput.Timeline[ArrayLen(PageOutput.Timeline)].Content = qryListTimelineEntries.EventDesc>
					<CFSET CurrentStartDate = qryListTimelineEntries.StartYear>
					<CFIF qryListTimelineEntries.StartMonth GT 0>
						<CFSET CurrentStartDate = "#Left(MonthAsString(qryListTimelineEntries.StartMonth),3)# #CurrentStartDate#">
						<CFIF qryListTimelineEntries.StartDay GT 0>
							<CFSET CurrentStartDate = "#qryListTimelineEntries.StartDay# #CurrentStartDate#">
							<CFIF qryListTimelineEntries.StartDay GT 0>
								<CFSET CurrentStartTime = "#CurrentStartDate# #qryListTimelineEntries.StartTime#">
							</CFIF>
						</CFIF>
					</CFIF>
					<CFIF qryListTimelineEntries.EndYear GT 0>
						<CFSET CurrentEndDate = qryListTimelineEntries.EndYear>
						<CFIF qryListTimelineEntries.EndMonth GT 0>
							<CFSET CurrentEndDate = "#Left(MonthAsString(qryListTimelineEntries.EndMonth),3)# #CurrentEndDate#">
							<CFIF qryListTimelineEntries.EndDay GT 0>
								<CFSET CurrentEndDate = "#qryListTimelineEntries.EndDay# #CurrentEndDate#">
								<CFIF qryListTimelineEntries.EndDay GT 0>
									<CFSET CurrentEndTime = "#CurrentEndDate# #qryListTimelineEntries.EndTime#">
								</CFIF>
							</CFIF>
						</CFIF>
						<CFSET CurrentDate = "#CurrentStartDate# - #CurrentEndDate#">
					<CFELSE>
						<CFSET CurrentDate = CurrentStartDate>
					</CFIF>
					<CFSET PageOutput.Timeline[ArrayLen(PageOutput.Timeline)].Date = CurrentDate>
					<CFSET PageOutput.Timeline[ArrayLen(PageOutput.Timeline)].URL = qryListTimelineEntries.EventLinkURL>
					<CFIF FileExists(ExpandPath("../images/slideshow/#qryListTimelineEntries.ImageThm#"))>
						<CFSET PageOutput.Timeline[ArrayLen(PageOutput.Timeline)].Image = "images/slideshow/#qryListTimelineEntries.ImageThm#">
					</CFIF>
				</CFLOOP>
			</CFCASE>
			<CFCASE VALUE="indepth">
				<CFIF FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#.txt"))>
					<CFFILE ACTION="Read" FILE="#ExpandPath("../text/planets/#qryPlanetInfo.SearchName#.txt")#" VARIABLE="PageText">
					<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
						OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
					<CFSET PageOutput.Content = CEval(PageTextModified)>
				<CFELSE>
					<CFSET PageOutput.Content = "">
				</CFIF>
			</CFCASE>
			<CFCASE VALUE="moons,sats">
				<CFIF FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-moons.txt"))>
					<CFFILE ACTION="Read" FILE="#ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-moons.txt")#" VARIABLE="PageText">
					<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
						OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
					<CFSET PageOutput.Content = CEval(PageTextModified)>
				<CFELSE>
					<CFSET PageOutput.Content = "">
				</CFIF>
				
				<CFSET SidebarOutput.Moons = ArrayNew(1)>
				<CFSET PrevBodyType = "">
				<CFLOOP QUERY="qryPlanetMoons">
					<CFIF qryPlanetMoons.BodyType IS NOT PrevBodyType>
						<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons) + 1] = StructNew()>
						<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List = ArrayNew(1)>
						<CFSWITCH EXPRESSION="#qryPlanetMoons.BodyType#">
							<CFCASE VALUE="asteroid,comet">
								<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].Title = "List of Science Targets">
							</CFCASE>
							<CFCASE VALUE="dwarf">
								<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].Title = "Known Dwarf Planets">
							</CFCASE>
							<CFCASE VALUE="moon">
								<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].Title = "#qryPlanetInfo.ObjectName#'s Moons">
							</CFCASE>
							<CFCASE VALUE="moon_prov">
								<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].Title = "Provisional Moons">
							</CFCASE>
							<CFCASE VALUE="plutoid">
								<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].Title = "Known Plutoids">
							</CFCASE>
							<CFCASE VALUE="watch">
								<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].Title = "Watch List">
							</CFCASE>
						</CFSWITCH>
					</CFIF>
					<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List[ArrayLen(SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List) + 1] = StructNew()>
					<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List[ArrayLen(SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List)].Title = qryPlanetMoons.ObjectName>
					<CFIF qryPlanetMoons.PlanetURL IS NOT "">
						<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List[ArrayLen(SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List)].URL = qryPlanetMoons.PlanetURL>
					<CFELSE>
						<CFSET SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List[ArrayLen(SidebarOutput.Moons[ArrayLen(SidebarOutput.Moons)].List)].URL = "planets/#LCase(qryPlanetMoons.SearchName)#">
					</CFIF>
					<CFSET PrevBodyType = qryPlanetMoons.BodyType>
				</CFLOOP>
			</CFCASE>
			<CFCASE VALUE="rings">
				<CFIF FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-rings.txt"))>
					<CFFILE ACTION="Read" FILE="#ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-rings.txt")#" VARIABLE="PageText">
					<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
						OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
					<CFSET PageOutput.Content = CEval(PageTextModified)>
				<CFELSE>
					<CFSET PageOutput.Content = "">
				</CFIF>
				
				<CFSET RingContent = "">
				<CFLOOP QUERY="qryPlanetRings">
					<CFSET RingContent = "#RingContent#<B>Ring Name: #qryPlanetRings.RingName#</B><BR>">
					<CFIF qryPlanetRings.Distance IS NOT "">
						<CFSET RingContent = "#RingContent#Distance*: #qryPlanetRings.Distance# km<BR>">
					</CFIF>
					<CFIF qryPlanetRings.Width1 IS NOT "" AND qryPlanetRings.Width2 IS NOT "">
						<CFSET RingContent = "#RingContent#Width: #qryPlanetRings.Width1# km - #qryPlanetRings.Width2# km<BR>">
					<CFELSEIF qryPlanetRings.Width1 IS NOT "">
						<CFSET RingContent = "#RingContent#Width: #qryPlanetRings.Width1# km<BR>">
					</CFIF>
					<CFIF qryPlanetRings.Thickness1 IS NOT "" AND qryPlanetRings.Thickness2 IS NOT "">
						<CFSET RingContent = "#RingContent#Thickness: #qryPlanetRings.Thickness1# km - #qryPlanetRings.Thickness2# km<BR>">
					<CFELSEIF qryPlanetRings.Thickness1 IS NOT "">
						<CFSET RingContent = "#RingContent#Thickness: #qryPlanetRings.Thickness1# km<BR>">
					</CFIF>
					<CFIF qryPlanetRings.Mass IS NOT "">
						<CFSET RingContent = "#RingContent#Mass: #qryPlanetRings.Mass# kg<BR>">
					</CFIF>
					<CFIF qryPlanetRings.Albedo IS NOT "">
						<CFSET RingContent = "#RingContent#Albedo: #qryPlanetRings.Albedo#<BR>">
					</CFIF>
					<CFSET RingContent = "#RingContent#<BR>">
					<CFIF qryPlanetRings.RecordCount GT 1>
						<CFSET RingContent = "#RingContent#* The distance is measured from the planet center to the start of the ring.">
					</CFIF>
				</CFLOOP>
				<CFSET SidebarOutput.RingTitle = "#qryPlanetInfo.ObjectName#'s Rings">
				<CFSET SidebarOutput.Rings = RingContent>
			</CFCASE>
			<CFCASE VALUE="faq">
				<CFIF FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-faq.txt"))>
					<CFFILE ACTION="Read" FILE="#ExpandPath("../text/planets/#qryPlanetInfo.PlanetDirectory#-faq.txt")#" VARIABLE="PageText">
					<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
						OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
					<CFSET PageOutput.Content = CEval(PageTextModified)>
				<CFELSE>
					<CFSET PageOutput.Content = "">
				</CFIF>
			</CFCASE>
			<CFCASE VALUE="facts">
				<!--- TO DO: Get Facts --->
				<CFSET PageOutput.Content = "">
			</CFCASE>
			<CFCASE VALUE="trivia">
				<CFSET t = QueryAddColumn(qryPlanetTrivia,"RandomOrder",ArrayNew(1))>
				<CFLOOP QUERY="qryPlanetTrivia">
					<CFSET t = QuerySetCell(qryPlanetTrivia,"RandomOrder",Hash("#qryPlanetTrivia.TriviaID##Val(qryPlanetTrivia.RecordCount * Rand())#"),qryPlanetTrivia.CurrentRow)>
				</CFLOOP>
				
				<CFQUERY NAME="qryPlanetTrivia" DBTYPE="Query">
				SELECT *
				FROM qryPlanetTrivia
				ORDER BY RandomOrder
				</CFQUERY>
				
				<CFSET PageOutput.Facts = ArrayNew(1)>
				<CFLOOP QUERY="qryPlanetTrivia">
					<CFSET PageOutput.Facts[ArrayLen(PageOutput.Facts) + 1] = StructNew()>
					<CFSET PageOutput.Facts[ArrayLen(PageOutput.Facts)].Title = qryPlanetTrivia.TriviaTitle>
					<CFSET PageOutput.Facts[ArrayLen(PageOutput.Facts)].Content = qryPlanetTrivia.TriviaDesc>
				</CFLOOP>
				
				<CFSET PageOutput.Content = "">
			</CFCASE>
			<CFDEFAULTCASE>
				<CFQUERY NAME="qryContentPageInfo" DATASOURCE="#Application.DSN#">
				SELECT *
				FROM sse3_content_pages
				WHERE LOWER(DirectoryName) = 'planets'
					AND LOWER(FileName) = '#LCase(ListRest(Attributes.URLPath,"/"))#'
					AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
				</CFQUERY>
				
				<CFIF FileExists(ExpandPath("../text/planets/#Replace(qryContentPageInfo.FileName,"/","-","All")#.txt"))>
					<CFFILE ACTION="Read" FILE="#ExpandPath("../text/planets/#Replace(qryContentPageInfo.FileName,"/","-","All")#.txt")#" VARIABLE="PageText">
					<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#"
						OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
					<CFSET PageOutput.Content = CEval(PageTextModified)>
				</CFIF>
				
				<CFIF Request.ShowAdmin GT 0>
					<CFSET PageOutput.AdminLinks = ArrayNew(1)>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Page">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-edit.cfm?URLPath=#PageOutput.Path#">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Page">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-delete.cfm?URLPath=#PageOutput.Path#">
					<CFIF qryContentPageInfo.Status IS "Pending">
						<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
						<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Page">
						<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-publish.cfm?URLPath=#PageOutput.Path#">
					</CFIF>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Page">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-edit.cfm?ParentID=planets/#qryPlanetInfo.SearchName#">
				</CFIF>
			</CFDEFAULTCASE>
		</CFSWITCH>
		
		<CFIF IsDefined("SidebarOutput") IS 0>
			<!--- Only show default sidebar output if specific sidebar hasn't already been defined --->
			<CFSET SidebarOutput.Learn = ArrayNew(1)>
			
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn) + 1] = StructNew()>
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Title = qryPlanetInfo.ObjectName>
			<CFIF FileExists(ExpandPath("../images/planets/#qryPlanetInfo.SidebarImage#"))>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Image = "images/planets/#qryPlanetInfo.SidebarImage#">
			</CFIF>
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#">
			
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsURL = "missions/target/#LCase(qryPlanetInfo.SearchName)#">
			<CFSET MissionsArray = ArrayNew(1)>
			
			<CFLOOP QUERY="qryPlanetMissionsNoFuture" ENDROW="10">
				<CFSET MissionsArray[ArrayLen(MissionsArray) + 1] = StructNew()>
				<CFSET MissionsArray[ArrayLen(MissionsArray)].Title = Replace(qryPlanetMissionsNoFuture.FullName," 0","","All")>
				<CFSET MissionsArray[ArrayLen(MissionsArray)].URL = "missions/#LCase(qryPlanetMissionsNoFuture.MissionDirectory)#">
			</CFLOOP>
			
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Missions = MissionsArray>
			
			<CFQUERY NAME="qryPlanetImages" DATASOURCE="#Application.DSN#">
			SELECT G.*
			FROM sse3_gallery G, sse3_galleryxplanets GXP
			WHERE G.ImageID = GXP.ImageID AND GXP.PlanetID = #qryPlanetInfo.PlanetID#
				AND G.Status = 'Active'
			ORDER BY G.ImageDate DESC, G.ImageID DESC
			</CFQUERY>
			
			<CFSET ImagesArray = ArrayNew(1)>
			
			<CFLOOP QUERY="qryPlanetImages">
				<CFIF FileExists(ExpandPath("../images/galleries/#qryPlanetImages.ImageThm#"))>
					<CFSET ImagesArray[ArrayLen(ImagesArray) + 1] = StructNew()>
					<CFSET ImagesArray[ArrayLen(ImagesArray)].Title = qryPlanetImages.ImageTitle>
					<CFSET ImagesArray[ArrayLen(ImagesArray)].Alt = qryPlanetImages.ImageTitle>
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
			
			<CFQUERY NAME="qryPlanetPeople" DATASOURCE="#Application.DSN#">
			SELECT P.*
			FROM sse3_people P, sse3_planetsxpeople PXP
			WHERE P.PersonID = PXP.PersonID
				AND PXP.PlanetID = #qryPlanetInfo.PlanetID#
				AND P.Status = 'Active'
			ORDER BY P.DateModified DESC, P.PersonID DESC
			</CFQUERY>
	
			<CFSET t = QueryAddColumn(qryPlanetPeople,"RandomOrder",ArrayNew(1))>
			<CFLOOP QUERY="qryPlanetPeople">
				<CFSET t = QuerySetCell(qryPlanetPeople,"RandomOrder",Hash("#qryPlanetPeople.DirectoryName##Val(qryPlanetPeople.RecordCount * Rand())#"),qryPlanetPeople.CurrentRow)>
			</CFLOOP>

			<CFQUERY NAME="qryPlanetPeople" DBTYPE="Query">
			SELECT *
			FROM qryPlanetPeople
			ORDER BY RandomOrder
			</CFQUERY>
			
			<CFSET PeopleArray = ArrayNew(1)>
			
			<CFLOOP QUERY="qryPlanetPeople">
				<CFSET PeopleArray[ArrayLen(PeopleArray) + 1] = StructNew()>
				<CFSET PeopleArray[ArrayLen(PeopleArray)].Name = "#qryPlanetPeople.FirstName# #qryPlanetPeople.LastName#">
				<CFSET PeopleArray[ArrayLen(PeopleArray)].Title = qryPlanetPeople.OccupationShort>
				<CFSET PeopleArray[ArrayLen(PeopleArray)].Content = qryPlanetPeople.ShortDesc>
				<CFSET PeopleArray[ArrayLen(PeopleArray)].URL = "people/#qryPlanetPeople.DirectoryName#">
				<CFIF FileExists(ExpandPath("../images/people/#qryPlanetPeople.ImageHeadshot#"))>
					<CFSET PeopleArray[ArrayLen(PeopleArray)].Image = "images/people/#qryPlanetPeople.ImageHeadshot#">
				</CFIF>
			</CFLOOP>
			
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].People = PeopleArray>
			
			<CFQUERY NAME="qryPlanetEvents" DATASOURCE="#Application.DSN#" MAXROWS="8">
			SELECT E.*
			FROM sse3_events E, sse3_eventsxplanets EXP
			WHERE E.EventID = EXP.EventID AND EXP.PlanetID = #qryPlanetInfo.PlanetID#
				AND (E.StartDate >= #CreateODBCDate(Now())# OR E.EndDate >= #CreateODBCDate(Now())#)
				AND E.Hidden = 0 AND E.Status = 'Active'
			ORDER BY E.StartDate, E.EndDate
			</CFQUERY>
			
			<CFSET EventsArray = ArrayNew(1)>
			
			<CFLOOP QUERY="qryPlanetEvents">
				<CFSET EventsArray[ArrayLen(EventsArray) + 1] = StructNew()>
				<CFSET EventsArray[ArrayLen(EventsArray)].Title = qryPlanetEvents.EventTitle>
				<CFIF qryPlanetEvents.AltDateText IS NOT "">
					<CFSET EventsArray[ArrayLen(EventsArray)].Date = qryPlanetEvents.AltDateText>
				<CFELSEIF IsDate(qryPlanetEvents.EndDate) AND qryPlanetEvents.StartDate IS NOT qryPlanetEvents.EndDate>
					<CFSET EventsArray[ArrayLen(EventsArray)].Date = "#DateFormat(qryPlanetEvents.StartDate,"d mmm yyyy")# - #DateFormat(qryPlanetEvents.EndDate,"d mmm yyyy")#">
				<CFELSE>
					<CFSET EventsArray[ArrayLen(EventsArray)].Date = DateFormat(qryPlanetEvents.StartDate,"d mmm yyyy")>
				</CFIF>
				<CFSET EventsArray[ArrayLen(EventsArray)].URL = qryPlanetEvents.EventURL>
			</CFLOOP>
			
			<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Events = EventsArray>
		</CFIF>
		
		<CFQUERY NAME="qryPlanetSubPages" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_content_pages
		WHERE DirectoryName = 'planets'
			AND LOWER(FileName) LIKE '#LCase(qryPlanetInfo.SearchName)#/%'
			AND Status = 'Active'
		ORDER BY PageOrder
		</CFQUERY>
		
		<CFSET SidebarOutput.Subnav = ArrayNew(1)>
		<CFIF qryParentPlanet.RecordCount GT 0>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Back to #qryParentPlanet.ObjectName#">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryParentPlanet.SearchName)#">
		</CFIF>
		<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
		<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Overview">
		<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#/">
		<CFIF FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#.txt"))>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "In Depth">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#/indepth">
		</CFIF>
		<CFIF qryPlanetMoons.RecordCount GT 0 OR FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-moons.txt"))>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = PageOutput.MoonsTitle>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = PageOutput.MoonsURL>
		</CFIF>
		<CFIF qryPlanetRings.RecordCount GT 0 OR FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-rings.txt"))>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Rings">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#/rings">
		</CFIF>
		<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
		<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Facts & Figures">
		<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#/facts">
		<CFIF FileExists(ExpandPath("../text/planets/#qryPlanetInfo.SearchName#-faq.txt"))>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "FAQ">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#/faq">
		</CFIF>
		<CFIF qryPlanetImages.RecordCount GT 0>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Galleries">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "galleries/target/#qryPlanetInfo.SearchName#">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Target = "_blank">
		</CFIF>
		<CFIF qryPlanetHomework.RecordCount GT 0>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Homework Helper">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "kids/homework.cfm?Target=#qryPlanetInfo.SearchName#">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Target = "_blank">
		</CFIF>
		<CFIF qryPlanetTrivia.RecordCount GT 0>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Trivia">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#LCase(qryPlanetInfo.SearchName)#/trivia">
		</CFIF>
		<CFIF qryRelatedNews.RecordCount GT 0>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "News">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "news/target/#qryPlanetInfo.SearchName#">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Target = "_blank">
		</CFIF>
		<CFLOOP QUERY="qryPlanetSubPages">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = qryPlanetSubPages.NavTitle>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "planets/#qryPlanetSubPagesFileName#">
		</CFLOOP>
		
		<CFIF Request.ShowAdmin GT 0 AND IsDefined("PageOutput.AdminLinks") IS 0>
			<CFSET PageOutput.AdminLinks = ArrayNew(1)>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Planet Page">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/planet-edit.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Planet Page">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/planet-delete.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
			<CFIF qryPlanetInfo.Status IS "Pending">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Planet Page">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/planet-publish.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
			</CFIF>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Planet Page">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/planet-edit.cfm?ParentID=#qryPlanetInfo.SearchName#">
		</CFIF>
	</CFIF>
<CFELSE>
	<!--- Planets Landing Page --->
	<CFSET PageOutput.Section = "planets">
	<CFSET PageOutput.Title = "Planets">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFQUERY NAME="qryListPlanets" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_planets_moons
	WHERE BodyType = 'planet'
	ORDER BY PlanetOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListSmallBodies" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_planets_moons
	WHERE LOWER(SearchName) IN ('meteors','asteroids','dwarf','comets')
	ORDER BY PlanetOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListMoons" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_planets_moons
	WHERE LOWER(SearchName) IN ('moon')
	ORDER BY PlanetOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListRegions" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_planets_moons
	WHERE LOWER(SearchName) IN ('solarsystem','kbos','oort','beyond')
	ORDER BY PlanetOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListStars" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_planets_moons
	WHERE LOWER(SearchName) in ('sun')
	ORDER BY PlanetOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListPresentMissions" DATASOURCE="#Application.DSN#">
	SELECT MissionID, MissionDirectory, FullName, MissionImage
	FROM sse3_missions
	WHERE StartDate IS NOT NULL AND StartDate <= #CreateODBCDate(Now())#
		AND (EndDate IS NULL OR EndDate >= #CreateODBCDate(Now())#)
		<!--- AND GroundBased = 0 --->
	ORDER BY StartDate DESC, EndDate DESC, LOWER(FullName)
	</CFQUERY>
	
	<CFQUERY NAME="qryPresentMissionTargets" DATASOURCE="#Application.DSN#">
	SELECT DISTINCT(PlanetID) AS PlanetID
	FROM sse3_missionsxplanets
	WHERE <CFIF qryListPresentMissions.RecordCount GT 0>MissionID IN (#ValueList(qryListPresentMissions.MissionID)#)<CFELSE>1 = 0</CFIF>
	ORDER BY PlanetID
	</CFQUERY>
	
	<CFSET PageOutput.Planets = ArrayNew(1)>
	<CFLOOP QUERY="qryListPlanets">
		<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets) + 1] = StructNew()>
		<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets)].Title = qryListPlanets.ObjectName>
		<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets)].URL = "planets/#qryListPlanets.SearchName#">
		<CFIF FileExists(ExpandPath("../images/planets/#qryListPlanets.PlanetImage#"))>
			<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets)].Image = "images/planets/#qryListPlanets.PlanetImage#">
		</CFIF>
		<CFIF ListFind(ValueList(qryPresentMissionTargets.PlanetID),qryListPlanets.PlanetID)>
			<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets)].Active = 1>
		<CFELSE>
			<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets)].Active = 0>
		</CFIF>
		<CFSET PageOutput.Planets[ArrayLen(PageOutput.Planets)].Size = Replace(qryListPlanets.Volume,",","","All")>
	</CFLOOP>
	
	<CFSET PageOutput.SmallBodies = ArrayNew(1)>
	<CFLOOP QUERY="qryListSmallBodies">
		<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies) + 1] = StructNew()>
		<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies)].Title = qryListSmallBodies.ObjectName>
		<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies)].URL = "planets/#qryListSmallBodies.SearchName#">
		<CFIF FileExists(ExpandPath("../images/planets/#qryListSmallBodies.PlanetImage#"))>
			<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies)].Image = "images/planets/#qryListSmallBodies.PlanetImage#">
		</CFIF>
		<CFIF ListFind(ValueList(qryPresentMissionTargets.PlanetID),qryListSmallBodies.PlanetID)>
			<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies)].Active = 1>
		<CFELSE>
			<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies)].Active = 0>
		</CFIF>
		<CFSET PageOutput.SmallBodies[ArrayLen(PageOutput.SmallBodies)].Size = Replace(qryListSmallBodies.Volume,",","","All")>
	</CFLOOP>
	
	<CFSET PageOutput.Moons = ArrayNew(1)>
	<CFLOOP QUERY="qryListMoons">
		<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons) + 1] = StructNew()>
		<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Title = qryListMoons.ObjectName>
		<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].URL = "planets/#qryListMoons.SearchName#">
		<CFIF FileExists(ExpandPath("../images/planets/#qryListMoons.PlanetImage#"))>
			<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Image = "images/planets/#qryListMoons.PlanetImage#">
		</CFIF>
		<CFIF ListFind(ValueList(qryPresentMissionTargets.PlanetID),qryListMoons.PlanetID)>
			<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Active = 1>
		<CFELSE>
			<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Active = 0>
		</CFIF>
		<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Size = Replace(qryListMoons.Volume,",","","All")>
	</CFLOOP>
	<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons) + 1] = StructNew()>
	<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Title = "Other Moons">
	<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].URL = "planets/solarsystem/moons">
	<CFIF FileExists(ExpandPath("../images/planets/galpic_othermoons.png"))>
		<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Image = "images/planets/galpic_othermoons.png">
	</CFIF>
	<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Active = 0>
	<CFSET PageOutput.Moons[ArrayLen(PageOutput.Moons)].Size = "">
	
	<CFSET PageOutput.Regions = ArrayNew(1)>
	<CFLOOP QUERY="qryListRegions">
		<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions) + 1] = StructNew()>
		<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions)].Title = qryListRegions.ObjectName>
		<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions)].URL = "planets/#qryListRegions.SearchName#">
		<CFIF FileExists(ExpandPath("../images/planets/#qryListRegions.PlanetImage#"))>
			<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions)].Image = "images/planets/#qryListRegions.PlanetImage#">
		</CFIF>
		<CFIF ListFind(ValueList(qryPresentMissionTargets.PlanetID),qryListRegions.PlanetID)>
			<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions)].Active = 1>
		<CFELSE>
			<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions)].Active = 0>
		</CFIF>
		<CFSET PageOutput.Regions[ArrayLen(PageOutput.Regions)].Size = Replace(qryListRegions.Volume,",","","All")>
	</CFLOOP>
	
	<CFSET PageOutput.Stars = ArrayNew(1)>
	<CFLOOP QUERY="qryListStars">
		<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars) + 1] = StructNew()>
		<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars)].Title = qryListStars.ObjectName>
		<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars)].URL = "planets/#qryListStars.SearchName#">
		<CFIF FileExists(ExpandPath("../images/planets/#qryListStars.PlanetImage#"))>
			<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars)].Image = "images/planets/#qryListStars.PlanetImage#">
		</CFIF>
		<CFIF ListFind(ValueList(qryPresentMissionTargets.PlanetID),qryListStars.PlanetID)>
			<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars)].Active = 1>
		<CFELSE>
			<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars)].Active = 0>
		</CFIF>
		<CFSET PageOutput.Stars[ArrayLen(PageOutput.Stars)].Size = Replace(qryListStars.Volume,",","","All")>
	</CFLOOP>
	
	<CFSET PageOutput.Links = ArrayNew(1)>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Compare the Planets">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "planets/compare">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "What Is a Planet?">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "planets/whatisaplanet">
	
	<CFIF Request.ShowAdmin GT 0>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Planet Page">
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/planet-edit.cfm">
	</CFIF>
</CFIF>