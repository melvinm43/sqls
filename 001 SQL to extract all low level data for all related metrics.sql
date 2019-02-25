--Sql 1 : SQL to extract all low level data for all related metrics 
select /*+ PARALLEL(10) */
distinct PKEY.project_key || '-' || JI.ISSUENUM as DEFECT_ID,
         
         PRJ.pname as Proj_name,
         
         PRJ.ID as proj_id,
         
         IT.Pname as IssueType_name,
         
         prty.pname as Priority,
         case
           when sev2.customvalue is null then
            'Unknown'
           else
            sev2.customvalue
         end as Bug_Severity,
         Case
           when fnd2.customvalue is null then
            'Unknown'
           else
            fnd2.customvalue
         end as Found_By,
         
         ist.pname Status,
         case
           when res.pname is null then
            'Unknown'
           else
            res.pname
         end as resolution_name,
         
         JI.CREATED,
         
         JI.UPDATED,
         
         JI.RESOLUTIONDATE

  from jiraissue JI

 inner join project PRJ on (JI.project = PRJ.ID)

 inner join issuetype IT on (JI.issuetype = IT.id and it.pname = 'Bug')

 inner join priority prty on (JI.priority = prty.id)

  left outer join resolution res on (JI.resolution = res.id)

 inner join issuestatus IST on (JI.issuestatus = IST.id)

 inner join PROJECT_KEY PKEY on (PRJ.id = PKEY.project_id)

  left outer join CUSTOMFIELDVALUE sev1 on (ji.id = sev1.issue and
                                           sev1.customfield = 11505)

  left outer join CUSTOMFIELDOPTION sev2 on (sev1.stringvalue =
                                            to_char(sev2.id))

  left outer join CUSTOMFIELDVALUE fnd1 on (ji.id = fnd1.issue and
                                           fnd1.customfield = 22001)

  left outer join CUSTOMFIELDOPTION fnd2 on (fnd1.stringvalue =
                                            to_char(fnd2.id))
 where

 JI.CREATED between
 TO_DATE('02/01/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1), 'MM/DD/YYYY') and
 sysdate
 and pkey.project_key not in
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
 order by JI.CREATED asc;