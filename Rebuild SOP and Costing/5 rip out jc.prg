SET SAFETY OFF
SET EXCLUSIVE ON
CLOSE DATABASES ALL
LOCAL DATAPATH, DATAPATHT, JOB, scode
scode='K110'
LOCAL i AS INTEGER
i=1
LLTARGETCO = "I"
DATAPATH = "C:\ProgramData\Pegasus\O3 Server VFP\Data\"
DATAPATHT = "C:\DATA\"

USE c:\DATA\ripoutjc.DBF ALIAS INPUT_ALIAS
DIMENSION RARRAY[104,1]
COPY TO ARRAY RARRAY
FOR EACH JOB IN RARRAY
	JOB=RARRAY[i,1]
	USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\I_JCLINE.DBF"
	?JOB
	SCAN FOR ALLTRIM(JD_CSTDOC)=ALLTRIM(JOB) AND ALLTRIM(jd_ccode)=ALLTRIM(scode)
		REPLACE Jd_QTY WITH 0
		REPLACE JD_VALUE WITH 0
	ENDSCAN
	USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\I_jwipr.DBF"
*?JOB
	SCAN FOR ALLTRIM(JW_CSTDOC)=ALLTRIM(JOB) AND ALLTRIM(jw_scode)=ALLTRIM(scode)
		DELETE
	ENDSCAN
	USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\I_jchead.DBF"
	SCAN FOR ALLTRIM(Jh_CSTDOC)=ALLTRIM(JOB)
		REPLACE jh_ttrev WITH 0
		REPLACE jh_ttrevup WITH 0
	ENDSCAN
	i=i+1
ENDFOR

CLOSE DATABASES ALL
USE ""C:\ProgramData\Pegasus\O3 Server VFP\Data\I_jwipr.DBF"
PACK

CLOSE DATABASES ALL