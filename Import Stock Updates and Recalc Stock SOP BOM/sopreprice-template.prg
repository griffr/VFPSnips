CLOSE DATABASES ALL
LOCAL lldoc,llaccount,llstock,llquan,llprice,lldisc,llvatpct,llcfact,lldiscitm,lldiscval,llexvat,lllineval,llvatval

USE IN a "D:\Data\COMP_Q\Q_ihead.DBF" ALIAS ihead
USE IN b "D:\Data\COMP_Q\Q_itran.DBF" ALIAS itran
USE "D:\Data\COMP_Q\Q_cname.dbf" ALIAS component IN 0 ORDER cname1
USE "D:\Data\COMP_Q\Q_cfact.dbf" ALIAS assemblyfact IN 0 ORDER cfact1
SELECT component
SET RELATION TO cn_fact INTO assemblyfact ADDITIVE

SELECT b
SET FILTER TO ALLTRIM(it_numinv)=="" AND ALLTRIM(it_status)="A" AND !EMPTY(ALLTRIM(it_stock)) AND !DELETED() AND ALLTRIM(it_stock) != "POST AND PACKING"
SCAN
	lldoc = ALLTRIM(itran.it_doc)
	llstock = ALLTRIM(itran.it_stock)
	llquan = itran.it_quan
	llprice = itran.it_price
	lldisc = itran.it_disc
	llvatpct = itran.it_vatpct
	SELECT ih_doc, ih_account FROM ihead WHERE ALLTRIM(ih_doc) = ALLTRIM(lldoc) INTO CURSOR curihead
	llaccount = curihead.ih_account


*?
*?LLACCOUNT + "  ::  " + LLDOC + "  ::  " + LLSTOCK

	SELECT * FROM component WHERE ALLTRIM(component.cn_ref) == ALLTRIM(llstock) INTO CURSOR curcomponent
	llprice = curcomponent.cn_sell
	llcfact=assemblyfact.cf_dps
	lldiscitm = (llprice * lldisc)/100
	lldiscval = (lldiscitm * (llquan/10**llcfact))

*?"LLQUAN: " + TRANSFORM(LLQUAN) + "  ::  LLPRICE: " + TRANSFORM(LLPRICE) + "  ::  LLDISC: " + TRANSFORM(LLDISC)
*?"llcfact: " + TRANSFORM(LLCFACT) + "  ::  lldiscitm: " + TRANSFORM(LLDISCITM) + "  ::  lldiscval: " + TRANSFORM(LLDISCVAL)

	llexvat = (llprice - lldiscitm)*(llquan/10**llcfact)

	lllineval = llexvat + ((llexvat/100)*llvatpct)

	llvatval = ((llexvat/100)*llvatpct)
*?"llexvat: " + TRANSFORM(LLEXVAT)
*?"llvatval: " + TRANSFORM(LLVATVAL)
*?"lllineval: " + TRANSFORM(LLLINEVAL)
	SELECT b
	REPLACE it_exvat WITH llexvat
	REPLACE it_price WITH llprice
	REPLACE it_lineval WITH lllineval
	REPLACE it_discval WITH lldiscval
	REPLACE it_vatval WITH llvatval



ENDSCAN
?"FIN - ITRAN REPRICE"

CLOSE DATABASES ALL

USE IN a "D:\Data\COMP_Q\Q_ihead.DBF" ALIAS ihead
USE IN b "D:\Data\COMP_Q\Q_itran.DBF" ALIAS itran

SELECT a
SET FILTER TO ALLTRIM(ih_invoice)=="" AND ALLTRIM(ih_docstat)="O" AND !DELETED()

SCAN
	lldoc = ALLTRIM(ihead.ih_doc)
	SELECT SUM(it_exvat) AS exvat, SUM(it_vatval) AS vat FROM itran WHERE it_status = 'A' AND ALLTRIM(it_doc)=ALLTRIM(lldoc) INTO CURSOR citran
	llexvat = citran.exvat
	llvatval = citran.vat
	IF ISNULL(llexvat)
	?lldoc + " llexvat NULL - Check Transaction Lines Exist"
		llexvat = 0
	ENDIF
	IF ISNULL(llvatval)
	?lldoc + " llvatval NULL - Check Transaction Lines Exist"
		llvatval = 0
	ENDIF
	REPLACE ihead.ih_exvat WITH llexvat
	REPLACE ihead.ih_vat WITH llvatval
ENDSCAN
CLOSE DATABASES ALL 
