-----------------------Sql 2 : SQL to extract ReOpen defect metrics  
select /*+ PARALLEL(10) */    distinct 
PKEY.project_key || '-' || JI.ISSUENUM as DEFECT_ID,
       PRJ.pname as Proj_name,
       IT.Pname as IssueType_name ,to_char(ci.oldstring) Transition_From,to_char(ci.newstring) Transition_To,
       prty.pname as Priority,
       ist.pname Status,
       res.pname as resolution_name,
        JI.CREATED ,
       JI.UPDATED,
       JI.RESOLUTIONDATE
  from jiraissue JI
 inner join project PRJ on (JI.project = PRJ.ID)
 inner join issuetype IT on (JI.issuetype = IT.id and it.pname = 'Bug')
 inner join priority prty on (JI.priority = prty.id)
 inner join resolution res on (JI.resolution = res.id)
 inner join issuestatus IST on (JI.issuestatus = IST.id)
 inner join PROJECT_KEY PKEY on (PRJ.id = PKEY.project_id)
 inner JOIN changegroup cg on (cg.issueid=ji.id)
 inner join changeitem ci on (ci.groupid = cg.id and ci.field = 'status' and
 to_char(ci.oldstring)='Test WIP' and to_char(ci.newstring)='Not Started')
 where
 (res.pname not in ('By Design', 'Not a bug', 'Duplicate', 'Invalid') and ist.pname not in ('Not a Bug')or res.pname is null) and 
JI.CREATED between TO_DATE('02/01/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'MM/DD/YYYY') and sysdate
--and  pkey.project_key not in ()
 order by JI.CREATED desc;
 
