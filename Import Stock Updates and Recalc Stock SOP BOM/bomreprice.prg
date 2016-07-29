*/BOM REPRICE
Lparameters llcompany
?
? '3 - BOM Start - ' + Time()
?
Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
Strtofile("3 - BOM Start - " + Time(),"REPORTEND.TXT",1)


Local llstockref,llnewsell,LLFACTVAL

Local lcseqcopath, llcosbudir,lcpricesheet,lldatapath,lllookupco
Local lcvalue, loini, lnerror,llerror,lnmain,lnstocks,lnvalues,llnpreccount
loini = Newobject("oldinireg",Home() + "ffc\registry.vcx")
?"Company: "+Alltrim(llcompany)
Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
Strtofile("Company: "+Alltrim(llcompany),"REPORTEND.TXT",1)
lnerror = loini.getinientry(@lcseqcopath,"Preferences","SEQCOPATH",lcprogrampath+"\hmrecost.ini")
?"SEQCO Path: " +Alltrim(lcseqcopath)
Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
Strtofile("SEQCO Path: " +Alltrim(lcseqcopath),"REPORTEND.TXT",1)
Use In a lcseqcopath + "\seqco"
Locate For a.co_code = llcompany
llcosubdir = a.co_subdir
?"CO Subdir: " + Alltrim(llcosubdir)
Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
Strtofile("CO Subdir: " + Alltrim(llcosubdir),"REPORTEND.TXT",1)
Close Databases All
lldatapath = Alltrim(llcosubdir) + "\" + Alltrim(llcompany)
?"Data Path: " +Addbs(Alltrim(lldatapath))
Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
Strtofile("Source Sheet: "+Alltrim(lldatapath),"REPORTEND.TXT",1)


Use In a lldatapath + "_cname.dbf" Alias stockSTART Order CNAME1


Select a



Set Filter To CN_ASSMFLG=.T.

Scan
	llstockref=cn_ref
*	?llstockref

	Use In c lldatapath + "_cfact.dbf" Alias CFACTOR
	LLFACTVAL=CFACTOR.CF_DPS
*	?Transform(LLFACTVAL)
	Use In b lldatapath + "_cSTRUC.dbf" Alias assembley
	Select Sum(((cv_coquant/10**LLFACTVAL)*cn_sell)) As Total From assembley;
		inner Join stockSTART On assembley.cv_compone=stockSTART.cn_ref;
		WHERE assembley.cv_assembl=llstockref Into Cursor cur02
	llnewsell=cur02.Total

	If Isnull(llnewsell)
		Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
		Strtofile("NULL ITEM FOUND: " +llstockref,"REPORTEND.TXT",1)
*!*	?"NULL ITEM FOUND: " +llstockref
	Else
*/*/*/*/*/*    FIX DPS VALUES FOR STOCK *100 */*/*/*/
*?stockstart.cn_sell
*?llnewsell
		Replace stockSTART.cn_sell With llnewsell
	Endif

Endscan

Close Databases All
Return