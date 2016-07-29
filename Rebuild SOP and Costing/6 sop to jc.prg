SET EXCLUSIVE OFF
CLOSE DATABASES ALL
*SET STEP ON
SET SAFETY OFF
LOCAL iJD_LINE, iJCLINE_NEXTID, iJWIPR_NEXTID, LLTARGETCO, JOBCODE, COSTCODE, JOBREF, JOBLINE, llcjclineid, jdvalue, jdqty
LOCAL DATAPATH, DATAPATHT, INVOICE
LOCAL i AS INTEGER

COSTCODE = 'K110'
JOBREF = 'SALES'
LLTARGETCO = "I"

DATAPATH = "C:\ProgramData\Pegasus\O3 Server VFP\Data\"
DATAPATHT = "C:\DATA\"

USE DATAPATH + LLTARGETCO + '_' + 'jcline.Dbf' ALIAS aJCLINE
GO BOTTOM
iJD_LINE = ROUND(VAL(JD_LINE),0)
=AFIELDS(struct_arr)
CREATE CURSOR c1JCLINE FROM ARRAY struct_arr

SELECT c1JCLINE

COPY TO DATAPATHT + 'MYJCLINE.Dbf'

USE DATAPATH + LLTARGETCO + '_' + 'jWIPR.Dbf'
=AFIELDS(struct_arr2)
CREATE CURSOR c1JWIPR FROM ARRAY struct_arr2
i=0
SELECT c1JWIPR

COPY TO DATAPATHT + 'MYJWIPR.Dbf'

CLOSE DATABASES ALL

USE C:\DATA\INVOICES.DBF ALIAS INPUT_ALIAS
DIMENSION TARRAY[104,1]
COPY TO ARRAY TARRAY

