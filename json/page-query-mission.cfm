<CFIF ListLen(Attributes.URLPath,"/") GT 1>
	<CFIF ListGetAt(Attributes.URLPath,2,"/") IS "target">
		<CFIF ListLen(Attributes.URLPath,"/") IS 2>
			<!--- List of Targets --->
			<CFSET PageOutput.Section = "missions">
			<CFSET PageOutput.Title = "Missions: By Target">
			<CFSET PageOutput.Path = Attributes.URLPath>
			<CFSET PageOutput.Content = "">
			
			<CFSET NonPlanetTargets = "Sun,Asteroids,Dwarf,Comets,Beyond,Moon,SolarSystem,KBOs">
			<CFQUERY NAME="qryListMissionTargets" DATASOURCE="#Application.DSN#">
			SELECT PlanetID, SearchName, ObjectName, MissionImage, PlanetOrder
			FROM sse3_planets_moons
			WHERE (BodyType = 'planet' OR SearchName IN (<CFLOOP FROM="1" TO="#ListLen(NonPlanetTargets)#" INDEX="t">'#ListGetAt(NonPlanetTargets,t)#'<CFIF t LT ListLen(NonPlanetTargets)>,</CFIF></CFLOOP>))
				AND Status = 'Active'
			ORDER BY PlanetOrder
			</CFQUERY>
			
			<CFLOOP QUERY="qryListMissionTargets">
				<CFIF ListFind(NonPlanetTargets,qryListMissionTargets.SearchName)>
					<CFSET t = QuerySetCell(qryListMissionTargets,"PlanetOrder",(100 + ListFind(NonPlanetTargets,qryListMissionTargets.SearchName)),qryListMissionTargets.CurrentRow)>
				</CFIF>
			</CFLOOP>
			
			<CFQUERY NAME="qryListMissionTargets" DBTYPE="Query">
			SELECT *
			FROM qryListMissionTargets
			ORDER BY PlanetOrder
			</CFQUERY>
			
			<CFSET PageOutput.MissionTargetsList = ArrayNew(1)>
			<CFLOOP QUERY="qryListMissionTargets">
				<CFSET PageOutput.MissionTargetsList[ArrayLen(PageOutput.MissionTargetsList) + 1] = StructNew()>
				<CFSET PageOutput.MissionTargetsList[ArrayLen(PageOutput.MissionTargetsList)].Title = qryListMissionTargets.ObjectName>
				<CFSET PageOutput.MissionTargetsList[ArrayLen(PageOutput.MissionTargetsList)].URL = "missions/target/#LCase(qryListMissionTargets.SearchName)#">
				<CFIF FileExists(ExpandPath("../images/missions/#qryListMissionTargets.MissionImage#"))>
					<CFSET PageOutput.MissionTargetsList[ArrayLen(PageOutput.MissionTargetsList)].Image = "images/missions/#qryListMissionTargets.MissionImage#">
				</CFIF>
			</CFLOOP>
		<CFELSE>
			<!--- Specific Target --->
			<CFQUERY NAME="qryMissionTargetInfo" DATASOURCE="#Application.DSN#">
			SELECT PlanetID, SearchName, ObjectName, MissionImage
			FROM sse3_planets_moons
			WHERE LOWER(SearchName) = '#LCase(ListGetAt(Attributes.URLPath,3,"/"))#'
				AND Status = 'Active'
			ORDER BY PlanetOrder
			</CFQUERY>
			
			<CFIF qryMissionTargetInfo.RecordCount GT 0>
				<CFSET PageOutput.Section = "missions">
				<CFSET PageOutput.Title = "Missions: #qryMissionTargetInfo.ObjectName#">
				<CFSET PageOutput.Path = Attributes.URLPath>
				<CFSET PageOutput.Content = "">
				
				<CFQUERY NAME="qryListTargetMissionsNoFuture" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.MissionImage, MXP.TargetType
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryMissionTargetInfo.PlanetID#
					AND M.StartDate IS NOT NULL AND M.StartDate <= #CreateODBCDate(Now())#
					AND M.Status = 'Active'
				ORDER BY M.StartDate DESC, M.EndDate DESC, LOWER(M.FullName)
				</CFQUERY>
				
				<CFQUERY NAME="qryListTargetMissionsFuture" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.MissionImage, MXP.TargetType
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryMissionTargetInfo.PlanetID#
					AND M.StartDate > #CreateODBCDate(Now())#
					AND M.Status = 'Active'
				ORDER BY M.StartDate DESC, M.EndDate DESC, LOWER(M.FullName)
				</CFQUERY>
				
				<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryListTargetMissionsNoFuture,qryListTargetMissionsFuture" OUTPUT="qryListTargetMissions">
				
				<CFSET PageOutput.MissionsList = ArrayNew(1)>
				<CFLOOP QUERY="qryListTargetMissions">
					<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList) + 1] = StructNew()>
					<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].Title = Replace(qryListTargetMissions.FullName," 0"," ","All")>
					<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].URL = "missions/#qryListTargetMissions.MissionDirectory#">
					<CFIF FileExists(ExpandPath("../images/missions/#qryListTargetMissions.MissionImage#"))>
						<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].Image = "images/missions/#qryListTargetMissions.MissionImage#">
					</CFIF>
				</CFLOOP>
			</CFIF>
		</CFIF>
		
		<CFSET PageOutput.Links = ArrayNew(1)>
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Active">
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "missions/">
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "By Type">
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "missions/type">
	<CFELSEIF ListGetAt(Attributes.URLPath,2,"/") IS "type">
		<CFSET MissionTypes = "orbiter,probe,rover,aerial,lander,impact,flyby,samplereturn">
		<CFSET MissionTypeNames = "Orbiter,Probe,Rover,Aerial,Lander,Impact,Flyby,Sample Return">
		<CFIF ListLen(Attributes.URLPath,"/") IS 2>
			<!--- List of Types --->
			<CFSET PageOutput.Section = "missions">
			<CFSET PageOutput.Title = "Missions: By Type">
			<CFSET PageOutput.Path = Attributes.URLPath>
			<CFSET PageOutput.Content = "">
			
			<CFSET PageOutput.MissionTypesList = ArrayNew(1)>
			<CFLOOP FROM="1" TO="#ListLen(MissionTypes)#" INDEX="m">
				<CFSET PageOutput.MissionTypesList[ArrayLen(PageOutput.MissionTypesList) + 1] = StructNew()>
				<CFSET PageOutput.MissionTypesList[ArrayLen(PageOutput.MissionTypesList)].Title = ListGetAt(MissionTypeNames,m)>
				<CFSET PageOutput.MissionTypesList[ArrayLen(PageOutput.MissionTypesList)].URL = "missions/type/#ListGetAt(MissionTypes,m)#">
				<CFIF FileExists(ExpandPath("../images/missions/missionType_#ListGetAt(MissionTypes,m)#.png"))>
					<CFSET PageOutput.MissionTypesList[ArrayLen(PageOutput.MissionTypesList)].Image = "images/missions/missionType_#ListGetAt(MissionTypes,m)#.png">
				</CFIF>
			</CFLOOP>
		<CFELSE>
			<!--- Specific Type --->
			<CFIF ListFindNoCase(MissionTypes,ListGetAt(Attributes.URLPath,3,"/"))>
				<CFSET PageOutput.Section = "missions">
				<CFSET PageOutput.Title = "Missions: #ListGetAt(MissionTypeNames,ListFindNoCase(MissionTypes,ListGetAt(Attributes.URLPath,3,"/")))#">
				<CFSET PageOutput.Path = Attributes.URLPath>
				<CFSET PageOutput.Content = "">
				
				<CFQUERY NAME="qryListTypeMissionsNoFuture" DATASOURCE="#Application.DSN#">
				SELECT MissionID, MissionDirectory, FullName, MissionImage, MType
				FROM sse3_missions
				WHERE LOWER(MType) LIKE '%#LCase(ListGetAt(MissionTypeNames,ListFindNoCase(MissionTypes,ListGetAt(Attributes.URLPath,3,"/"))))#%' 
					AND StartDate IS NOT NULL AND StartDate <= #CreateODBCDate(Now())#
					AND Status = 'Active'
				ORDER BY StartDate DESC, EndDate DESC, LOWER(FullName)
				</CFQUERY>
				
				<CFQUERY NAME="qryListTypeMissionsFuture" DATASOURCE="#Application.DSN#">
				SELECT MissionID, MissionDirectory, FullName, MissionImage, MType
				FROM sse3_missions
				WHERE LOWER(MType) LIKE '%#LCase(ListGetAt(MissionTypeNames,ListFindNoCase(MissionTypes,ListGetAt(Attributes.URLPath,3,"/"))))#%' 
					AND StartDate > #CreateODBCDate(Now())#
					AND Status = 'Active'
				ORDER BY StartDate DESC, EndDate DESC, LOWER(FullName)
				</CFQUERY>
				
				<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryListTypeMissionsNoFuture,qryListTypeMissionsFuture" OUTPUT="qryListTypeMissions">
				
				<CFSET PageOutput.MissionsList = ArrayNew(1)>
				<CFLOOP QUERY="qryListTypeMissions">
					<CFIF ListFindNoCase(qryListTypeMissions.MType,ListGetAt(MissionTypeNames,ListFindNoCase(MissionTypes,ListGetAt(Attributes.URLPath,3,"/"))))>
						<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList) + 1] = StructNew()>
						<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].Title = Replace(qryListTypeMissions.FullName," 0"," ","All")>
						<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].URL = "missions/#qryListTypeMissions.MissionDirectory#">
						<CFIF FileExists(ExpandPath("../images/missions/#qryListTypeMissions.MissionImage#"))>
							<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].Image = "images/missions/#qryListTypeMissions.MissionImage#">
						</CFIF>
					</CFIF>
				</CFLOOP>
			</CFIF>
		</CFIF>
		
		<CFSET PageOutput.Links = ArrayNew(1)>
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Active">
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "missions/">
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "By Target">
		<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "missions/target">
		
		<CFIF Request.ShowAdmin GT 0>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Mission">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/mission-edit.cfm">
		</CFIF>
	<CFELSE>
		<CFQUERY NAME="qryMissionInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_missions
		WHERE LOWER(MissionDirectory) = '#LCase(ListGetAt(Attributes.URLPath,2,"/"))#'
			AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
		</CFQUERY>
		
		<CFIF qryMissionInfo.RecordCount GT 0>
			<CFQUERY NAME="qryMissionTrivia" DATASOURCE="#Application.DSN#">
			SELECT *
			FROM sse3_trivia
			WHERE Category = '#qryMissionInfo.MissionDirectory#'
				AND TriviaType = 'Main Trivia' AND Status = 'Active'
			</CFQUERY>
			
			<CFQUERY NAME="qryMissionEvents" DATASOURCE="#Application.DSN#" MAXROWS="8">
			SELECT E.*
			FROM sse3_events E, sse3_eventsxmissions EXM
			WHERE E.EventID = EXM.EventID AND EXM.MissionID = #qryMissionInfo.MissionID#
				AND E.KeyEvent > 0 AND E.Hidden = 0 AND E.Status = 'Active'
			ORDER BY E.StartDate, E.EndDate
			</CFQUERY>
			
			<CFQUERY NAME="qryMissionImages" DATASOURCE="#Application.DSN#" MAXROWS="8">
			SELECT G.*
			FROM sse3_gallery G, sse3_galleryxmissions GXM
			WHERE G.ImageID = GXM.ImageID AND GXM.MissionID = #qryMissionInfo.MissionID#
				AND G.Status = 'Active'
			ORDER BY G.ImageDate DESC, G.ImageID DESC
			</CFQUERY>
			
			<CFQUERY NAME="qryMissionTargets" DATASOURCE="#Application.DSN#">
			SELECT PM.*, MXP.TargetType
			FROM sse3_planets_moons PM, sse3_missionsxplanets MXP
			WHERE PM.PlanetID = MXP.PlanetID AND MXP.MissionID = #qryMissionInfo.MissionID#
				AND PM.Status = 'Active'
			ORDER BY PM.ObjectName, MXP.TargetType
			</CFQUERY>
			
			<CFQUERY NAME="qryMissionPrimaryTarget" DBTYPE="Query">
			SELECT *
			FROM qryMissionTargets
			WHERE TargetType = 'Primary'
			</CFQUERY>
			<CFQUERY NAME="qryMissionOtherTargets" DBTYPE="Query">
			SELECT *
			FROM qryMissionTargets
			WHERE TargetType != 'Primary'
			</CFQUERY>
			<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryMissionPrimaryTarget,qryMissionOtherTargets" OUTPUT="qryMissionTargets">
			
			<CFQUERY NAME="qryRelatedNews" DATASOURCE="#Application.DSN#">
			SELECT N.*
			FROM sse3_news N, sse3_newsxmissions NXM
			WHERE N.NewsID = NXM.NewsID
				AND NXM.MissionID = #qryMissionInfo.MissionID#
				<!--- AND N.NewsDate <= #qryNewsInfo.NewsDate# ---> AND N.Status = 'Active'
			ORDER BY N.NewsDate DESC, N.NewsID DESC
			</CFQUERY>
			
			<CFSET PageOutput.Section = "missions">
			<CFSET PageOutput.Title = Replace(qryMissionInfo.FullName," 0"," ","All")>
			<CFIF qryMissionInfo.Slogan IS NOT "">
				<CFSET PageOutput.Subtitle = qryMissionInfo.Slogan>
			</CFIF>
			<CFIF ListLen(Attributes.URLPath,"/") GT 2>
				<CFSET PageOutput.Path = "missions/#qryMissionInfo.MissionDirectory#/#ListGetAt(Attributes.URLPath,3,"/")#">
				<CFSET ContentSection = ListGetAt(Attributes.URLPath,3,"/")>
			<CFELSE>
				<CFSET PageOutput.Path = "missions/#qryMissionInfo.MissionDirectory#">
				<CFSET ContentSection = "">
			</CFIF>
			<CFSET PageOutput.UpdateDate = DateFormat(qryMissionInfo.DateModified,"d mmmm yyyy")>
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
					
					<CFSET PageOutput.Content = qryMissionInfo.LongDesc>
					
					<CFIF FileExists(ExpandPath("../includes/missions/vitalstats-#LCase(qryMissionInfo.MissionDirectory)#.html"))>
						<CFSET PageOutput.VitalStats = "includes/missions/vitalstats-#LCase(qryMissionInfo.MissionDirectory)#.html">
					</CFIF>
					
					<CFSET PageOutput.Related = ArrayNew(1)>
					<CFLOOP QUERY="qryRelatedNews" ENDROW="3">
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related) + 1] = StructNew()>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Title = qryRelatedNews.NewsTitle>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].PubDate = DateFormat(qryRelatedNews.NewsDate,"d mmm yyyy")>
						<CFIF FileExists(ExpandPath("../images/news/#qryRelatedNews.NewsImage#"))>
							<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Image = "images/news/#qryRelatedNews.NewsImage#">
						<CFELSEIF FileExists(ExpandPath("../images/missions/#qryMissionInfo.MissionImage#"))>
							<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Image = "images/missions/#qryMissionInfo.MissionImage#">
						</CFIF>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].URL = "news/#qryRelatedNews.URLPath#">
					</CFLOOP>
					
					<CFSET PageOutput.RelatedURL = "news/mission/#LCase(qryMissionInfo.MissionDirectory)#">
					
					<CFQUERY NAME="qryListTimelineEntries" DATASOURCE="#Application.DSN#">
					SELECT *
					FROM sse3_feature_timeline
					WHERE EventCategory = '#qryMissionInfo.MissionDirectory#' AND Status = 'Active'
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
					<CFIF FileExists(ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#.txt"))>
						<CFFILE ACTION="Read" FILE="#ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#.txt")#" VARIABLE="PageText">
						<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
							OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
						<CFSET PageOutput.Content = CEval(PageTextModified)>
					<CFELSEIF FileExists(ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#.txt"))>
						<CFFILE ACTION="Read" FILE="#ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#.txt")#" VARIABLE="PageText">
						<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#" 
							OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
						<CFSET PageOutput.Content = CEval(PageTextModified)>
					<CFELSE>
						<CFSET PageOutput.Content = "">
					</CFIF>
				</CFCASE>
				<CFCASE VALUE="trivia">
					<CFSET t = QueryAddColumn(qryMissionTrivia,"RandomOrder",ArrayNew(1))>
					<CFLOOP QUERY="qryMissionTrivia">
						<CFSET t = QuerySetCell(qryMissionTrivia,"RandomOrder",Hash("#qryMissionTrivia.TriviaID##Val(qryMissionTrivia.RecordCount * Rand())#"),qryMissionTrivia.CurrentRow)>
					</CFLOOP>

					<CFQUERY NAME="qryMissionTrivia" DBTYPE="Query">
					SELECT *
					FROM qryMissionTrivia
					ORDER BY RandomOrder
					</CFQUERY>
					
					<CFSET PageOutput.Facts = ArrayNew(1)>
					<CFLOOP QUERY="qryMissionTrivia">
						<CFSET PageOutput.Facts[ArrayLen(PageOutput.Facts) + 1] = StructNew()>
						<CFSET PageOutput.Facts[ArrayLen(PageOutput.Facts)].Title = qryMissionTrivia.TriviaTitle>
						<CFSET PageOutput.Facts[ArrayLen(PageOutput.Facts)].Content = qryMissionTrivia.TriviaDesc>
					</CFLOOP>
					
					<CFSET PageOutput.Content = "">
				</CFCASE>
				<CFCASE VALUE="dates">
					<CFSET PageOutput.Events = ArrayNew(1)>
					<CFLOOP QUERY="qryMissionEvents">
						<CFSET PageOutput.Events[ArrayLen(PageOutput.Events) + 1] = StructNew()>
						<CFSET PageOutput.Events[ArrayLen(PageOutput.Events)].Title = qryMissionEvents.EventTitle>
						<CFIF IsDate(qryMissionEvents.EndDate) AND qryMissionEvents.StartDate IS NOT qryMissionEvents.EndDate>
							<CFSET PageOutput.Events[ArrayLen(PageOutput.Events)].Date = "#DateFormat(qryMissionEvents.StartDate,"d mmm yyyy")# - #DateFormat(qryMissionEvents.EndDate,"d mmm yyyy")#">
						<CFELSE>
							<CFSET PageOutput.Events[ArrayLen(PageOutput.Events)].Date = DateFormat(qryMissionEvents.StartDate,"d mmm yyyy")>
						</CFIF>
						<CFSET PageOutput.Events[ArrayLen(PageOutput.Events)].Content = qryMissionEvents.LongDesc>
						<CFSET PageOutput.Events[ArrayLen(PageOutput.Events)].URL = qryMissionEvents.EventURL>
					</CFLOOP>
					
					<CFSET PageOutput.Content = "">
				</CFCASE>
				<CFCASE VALUE="faq">
					<CFIF FileExists(ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#-faq.txt"))>
						<CFFILE ACTION="Read" FILE="#ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#-faq.txt")#" VARIABLE="PageText">
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
				<CFCASE VALUE="news">
					<CFSET PageOutput.Related = ArrayNew(1)>
					<CFLOOP QUERY="qryRelatedNews" ENDROW="20">
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related) + 1] = StructNew()>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Title = qryRelatedNews.NewsTitle>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].PubDate = DateFormat(qryRelatedNews.NewsDate,"d mmm yyyy")>
						<CFIF FileExists(ExpandPath("../images/news/#qryRelatedNews.NewsImage#"))>
							<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Image = "images/news/#qryRelatedNews.NewsImage#">
						<CFELSEIF FileExists(ExpandPath("../images/missions/#qryMissionInfo.MissionImage#"))>
							<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].Image = "images/missions/#qryMissionInfo.MissionImage#">
						</CFIF>
						<CFSET PageOutput.Related[ArrayLen(PageOutput.Related)].URL = "news/#qryRelatedNews.URLPath#">
					</CFLOOP>
					
					<CFSET PageOutput.RelatedURL = "news/mission/#LCase(qryMissionInfo.MissionDirectory)#">
					
					<CFSET PageOutput.Content = "">
				</CFCASE>
				<CFDEFAULTCASE>
					<CFQUERY NAME="qryContentPageInfo" DATASOURCE="#Application.DSN#">
					SELECT *
					FROM sse3_content_pages
					WHERE LOWER(DirectoryName) = 'missions'
						AND LOWER(FileName) = '#LCase(ListRest(Attributes.URLPath,"/"))#'
						AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
					</CFQUERY>
					
					<CFIF FileExists(ExpandPath("../text/missions/#Replace(qryContentPageInfo.FileName,"/","-","All")#.txt"))>
						<CFFILE ACTION="Read" FILE="#ExpandPath("../text/missions/#Replace(qryContentPageInfo.FileName,"/","-","All")#.txt")#" VARIABLE="PageText">
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
						<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-edit.cfm?ParentID=missions/#qryMissionInfo.MissionDirectory#">
					</CFIF>
				</CFDEFAULTCASE>
			</CFSWITCH>
			
			<CFSET SidebarOutput.Learn = ArrayNew(1)>
			<CFLOOP QUERY="qryMissionTargets">
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn) + 1] = StructNew()>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Title = qryMissionTargets.ObjectName>
				<CFIF FileExists(ExpandPath("../images/planets/#qryMissionTargets.SidebarImage#"))>
					<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Image = "images/planets/#qryMissionTargets.SidebarImage#">
				</CFIF>
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].URL = "planets/#LCase(qryMissionTargets.SearchName)#">
				
				<CFSET MissionsArray = ArrayNew(1)>
				
				<CFQUERY NAME="qryPlanetMissions" DATASOURCE="#Application.DSN#">
				SELECT M.MissionID, M.MissionDirectory, M.FullName, M.StartDate, M.EndDate
				FROM sse3_missions M, sse3_missionsxplanets MXP
				WHERE M.MissionID = MXP.MissionID AND MXP.PlanetID = #qryMissionTargets.PlanetID#
					AND M.StartDate <= #CreateODBCDate(qryMissionInfo.StartDate)#
					AND M.MissionID != #qryMissionInfo.MissionID# AND M.Status = 'Active'
				ORDER BY M.StartDate DESC, M.EndDate DESC
				</CFQUERY>
				
				<CFLOOP QUERY="qryPlanetMissions" ENDROW="10">
					<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsTitle = "#qryMissionTargets.ObjectName#">
					<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].MissionsURL = "missions/target/#LCase(qryMissionTargets.SearchName)#">
					<CFSET MissionsArray[ArrayLen(MissionsArray) + 1] = StructNew()>
					<CFSET MissionsArray[ArrayLen(MissionsArray)].Title = Replace(qryPlanetMissions.FullName," 0","","All")>
					<CFSET MissionsArray[ArrayLen(MissionsArray)].URL = "missions/#LCase(qryPlanetMissions.MissionDirectory)#">
				</CFLOOP>
				
				<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].Missions = MissionsArray>
				
				<CFQUERY NAME="qryPlanetImages" DATASOURCE="#Application.DSN#">
				SELECT G.*
				FROM sse3_gallery G, sse3_galleryxplanets GXP
				WHERE G.ImageID = GXP.ImageID AND GXP.PlanetID = #qryMissionTargets.PlanetID#
					AND G.Status = 'Active'
				ORDER BY G.ImageDate DESC, G.ImageID DESC
				</CFQUERY>
				
				<CFSET ImagesArray = ArrayNew(1)>
				
				<CFLOOP QUERY="qryPlanetImages">
					<CFIF FileExists(ExpandPath("../images/galleries/#qryPlanetImages.ImageThm#"))>
						<CFSET SidebarOutput.Learn[ArrayLen(SidebarOutput.Learn)].GalleryURL = "galleries/target/#LCase(qryMissionTargets.SearchName)#">
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
		
				<CFQUERY NAME="qryPlanetPeople" DATASOURCE="#Application.DSN#">
				SELECT P.*
				FROM sse3_people P, sse3_planetsxpeople PXP
				WHERE P.PersonID = PXP.PersonID
					AND PXP.PlanetID = #qryMissionTargets.PlanetID#
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
			</CFLOOP>
			
			<CFQUERY NAME="qryMissionSubPages" DATASOURCE="#Application.DSN#">
			SELECT *
			FROM sse3_content_pages
			WHERE DirectoryName = 'missions'
				AND LOWER(FileName) LIKE '#LCase(qryMissionInfo.MissionDirectory)#/%'
				AND Status = 'Active'
			ORDER BY PageOrder
			</CFQUERY>
			
			<CFSET SidebarOutput.Subnav = ArrayNew(1)>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Overview">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#LCase(qryMissionInfo.MissionDirectory)#">
			<CFIF FileExists(ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#.txt"))>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "In Depth">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#LCase(qryMissionInfo.MissionDirectory)#/overview">
			</CFIF>
			<CFIF qryMissionTrivia.RecordCount GT 0>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Trivia">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#LCase(qryMissionInfo.MissionDirectory)#/trivia">
			</CFIF>
			<CFIF qryMissionEvents.RecordCount GT 0>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Key Dates">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#LCase(qryMissionInfo.MissionDirectory)#/dates">
			</CFIF>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Facts & Figures">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#LCase(qryMissionInfo.MissionDirectory)#/facts">
			<CFIF FileExists(ExpandPath("../text/missions/#qryMissionInfo.MissionDirectory#-faq.txt"))>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "FAQ">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#LCase(qryMissionInfo.MissionDirectory)#/faq">
			</CFIF>
			<CFIF qryMissionImages.RecordCount GT 0>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "Galleries">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "galleries/mission/#qryMissionInfo.MissionDirectory#">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Target = "_blank">
			</CFIF>
			<CFIF qryRelatedNews.RecordCount GT 0>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = "News">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "news/mission/#qryMissionInfo.MissionDirectory#">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Target = "_blank">
			</CFIF>
			<CFLOOP QUERY="qryMissionSubPages">
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = qryMissionSubPages.NavTitle>
				<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "missions/#qryMissionSubPages.FileName#">
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0 AND IsDefined("PageOutput.AdminLinks") IS 0>
				<CFSET PageOutput.AdminLinks = ArrayNew(1)>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Mission">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/mission-edit.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Mission">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/mission-delete.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFIF qryMissionInfo.Status IS "Pending">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Mission">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/mission-publish.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				</CFIF>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Mission">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/mission-edit.cfm">
			</CFIF>
		</CFIF>
	</CFIF>
<CFELSE>
	<!--- Missions Landing Page (Active) --->
	<CFSET PageOutput.Section = "missions">
	<CFSET PageOutput.Title = "Missions: Active">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFQUERY NAME="qryListPresentMissions" DATASOURCE="#Application.DSN#">
	SELECT MissionID, MissionDirectory, FullName, MissionImage
	FROM sse3_missions
	WHERE StartDate IS NOT NULL AND StartDate <= #CreateODBCDate(Now())#
		AND (EndDate IS NULL OR EndDate >= #CreateODBCDate(Now())#)
		AND GroundBased = 0
	ORDER BY StartDate DESC, EndDate DESC, LOWER(FullName)
	</CFQUERY>
	
	<CFSET PageOutput.MissionsList = ArrayNew(1)>
	<CFLOOP QUERY="qryListPresentMissions">
		<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList) + 1] = StructNew()>
		<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].Title = Replace(qryListPresentMissions.FullName," 0"," ","All")>
		<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].URL = "missions/#qryListPresentMissions.MissionDirectory#">
		<CFIF FileExists(ExpandPath("../images/missions/#qryListPresentMissions.MissionImage#"))>
			<CFSET PageOutput.MissionsList[ArrayLen(PageOutput.MissionsList)].Image = "images/missions/#qryListPresentMissions.MissionImage#">
		</CFIF>
	</CFLOOP>
	
	<CFSET PageOutput.Links = ArrayNew(1)>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "By Target">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "missions/target">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "By Type">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "missions/type">
	
	<CFIF Request.ShowAdmin GT 0>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Mission">
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/mission-edit.cfm">
	</CFIF>
</CFIF>