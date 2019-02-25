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
and  pkey.project_key not in
 ('EAEIV', 'KCDV', 'DKCITV', 'MAINOAPI', 'SREM', 'TAV', 'APP', 'CICDEAV',
  'DNS', 'OU', 'OAPIINC', 'OAPILLE', 'SP', 'CBS', 'NSPG', 'SS', 'CD',
  'CCBAEI', 'DDKCMI', 'EVC', 'MKPI', 'HT', 'IM', 'PEINC', 'BNSPE', 'TM',
  'MADOP', 'PIM', 'MAGICPRO', 'MAGICT', 'MEMM', 'FPDFP', 'KUBE', 'OCFOOD',
  'APGMT', 'ILPB', 'OEA', 'POIU', 'ISIS', 'CET', 'CFPR', 'VPP', 'MO', 'SIOP',
  'SIOP1', 'IEFOFESP', 'IEOFESP', 'IEFCEP', 'MCB', 'PAAS', 'MCTBOT', 'WM',
  'ASS', 'MGR', 'COOT', 'C12426', 'ETP', 'CSCSER', 'C360V', 'DATF', 'EMIG',
  'SDEM', 'KEM', 'MR2019', 'SMAR2019', 'SC2019', 'MP2019', 'QR2019',
  'YP2019', 'FRAUD', 'FR2019', 'SEC2019', 'YPWI', 'LOY2019', 'LOYAL2019',
  'RP2019', 'OCFF')
 order by JI.CREATED desc;
 