FOR EACH rrow IN TARRAY
	i=i+1
	?"====****===="
	invoice1 = TARRAY[i,1]
	?"INVOICE : " +invoice1
	USE DATAPATHT + 'invjccode.dbf' ALIAS jccodelookup
	SCAN FOR ALLTRIM(INVOICE) = ALLTRIM(invoice1)
		JOBCODE = job
		?"JOB : " +job
	ENDSCAN

	iJD_LINE = iJD_LINE+10
	USE DATAPATH + LLTARGETCO + '_' + 'NEXTID.Dbf' ALIAS aNEXTID
	SCAN FOR ALLTRIM(TABLENAME)="JCLINE"
		iJCLINE_NEXTID = NEXTID +1
		REPLACE NEXTID WITH iJCLINE_NEXTID
	ENDSCAN

	USE DATAPATH + LLTARGETCO + '_' + 'itran.Dbf' ALIAS aitran
	SELECT JOBCODE AS JD_CSTDOC, "" AS JD_PHASE, JOBLINE AS JD_LINE, COSTCODE AS JD_CCODE,;
		1 AS JD_RATE, "" AS JD_PROFILE, "" AS JD_STREF, JOBREF AS JD_DESC, 0 AS JD_PROFQTY,;
		(IT_QUAN/100)*-1 AS Jd_QTY, 0 AS JD_QTYBG, 0 AS JD_QTYRV, IT_PRICE/100 AS JD_CSTUNIT,;
		0.0000 AS JD_CSTBG, 0.0000 AS JD_CSTRV, ROUND((IT_PRICE/100)*-1,2) AS JD_VALUE,;
		0.00 AS JD_VALBG, 0.00 AS VALRV, "T" AS JD_WIPR, IT_DATE AS SQ_CRDATE,;
		"12:00:00" AS SQ_CRTIME, "MANAGER" AS SQ_AMUSER, "12:00:00" AS SQ_AMTIME,;
		0.00 AS JD_COMITVAL, "" AS ID;
		FROM aitran WHERE it_numinv = invoice1  AND IT_STATUS = "A" INTO CURSOR cITRAN

	SELECT cITRAN

	COPY TO DATAPATHT + 'ROWITRAN.Dbf'
	USE DATAPATHT + 'MYJCLINE.Dbf'
	APPEND FROM DATAPATHT + 'ROWITRAN.Dbf'

	USE DATAPATH + LLTARGETCO + '_' + 'jWIPR.Dbf'
	=AFIELDS(struct_arr2)
	CREATE CURSOR cJWIPR FROM ARRAY struct_arr2

	SELECT cJWIPR

	SELECT JOBCODE AS jw_cstdoc, "" AS jw_phase, JOBLINE AS jw_line, COSTCODE AS jw_ccode,;
		"" AS jw_profile, 1 AS jw_rate, IT_ANAL AS jw_scode, "" AS jw_pcode, "" AS jw_batch, 12 AS jw_csttype,;
		IT_DESC AS jw_desc, 5 AS jw_trtype, IT_DATE AS jw_trdate, it_numinv AS jw_trref, JOBREF AS jw_comment,;
		(IT_QUAN/100)*-1 AS jw_qty, ROUND((IT_PRICE/100),2) AS jw_cstunit, ((IT_PRICE/100)*((IT_QUAN/100)*-1)) AS jw_value, 0.00 AS jw_ohead,;
		2015 AS jw_year, 0 AS jw_period, "" AS jw_wgrup, 0 AS jw_wgper, "" AS jw_wgemp, "" AS jw_wgpay,;
		"" AS jw_placc, "" AS jw_stref, "" AS jw_stwh, "" AS jw_subcnt, "" AS jw_reqdoc, it_numinv AS jw_invdoc,;
		"" AS jw_docdoc, "" AS jw_podoc, "" AS jw_match, "F" AS jw_confirm, "F" AS jw_alloc, "F" AS jw_trf2wg,;
		IT_DATE AS SQ_CRDATE, "12:00:00" AS SQ_CRTIME, "MANAGER" AS sq_cruser, "" AS sq_amdate, "" AS SQ_AMTIME, "" AS SQ_AMUSER,;
		0 AS jw_dcline, "F" AS jw_frbom, "" AS jw_wodoc, "" AS jw_ptax, "" AS jw_ytax,;
		"" AS ID, "" AS jw_jclinid;
		FROM aitran WHERE it_numinv = invoice1  AND IT_STATUS = "A" INTO CURSOR cITRAN2

	SELECT cITRAN2
	COPY TO DATAPATHT + 'ROWITRAN2.Dbf'
	USE DATAPATHT + 'MYJWIPR.Dbf'
	APPEND FROM DATAPATHT + 'ROWITRAN2.Dbf'

	CLOSE DATABASES ALL

	USE DATAPATH + LLTARGETCO + '_' + 'itran.dbf'
	SCAN FOR it_numinv = invoice1
		REPLACE it_jcstdoc WITH JOBCODE
		REPLACE it_jccode WITH COSTCODE
	ENDSCAN

ENDFOR
?"=====ENDFOR====="

CLOSE DATABASES ALL

USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\i_NEXTID.Dbf" ALIAS aNEXTID

SCAN FOR ALLTRIM(TABLENAME)="JWIPR"
	iJWIPR_NEXTID = NEXTID
ENDSCAN

CLOSE DATABASES ALL

?"=====GOT JWIPR NEXTID===== : "+ TRANSFORM(iJWIPR_NEXTID)

i=0

USE C:\DATA\INVOICES.DBF ALIAS INPUT_ALIAS2
DIMENSION T2ARRAY[104,1]
COPY TO ARRAY T2ARRAY

