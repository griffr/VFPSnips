*/UPDATE STOCK PRICES*/
LPARAMETERS llcompany
?
? '2 - Stock Start - ' + TIME()
?
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("2 - Stock Start - " + TIME(),"REPORTEND.TXT",1)

USE nightprice EXCLUSIVE
DELETE ALL
PACK

LOCAL lcseqcopath, llcosbudir,lcpricesheet,lldatapath,lllookupco
LOCAL lcsheets,llshref1,lccolumns,lcrange,llstockcolumn,llvaluecolumn,llrangestart,llrangeend
LOCAL lcvalue, loini, lnerror,llerror,lnmain,lnstocks,lnvalues,llnpreccount
loini = NEWOBJECT("oldinireg",HOME() + "ffc\registry.vcx")

?"Company: "+ALLTRIM(llcompany)
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("Company: "+ALLTRIM(llcompany),"REPORTEND.TXT",1)

lnerror = loini.getinientry(@lcseqcopath,"Preferences","SEQCOPATH",lcprogrampath+"\hmrecost.ini")

?"SEQCO Path: " +ALLTRIM(lcseqcopath)
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("SEQCO Path: " +ALLTRIM(lcseqcopath),"REPORTEND.TXT",1)

USE IN a lcseqcopath + "\seqco"
LOCATE FOR a.co_code = llcompany

llcosubdir = a.co_subdir

?"CO Subdir: " + ALLTRIM(llcosubdir)
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("CO Subdir: " + ALLTRIM(llcosubdir),"REPORTEND.TXT",1)

CLOSE DATABASES ALL
DIMENSION alprices(1,2)
lllookupco = "COMP"+ALLTRIM(llcompany)

lnerror = loini.getinientry(@lcpricesheet,"Preferences",lllookupco,lcprogrampath+"\hmrecost.ini")

?"Source Sheet: "+ALLTRIM(lcpricesheet)
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("Source Sheet: "+ALLTRIM(lcpricesheet),"REPORTEND.TXT",1)

*/GET SHEETS DATA FROM INI*/

lnerror = loini.getinientry(@lcsheets,"ExcelSheets","Sheets"+llcompany,lcprogrampath+"\hmrecost.ini")
IF lnerror = 0 THEN
	nrows = ALINES(lasheets, STRTRAN(lcsheets,",",CHR(13)))
	lcsubject = "STARTED" + TIME()
	lcbody = "HMRECOST BEGINS"
ELSE
	lcsubject = "Error"
	lcbody = "Error"
	WAIT WIND "Error!"
ENDIF

TRY
	oexcel = CREATEOBJECT("Excel.Application")
	llerror=.F.
CATCH TO m.loexception
	llerror=.T.
	lcreturnerror = m.loexception.MESSAGE ;
		+ " (" + TRANSFORM(m.loexception.ERRORNO) + ") in " ;
		+ LOWER(PROGRAM()) + " on " + TRANSFORM(m.loexception.LINENO) ;
		+ " Details: "+m.loexception.DETAILS+" - Line Contents: "+m.loexception.LINECONTENTS
	lcbody = "Error 10 - "+lcreturnerror
	EXIT
ENDTRY


IF llerror = .F.
	?"Excel Initialized"
	STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
	STRTOFILE("Excel Initialized","REPORTEND.TXT",1)
	TRY
		oexcel.workbooks.OPEN(ALLTRIM(lcpricesheet),,.T.)
	CATCH TO m.loexception
		llerror=.T.
		lcreturnerror = m.loexception.MESSAGE ;
			+ " (" + TRANSFORM(m.loexception.ERRORNO) + ") in " ;
			+ LOWER(PROGRAM()) + " on " + TRANSFORM(m.loexception.LINENO) ;
			+ " Details: "+m.loexception.DETAILS+" - Line Contents: "+m.loexception.LINECONTENTS
		lcbody = "Error 11 - "+lcreturnerror
		EXIT
	ENDTRY


ENDIF


i=0

FOR EACH nrow IN lasheets
	i=i+1
	llshref1 = lasheets[i]
*?llshref1
	lnerror = loini.getinientry(@lccolumns,"ExcelSheets",llshref1+"Columns",lcprogrampath+"\hmrecost.ini")
	IF lnerror = 0 THEN
		nrows = ALINES(lacolumns, STRTRAN(lccolumns,",",CHR(13)))
		llstockcolumn=lacolumns[1]
		llvaluecolumn=lacolumns[2]
	ELSE
		lcsubject = "Error"
		lcbody = "Error"
		WAIT WIND "Error!"
	ENDIF



	lnerror = loini.getinientry(@lcrange,"ExcelSheets",llshref1+"Range",lcprogrampath+"\hmrecost.ini")
	IF lnerror = 0 THEN
		nrows = ALINES(larange, STRTRAN(lcrange,",",CHR(13)))
		llrangestart=larange[1]
		llrangeend=larange[2]
	ELSE
		lcsubject = "Error"
		lcbody = "Error"
		WAIT WIND "Error!"
	ENDIF

