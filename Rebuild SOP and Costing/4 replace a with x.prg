SET EXCLUSIVE ON
SET SAFETY OFF
CLOSE DATABASES ALL
LOCAL quan, price, lineval, exvat, vatval, qtyinv, qtydelv
LOCAL DATAPATH, DATAPATHT, LLTARGETCO
LOCAL i AS INTEGER
i=1
LLTARGETCO = "I"

DATAPATH = "C:\ProgramData\Pegasus\O3 Server VFP\Data\"
DATAPATHT = "C:\DATA\"

USE C:\DATA\replawx.DBF ALIAS INPUT_ALIAS
DIMENSION TARRAY[19,1]
COPY TO ARRAY TARRAY

FOR EACH rrow IN TARRAY
	?"====****===="
	invoice1 = TARRAY[i,1]
	?invoice1
	i=i+1
	USE DATAPATH + LLTARGETCO + '_' + 'itran.dbf'
	SET FILTER TO ALLTRIM(it_numinv) = ALLTRIM(invoice1) AND it_status = 'X'
	COPY TO DATAPATHT + 'itrantmp.dbf'
	USE  DATAPATHT + 'itrantmp.dbf'
	REPLACE ALL it_status WITH 'A'
	CLOSE DATABASES ALL
	USE  DATAPATH + LLTARGETCO + '_' + 'itran.dbf'
	SET FILTER TO ALLTRIM(it_numinv) = ALLTRIM(invoice1) AND it_status = 'A'
	DELETE ALL
	PACK
	APPEND FROM DATAPATHT + 'itrantmp.dbf'
	CLOSE DATABASES ALL


ENDFOR
