CLOSE DATABASES ALL 
LOCAL lldoc,llaccount,llstock 

USE IN a "D:\Data\COMP_H\H_ihead.DBF" ALIAS ihead
SET FILTER TO ih_docstat='O' AND ALLTRIM(ih_invoice) == ""
BROWSE NOCAPTIONS 
SCAN
	lldoc = ihead.ih_doc
	llaccount = ihead.ih_account
	?lldoc + " :: " + llaccount
	USE IN b "D:\Data\COMP_H\H_itran.DBF" ALIAS itran
	SELECT b 
	SET FILTER TO ALLTRIM(it_doc) = ALLTRIM(lldoc) AND ALLTRIM(it_status)="A"
	
	
	
ENDSCAN 

