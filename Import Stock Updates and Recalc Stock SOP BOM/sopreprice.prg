*/*/*/*/* SOP REPRICE */*/*/*/*
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
Strtofile("Source Sheet: "+Alltrim(lcpricesheet),"REPORTEND.TXT",1)

