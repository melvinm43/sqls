--Sql 3 and 4 combined : 
select /*+ PARALLEL(10) */
PKEY.project_key || '-' || JI.ISSUENUM as STORY_NUMBER,
         
         PRJ.pname as Proj_name,
         
         PRJ.ID as proj_id,
         
         IT.Pname as IssueType_name,
         prty.pname as Priority,
         to_char(ci.oldstring) Transition_From,
         to_char(ci.newstring) Transition_To,
         cg.created Transition_Date,
         spt2.name sprint,
         TO_DATE('1970-01-01', 'YYYY-MM-DD') + spt2.start_date / 86400000 as sprint_start_date,
         TO_DATE('1970-01-01', 'YYYY-MM-DD') + spt2.end_date / 86400000 as sprint_end_date,
         TO_DATE('1970-01-01', 'YYYY-MM-DD') +
         spt2.complete_date / 86400000 as sprint_complete_date,
         ist.pname Status,
         case
           when ist.statuscategory = 2 then
            'Planned'
           when ist.statuscategory = 3 then
            'Done'
           when ist.statuscategory = 4 then
            'In Progress'
         end as statuscategory,        
         JI.CREATED,
         
         JI.UPDATED,
         
         JI.RESOLUTIONDATE

  from jiraissue JI

 inner join project PRJ on (JI.project = PRJ.ID)

 inner join issuetype IT on (JI.issuetype = IT.id and it.pname = 'Story')

 inner join priority prty on (JI.priority = prty.id)

 inner join issuestatus IST on (JI.issuestatus = IST.id)

 inner join PROJECT_KEY PKEY on (PRJ.id = PKEY.project_id)
 left outer JOIN changegroup cg on (cg.issueid = ji.id)
 left outer join changeitem ci on (ci.groupid = cg.id and ci.field = 'status')
  left outer join CUSTOMFIELDVALUE spt1 on (ji.id = spt1.issue and
                                           spt1.customfield = 10300)
  left outer join AO_60DB71_SPRINT spt2 on (spt1.stringvalue = spt2.id)
 where JI.CREATED between
       TO_DATE('02/01/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1),
               'MM/DD/YYYY') and sysdate 
                --and pkey.project_key not in ()

 order by PKEY.project_key || '-' || JI.ISSUENUM, cg.created