* This can contain numbers, characters, special characters, etc.
	m.lcsource = llshref1

* This is what I want returned back to me.  In this case, it's digits only.
	m.lcreturntome = "0123456789"

* The inner CHRTRAN() function removes anything that is a number.  The return value is
* what will be removed in the outer CHRTRAN function.
	m.lcdigitsonly = CHRTRAN(m.lcsource, CHRTRAN(m.lcsource, m.lcreturntome, SPACE(0)), SPACE(0))
*?lcDigitsOnly

	IF llerror=.F.
		lccolstk = llstockcolumn
		lccolval = llvaluecolumn
		WITH oexcel.activeworkbook.sheets(VAL(lcdigitsonly))
			FOR lnloop = VAL(llrangestart) TO VAL(llrangeend) STEP 1
				lnstocks = ALLTRIM(UPPER(.RANGE(lccolstk+ALLTRIM(STR(lnloop))).TEXT))+"/1"
				lnvalues = .RANGE(lccolval+ALLTRIM(STR(lnloop))).VALUE
				STORE ALLTRIM(lnstocks) TO alprices(1,2)
				STORE ALLTRIM(TRANSFORM(lnvalues)) TO alprices(1,1)
				USE nightprice ALIAS prices
				APPEND FROM ARRAY alprices
*!*					?lnstocks
*!*					?lnvalues
			ENDFOR
		ENDWITH
	ENDIF





ENDFOR


*




*/TIDY TABLES*/
USE nightprice EXCLUSIVE ALIAS nightpricestidy
SET FILTER TO lnstock='/1'
DELETE ALL
PACK
SET FILTER TO lnvalue='$'
GO TOP
SCAN
	REPLACE lnvalue WITH SUBSTR(ALLTRIM(lnvalue ),2,LEN(ALLTRIM(lnvalue ))-1)
ENDSCAN
SET FILTER TO
GO TOP
SCAN
	REPLACE lnstock WITH SUBSTR(ALLTRIM(lnstock),1,LEN(ALLTRIM(lnstock))-2)
	REPLACE lnvalue WITH TRANSFORM(ROUND(VAL(lnvalue),2))
ENDSCAN
SET FILTER TO ALLTRIM(lnstock)=="NO!!"
DELETE ALL
PACK
CLOSE DATABASES ALL


lldatapath = ALLTRIM(llcosubdir) + "\" + ALLTRIM(llcompany)
?"Data Path: " +ALLTRIM(lldatapath)
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("Data Path: " +ADDBS(ALLTRIM(lldatapath)),"REPORTEND.TXT",1)


USE nightprice ALIAS alnightprice
llnpreccount = RECCOUNT()
?"Base Stock Record Count to update: " + TRANSFORM(llnpreccount)
STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE("Base Stock Record Count to update: " + TRANSFORM(llnpreccount),"REPORTEND.TXT",1)
DIMENSION danightprices[llnpRecCount,2]
COPY TO ARRAY danightprices
i=0
USE lldatapath + "_cname.dbf" ALIAS component IN 0 ORDER cname1
USE lldatapath + "_cfact.dbf" ALIAS assemblyfact IN 0 ORDER cfact1
SELECT component
SET RELATION TO cn_fact INTO assemblyfact ADDITIVE
FOR EACH nrow IN danightprices
	i=i+1
	IF i > llnpreccount
*?TRANSFORM(i)
		EXIT
	ELSE
*?"====****===="
		cnref = danightprices[i,2]
		cnvalue = danightprices[i,1]
*?"Stock Ref : " +cnref
*?"New Value: " + cnvalue


		SCAN FOR ALLTRIM(cn_ref) == ALLTRIM(cnref)
			REPLACE cn_sell WITH VAL(cnvalue)*10**assemblyfact.cf_selldps
		ENDSCAN
*LOCATE FOR ALLTRIM(cn_ref)=cnref
*brow
	ENDIF

ENDFOR
?TRANSFORM(i-1) + " Records Updated"

STRTOFILE(CHR(13) + CHR(10),"REPORTEND.TXT",1)
STRTOFILE(TRANSFORM(i-1) + " Records Updated","REPORTEND.TXT",1)

CLOSE DATABASES ALL

RETURN
