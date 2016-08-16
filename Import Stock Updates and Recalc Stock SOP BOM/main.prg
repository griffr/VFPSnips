Set Multilocks On
Set Exclusive Off
Set Date british
Set Century On
SET SAFETY OFF 

Local i
Local llcompany
Local lcsubject,lcbody,lcusername,lcpassword,lcsendto
Local lcvalue, loini, lnerror

lcsys16 = Sys(16, 1)
lcprogram = Substr(lcsys16, At(":", lcsys16) - 1)
lcprogrampath = Substr(lcprogram,1,Rat('\',lcprogram,1)-1)

Close Databases All
?
?
?"************************"
? '1 - Start - ' + Time()
?
Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT")
Strtofile("1 - Start - " + Time(),"REPORTEND.TXT",1)

If "WINPRO8101"$Sys(0)
	Cd Justpath(_vfp.ActiveProject.Name)
Else
Endif


*/LOCAL VARIABLES*/




Use nightprice Exclusive
Delete All
Pack

*/GET CO FROM INI*/

loini = Newobject("oldinireg",Home() + "ffc\registry.vcx")
lnerror = loini.getinientry(@lcvalue,"Preferences","SYSCOS",lcprogrampath+"\hmrecost.ini")
If lnerror = 0 Then
	nrows = Alines(lacompanies, Strtran(lcvalue,",",Chr(13)))
	lcsubject = "STARTED" + Time()
lcbody = "HMRECOST BEGINS"
Else
	lcsubject = "Error"
	lcbody = "Error"
	Wait Wind "Error!"
Endif


Do sendemail With lcusername, lcpassword, lcsendto, lcsubject, lcbody, loini, lnerror
*/WRITE A VALUE TO THE INI
*!*	loINI.WriteINIEntry("VariableValue","Section","VariableName",LCPROGRAMPATH+"\hmrecost.ini")
*!*	if lnError = 0 then
*!*	  wait wind "Value set successfully!"
*!*	else
*!*	  wait wind "Error writing value!"
*!*	ENDIF

i=0
For Each nrow In lacompanies
	i=i+1
	llcompany = lacompanies[i]
	Do updatestock With llcompany
	Do bomreprice With llcompany
Endfor
?
?"Recost Finished: " + Time()
?
lcsubject = "Passed" + Time()
lcbody = "Companies Processed : " +lcvalue

Strtofile(Chr(13) + Chr(10),"REPORTEND.TXT",1)
Strtofile("Recost Finished: " + Time(),"REPORTEND.TXT",1)

Do sendemail With lcusername, lcpassword, lcsendto, lcsubject, lcbody, loini, lnerror

*/SENDMAIL*/
Procedure sendemail
Lparameters lcusername, lcpassword, lcsendto, lcsubject, lcbody, loini, lnerror
lnerror = loini.getinientry(@lcusername,"EMAIL","USERNAME",lcprogrampath+"\hmrecost.ini")
lnerror = loini.getinientry(@lcpassword,"EMAIL","PASSWORD",lcprogrampath+"\hmrecost.ini")
lnerror = loini.getinientry(@lcsendto,"EMAIL","SENDTO",lcprogrampath+"\hmrecost.ini")

lomailman = Createobject('Chilkat_9_5_0.MailMan')
lnsuccess = lomailman.unlockcomponent("CKCACOMAILQ_UaVyPDMD2C2A")
lomailman.smtphost = "smtp.office365.com"
lomailman.starttls = 1
lomailman.smtpport = 25

lomailman.smtpusername = lcusername
lomailman.smtppassword = lcpassword

loemail = Createobject('Chilkat_9_5_0.Email')
loemail.From = lcusername
loemail.subject = lcsubject
loemail.body = lcbody
loemail.AddFileAttachment("REPORTEND.TXT")


loemail.AddTo("",lcsendto)
lnsuccess = lomailman.sendemail(loemail)
lomailman.closesmtpconnection()
If (lnsuccess <> 1) Then
	? "Connection to SMTP server not closed cleanly."
Else
	? "SMTP Completed."
Endif

loemail = Null
lomailman = Null
Endproc
Close Databases All

oExcel.Workbooks.Close