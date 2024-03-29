*copydbc tables
LOCAL LLTARGETCO, LLSOURCECO, LLTARGETPATH, LLSOURCEPATH, LLSOURCEPATHDBC


llTest = .F.
** set source company and target
LLSOURCECO = 'Z'
LLTARGETCO = 'A'
** point to system fole seqco.dbf 
LLSEQCOPATH = 'C:\ProgramData\Pegasus\O3 Server VFP\System\SEQCO.dbf'


CLEAR 
lcSys16 = SYS(16, 1)
lcProgram = SUBSTR(lcSys16, AT(":", lcSys16) - 1)
lcProgramPath = SUBSTR(lcProgram,1,RAT('\',lcProgram,1)-1)
SET DEFAULT TO &lcProgramPath
SET EXCLUSIVE ON
SET SAFETY OFF 
CLOSE DATABASES ALL
?lcProgramPath
lcCRLF = CHR(13)+CHR(10)
USE (LLSEQCOPATH) ALIAS seqcos
SELECT co_subdir FROM seqcos WHERE ALLTRIM(co_code) == LLSOURCECO INTO CURSOR llsource
LLSOURCEPATH = ALLTRIM(llsource.co_subdir)
IF RIGHT(LLSOURCEPATH,1) == '\' THEN 
	LLSOURCEPATH = ALLTRIM(llsource.co_subdir)
ELSE 
	LLSOURCEPATH = ALLTRIM(llsource.co_subdir) + "\"
ENDIF
CLOSE DATABASES ALL 
USE (LLSEQCOPATH) ALIAS seqcos
SELECT co_subdir FROM seqcos WHERE ALLTRIM(co_code) == LLTARGETCO INTO CURSOR llsource
LLTARGETPATH = ALLTRIM(llsource.co_subdir)
IF RIGHT(LLTARGETPATH,1) == '\' THEN 
	LLTARGETPATH = ALLTRIM(llsource.co_subdir)
ELSE 
	LLTARGETPATH = ALLTRIM(llsource.co_subdir) + "\"
ENDIF 
?'Source: ' + LLSOURCEPATH + 'Comp_' + LLSOURCECO + '.dbc'
?'Target: ' + LLTARGETPATH + 'Comp_' + LLTARGETCO + '.dbc'
CLOSE DATABASES ALL 

logErrorsFile = 'copycologErrors_Target_' + LLTARGETCO + '.csv'
logOKFile = 'copycologOK_Target_' + LLTARGETCO + '.csv'

STRTOFILE("Tables,State"+lcCRLF, logErrorsFile, .F.)
STRTOFILE("Tables,State"+lcCRLF, logOKFile, .F.)
LOCAL OTABLENAME
Public Array aTables[1]
LLSOURCEPATHDBC= LLSOURCEPATH + 'Comp_' + LLSOURCECO + '.dbc'
Open Database (LLSOURCEPATHDBC)  Exclusive
n = ADBOBJECTS(aArrayName,"TABLE")
NROWCOUNT = ALEN(aArrayName, 1)
CLOSE DATABASES ALL 
IF llTest == .F.
	?"---------------------"
	?"Errored copies follow"
	FOR NROW = 1 TO NROWCOUNT
		OTABLENAME = TRANSFORM(ALLTRIM(aArrayName[nRow]))
		TRY 
			USE  LLTARGETPATH + LLTARGETCO + '_' + OTABLENAME
		    DELETE ALL
		    PACK
		    APPEND FROM LLSOURCEPATH + LLSOURCECO + '_' + OTABLENAME
		    STRTOFILE(OTABLENAME + "," + "OK" + lcCRLF, logOKFile, .T.)
		CATCH 
			STRTOFILE(OTABLENAME + "," + "Error" + lcCRLF, logErrorsFile, .T.)	
			?OTABLENAME
		ENDTRY	
	ENDFOR 
ENDIF
CLOSE DATABASES ALL 
USE  LLTARGETPATH + LLTARGETCO + '_' + 'nextid.dbf'
DELETE ALL
PACK
APPEND FROM LLSOURCEPATH + LLSOURCECO + '_' + 'nextid.dbf'
CLOSE DATABASES ALL
USE (LLSEQCOPATH) ALIAS seqco
DELETE FROM seqco WHERE ALLTRIM(co_code) = LLTARGETCO
CLOSE DATABASES ALL 
USE (LLSEQCOPATH)
PACK
CLOSE DATABASES ALL 
USE (LLSEQCOPATH) ALIAS seqco
SELECT * FROM seqco WHERE ALLTRIM(co_code) = LLSOURCECO INTO CURSOR tempSEQCO
SELE 0
USE DBF("tempSEQCO") AGAIN ALIAS tempcoo
REPLACE co_code WITH LLTARGETCO
REPLACE co_subdir WITH  LLTARGETPATH 
REPLACE co_name WITH ALLTRIM(co_name) + ' COPY of: ' + LLSOURCECO 
REPLACE co_slnlco WITH LLTARGETCO
REPLACE co_plnlco WITH LLTARGETCO
REPLACE co_fanlco WITH LLTARGETCO
REPLACE co_stnlco WITH LLTARGETCO
INSERT INTO seqco SELECT * FROM tempcoo
CLOSE DATABASES ALL
USE  LLTARGETPATH + LLTARGETCO + '_ntran.dbf'
replace ALL nt_srcco WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_ndetail.dbf'
replace ALL nt_srcco WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_anoml.dbf'
replace ALL ax_srcco WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_arhead.dbf'
replace ALL ae_srcco WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_pnoml.dbf'
replace ALL px_srcco WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_sparm.dbf'
replace ALL sp_nlcoid WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_pparm.dbf'
replace ALL pp_nlcoid WITH LLTARGETCO 
USE  LLTARGETPATH + LLTARGETCO + '_cparm.dbf'
replace ALL cp_nlcoid WITH LLTARGETCO
USE  LLTARGETPATH + LLTARGETCO + '_wparm.dbf'
replace ALL wp_nlcoid WITH LLTARGETCO
USE  LLTARGETPATH + LLTARGETCO + '_fparm.dbf'
replace ALL fp_nlcomp WITH LLTARGETCO 
CLOSE DATABASES ALL
MESSAGEBOX("Complete",0,"Status")