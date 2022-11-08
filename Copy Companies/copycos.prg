SET EXCLUSIVE ON
CLOSE DATABASES ALL
LOCAL LLTARGETCO, LLSOURCECO, LLTARGETPATH, LLSOURCEPATH
TEMP01 = SYS(2015)
TEMP02 = SYS(2015)

LLSOURCECO = 'Z'
LLTARGETCO = 'P'

LLSOURCEPATH = 'C:\ProgramData\Pegasus\O3 Server VFP\Data\'
LLTARGETPATH = 'C:\ProgramData\Pegasus\O3 Server VFP\Data\Comp_P\'

LOCAL OTABLENAME
SELECT * FROM "C:\ProgramData\Pegasus\O3 Server VFP\DataDict\table.dbf" WHERE ALLTRIM(NAME) != 'jx_user' AND MODULEID != 'Y' AND NOT EMPTY(MODULEID) INTO CURSOR CTABLES
COPY TO ARRAY OTABLES FIELDS NAME
NROWCOUNT = ALEN(OTABLES, 1)
FOR NROW = 1 TO NROWCOUNT
        OTABLENAME = TRANSFORM(ALLTRIM(OTABLES[nRow]))
        IF OTABLENAME = 'jx_user' OR OTABLENAME = 'dmphasedet' OR OTABLENAME = 'seqeimph' OR OTABLENAME = 'seqeimpd' OR OTABLENAME = 'zwxaudit.dbf' OR OTABLENAME = 'CKM1SALE.dbf' OR OTABLENAME = 'CKM1STK.dbf' OR OTABLENAME = 'CKM1UPS.dbf' OR OTABLENAME = 'CKM1SPEC.dbf' OR OTABLENAME = 'CKM1USER.dbf' THEN
        ELSE	
                USE  LLTARGETPATH + LLTARGETCO + '_' + OTABLENAME
                DELETE ALL
                PACK
                APPEND FROM LLSOURCEPATH + LLSOURCECO + '_' + OTABLENAME
        ENDIF
        ?TRANSFORM(OTABLENAME)
ENDFOR
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