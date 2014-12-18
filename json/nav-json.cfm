<CFSETTING ENABLECFOUTPUTONLY="Yes">

<CFPARAM NAME="Attributes.URLPath" DEFAULT="">

<CFINCLUDE TEMPLATE="../utilities/LeftNavArray.cfm">

<CFCONTENT TYPE="text/json">

<CFOUTPUT>
{
	"section": [
		{
			"sectionName": "Home",
			"sectionTitle": "Home",
			"sectionUrl": "/"
		},
		{
			"sectionName": "Planets",
			"sectionTitle": "Planets",
			"sectionUrl": "planets/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "planets" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(PlanetsSubNav)#" INDEX="a">{
					"pageName": "#PlanetsSubNav[a].Name#",
					"pageTitle": "#PlanetsSubNav[a].Title#",
					"pageUrl": "#PlanetsSubNav[a].URL#"
					<CFIF IsDefined("PlanetsSubNav[a].Target")>,
					"pageTarget": "#PlanetsSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("PlanetsSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(PlanetsSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#PlanetsSubNav[a].Subs[b].Name#",
							"pageTitle": "#PlanetsSubNav[a].Subs[b].Title#",
							"pageUrl": "#PlanetsSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("PlanetsSubNav[a].Subs[b].Target")>,
							"pageTarget": "#PlanetsSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(PlanetsSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(PlanetsSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "Missions",
			"sectionTitle": "Missions",
			"sectionUrl": "missions/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "missions" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(MissionsSubNav)#" INDEX="a">{
					"pageName": "#MissionsSubNav[a].Name#",
					"pageTitle": "#MissionsSubNav[a].Title#",
					"pageUrl": "#MissionsSubNav[a].URL#"
					<CFIF IsDefined("MissionsSubNav[a].Target")>,
					"pageTarget": "#MissionsSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("MissionsSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(MissionsSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#MissionsSubNav[a].Subs[b].Name#",
							"pageTitle": "#MissionsSubNav[a].Subs[b].Title#",
							"pageUrl": "#MissionsSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("MissionsSubNav[a].Subs[b].Target")>,
							"pageTarget": "#MissionsSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(MissionsSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(MissionsSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "People",
			"sectionTitle": "People",
			"sectionUrl": "people/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "people" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(PeopleSubNav)#" INDEX="a">{
					"pageName": "#PeopleSubNav[a].Name#",
					"pageTitle": "#PeopleSubNav[a].Title#",
					"pageUrl": "#PeopleSubNav[a].URL#"
					<CFIF IsDefined("PeopleSubNav[a].Target")>,
					"pageTarget": "#PeopleSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("PeopleSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(PeopleSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#PeopleSubNav[a].Subs[b].Name#",
							"pageTitle": "#PeopleSubNav[a].Subs[b].Title#",
							"pageUrl": "#PeopleSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("PeopleSubNav[a].Subs[b].Target")>,
							"pageTarget": "#PeopleSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(PeopleSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(PeopleSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "News",
			"sectionTitle": "News & Events",
			"sectionUrl": "news/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "news" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(NewsSubNav)#" INDEX="a">{
					"pageName": "#NewsSubNav[a].Name#",
					"pageTitle": "#NewsSubNav[a].Title#",
					"pageUrl": "#NewsSubNav[a].URL#"
					<CFIF IsDefined("NewsSubNav[a].Target")>,
					"pageTarget": "#NewsSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("NewsSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(NewsSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#NewsSubNav[a].Subs[b].Name#",
							"pageTitle": "#NewsSubNav[a].Subs[b].Title#",
							"pageUrl": "#NewsSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("NewsSubNav[a].Subs[b].Target")>,
							"pageTarget": "#NewsSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(NewsSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(NewsSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "Galleries",
			"sectionTitle": "Galleries",
			"sectionUrl": "galleries/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "galleries" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(GalleriesSubNav)#" INDEX="a">{
					"pageName": "#GalleriesSubNav[a].Name#",
					"pageTitle": "#GalleriesSubNav[a].Title#",
					"pageUrl": "#GalleriesSubNav[a].URL#"
					<CFIF IsDefined("GalleriesSubNav[a].Target")>,
					"pageTarget": "#GalleriesSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("GalleriesSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(GalleriesSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#GalleriesSubNav[a].Subs[b].Name#",
							"pageTitle": "#GalleriesSubNav[a].Subs[b].Title#",
							"pageUrl": "#GalleriesSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("GalleriesSubNav[a].Subs[b].Target")>,
							"pageTarget": "#GalleriesSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(GalleriesSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(GalleriesSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "History",
			"sectionTitle": "History",
			"sectionUrl": "history/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "history" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(HistorySubNav)#" INDEX="a">{
					"pageName": "#HistorySubNav[a].Name#",
					"pageTitle": "#HistorySubNav[a].Title#",
					"pageUrl": "#HistorySubNav[a].URL#"
					<CFIF IsDefined("HistorySubNav[a].Target")>,
					"pageTarget": "#HistorySubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("HistorySubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(HistorySubNav[a].Subs)#" INDEX="b">{
							"pageName": "#HistorySubNav[a].Subs[b].Name#",
							"pageTitle": "#HistorySubNav[a].Subs[b].Title#",
							"pageUrl": "#HistorySubNav[a].Subs[b].URL#"
							<CFIF IsDefined("HistorySubNav[a].Subs[b].Target")>,
							"pageTarget": "#HistorySubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(HistorySubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(HistorySubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "Kids",
			"sectionTitle": "Kids",
			"sectionUrl": "kids/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "kids" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(KidsSubNav)#" INDEX="a">{
					"pageName": "#KidsSubNav[a].Name#",
					"pageTitle": "#KidsSubNav[a].Title#",
					"pageUrl": "#KidsSubNav[a].URL#"
					<CFIF IsDefined("KidsSubNav[a].Target")>,
					"pageTarget": "#KidsSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("KidsSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(KidsSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#KidsSubNav[a].Subs[b].Name#",
							"pageTitle": "#KidsSubNav[a].Subs[b].Title#",
							"pageUrl": "#KidsSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("KidsSubNav[a].Subs[b].Target")>,
							"pageTarget": "#KidsSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(KidsSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(KidsSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		},
		{
			"sectionName": "Educ",
			"sectionTitle": "Education",
			"sectionUrl": "educ/"
			<CFIF ListFirst(Attributes.URLPath,"/") IS "educ" OR ListFirst(Attributes.URLPath,"/") IS "all">,
			"sub": [
				<CFLOOP FROM="1" TO="#ArrayLen(EducSubNav)#" INDEX="a">{
					"pageName": "#EducSubNav[a].Name#",
					"pageTitle": "#EducSubNav[a].Title#",
					"pageUrl": "#EducSubNav[a].URL#"
					<CFIF IsDefined("EducSubNav[a].Target")>,
					"pageTarget": "#EducSubNav[a].Target#"
					</CFIF>
					<CFIF IsDefined("EducSubNav[a].Subs")>,
					"sub": [
						<CFLOOP FROM="1" TO="#ArrayLen(EducSubNav[a].Subs)#" INDEX="b">{
							"pageName": "#EducSubNav[a].Subs[b].Name#",
							"pageTitle": "#EducSubNav[a].Subs[b].Title#",
							"pageUrl": "#EducSubNav[a].Subs[b].URL#"
							<CFIF IsDefined("EducSubNav[a].Subs[b].Target")>,
							"pageTarget": "#EducSubNav[a].Subs[b].Target#"
							</CFIF>
						}<CFIF b LT ArrayLen(EducSubNav[a].Subs)>,</CFIF>
						</CFLOOP>
					]
					</CFIF>
				}<CFIF a LT ArrayLen(EducSubNav)>,</CFIF>
				</CFLOOP>
			]
			</CFIF>
		}
	]
}
</CFOUTPUT>