FOR EACH rrow IN T2ARRAY
	i=i+1
	?"====****===="
	invoice1 = T2ARRAY[i,1]
	?"INVOICE : " +invoice1

	USE DATAPATHT + 'invjccode.dbf' ALIAS jccodelookup

	SCAN FOR ALLTRIM(INVOICE) = ALLTRIM(invoice1)
		JOBCODE = job
		?"JOB : " +job
	ENDSCAN

	USE DATAPATH + LLTARGETCO + '_' + 'jcline.dbf' ALIAS amyjwiprid
	SELECT JD_LINE,ID FROM amyjwiprid WHERE ALLTRIM(JD_CSTDOC)==ALLTRIM(JOBCODE);
		AND ALLTRIM(JD_CCODE)==ALLTRIM(COSTCODE)INTO CURSOR  myjwiprid

	llcjclineid = myjwiprid.ID
	JOBLINE = myjwiprid.JD_LINE

	CLOSE DATABASES ALL

	USE DATAPATHT + 'MYJWIPR.Dbf' ALIAS myjwiprsums
	GO TOP

	SET FILTER TO ALLTRIM(jw_cstdoc) = ALLTRIM(JOBCODE);
		AND ALLTRIM(jw_ccode) = ALLTRIM(COSTCODE)

	REPLACE ALL jw_jclinid WITH llcjclineid
	REPLACE ALL jw_line WITH JOBLINE

	?"=====UPDATED ALL JCLINID TO MATCH JCLINE===== | cstdoc : " +JOBCODE + " | ccode : " ;
		+ COSTCODE + " | ID : " + TRANSFORM(llcjclineid) + " | JW_LINE : " +JOBLINE + " | Rec : " +TRANSFORM(i)

	CLOSE DATABASES ALL

	USE DATAPATHT + 'MYJWIPR.Dbf' ALIAS myjwiprsums

	SELECT SUM(jw_qty) AS jw_qty, SUM(jw_cstunit*(jw_qty)) AS jw_value FROM myjwiprsums ;
		WHERE ALLTRIM(jw_cstdoc) = ALLTRIM(JOBCODE) AND ALLTRIM(jw_ccode) = ALLTRIM(COSTCODE) ;
		INTO CURSOR cmyjwiprsums

	jdvalue = cmyjwiprsums.jw_value
	jdqty = cmyjwiprsums.jw_qty

	?"=====UPDATED ALL JCLINE QTY & VALUES TO MATCH JCWIPR===== | cstdoc : " +JOBCODE + " | QTY : ";
		+ TRANSFORM(jdqty) + " | VALUE : " + TRANSFORM(jdvalue) + " | Rec : " +TRANSFORM(i)

	CLOSE DATABASES ALL

	USE DATAPATH + LLTARGETCO + '_' + 'jcline.dbf' ALIAS updjwiprid
	SCAN FOR ALLTRIM(JD_CSTDOC)==ALLTRIM(JOBCODE);
			AND ALLTRIM(JD_CCODE)==ALLTRIM(COSTCODE)
		REPLACE JD_VALUE WITH jdvalue
		REPLACE Jd_QTY WITH jdqty
	ENDSCAN
	CLOSE DATABASES ALL

	USE DATAPATH + LLTARGETCO + '_' + 'jchead.dbf' ALIAS updjchead
	SCAN FOR ALLTRIM(Jh_CSTDOC)==ALLTRIM(JOBCODE)
		REPLACE jh_ttrev WITH jdvalue
		REPLACE jh_ttrevup WITH jdvalue
	ENDSCAN
	CLOSE DATABASES ALL

ENDFOR

USE DATAPATHT + 'MYJWIPR.Dbf' ALIAS myjwiprid
SCAN
	REPLACE ID WITH iJWIPR_NEXTID +1
	iJWIPR_NEXTID = iJWIPR_NEXTID +1
ENDSCAN
CLOSE DATABASES ALL

USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\i_NEXTID.Dbf" ALIAS aNEXTID
SCAN FOR ALLTRIM(TABLENAME)="JWIPR"
	REPLACE NEXTID WITH iJWIPR_NEXTID
ENDSCAN
CLOSE DATABASES ALL

USE DATAPATH + LLTARGETCO + '_' + 'JWIPR.Dbf' ALIAS updaJWIPR
APPEND FROM DATAPATHT + 'MYJWIPR.Dbf'
CLOSE DATABASES ALL 

MESSAGEBOX("Complete",0,"Status")