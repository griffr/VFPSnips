Set Exclusive Off
Close Databases All
Set Safety Off
Local iJD_LINE, iJCLINE_NEXTID, iJWIPR_NEXTID
Local DATAPATH, DATAPATHT
DATAPATH = "D:\DATA\COMP_C\"
DATAPATHT = "D:\DATA\"


Use DATAPATH + 'c_jcline.Dbf' Alias aJCLINE
Go Bottom
iJD_LINE = Round(Val(JD_LINE),0)
=Afields(struct_arr)
Create Cursor c1JCLINE From Array struct_arr
**SELECT * FROM C_JCLINE INTO ARRAY data_arr
Select c1JCLINE
**APPEND FROM ARRAY data_arr
Copy To DATAPATHT + 'MYJCLINE.Dbf'


Use DATAPATH + 'c_jWIPR.Dbf'
=Afields(struct_arr2)
Create Cursor c1JWIPR From Array struct_arr2
**SELECT * FROM C_JCLINE INTO ARRAY data_arr
Select c1JWIPR
**APPEND FROM ARRAY data_arr
Copy To DATAPATHT + 'MYJWIPR.Dbf'

Close Databases All

*!*	Dimension TARRAY[9,1]
*!*	TARRAY[1,1]="I41744"
*!*	TARRAY[2,1]="I41747"
*!*	TARRAY[3,1]="I41871"
*!*	TARRAY[4,1]="I41870"
*!*	TARRAY[5,1]="I41869"
*!*	TARRAY[6,1]="I41982"
*!*	TARRAY[7,1]="I41980"
*!*	TARRAY[8,1]="I41976"
*!*	TARRAY[9,1]="I41974"
USE D:\DATA\INVOICES.DBF ALIAS INPUT_ALIAS
DIMENSION TARRAY[9,3]
COPY TO ARRAY TARRAY

For Each INVOICE In TARRAY

	iJD_LINE = iJD_LINE+10
	Use DATAPATH + 'c_NEXTID.Dbf' Alias aNEXTID
	Scan For Alltrim(TABLENAME)="JCLINE"
		iJCLINE_NEXTID = NEXTID +1
		Replace NEXTID With iJCLINE_NEXTID
	Endscan
	Scan For Alltrim(TABLENAME)="JWIPR"
		iJWIPR_NEXTID = NEXTID +1
		Replace NEXTID With iJWIPR_NEXTID
	Endscan

	Use DATAPATH + 'c_itran.Dbf' Alias aitran
	Select "RCM" As JD_CSTDOC, "" As JD_PHASE,;
		ALLTRIM(Transform(iJD_LINE)) As JD_LINE, "LABOUR(REVENUE)" As JD_CCODE,;
		1 As JD_RATE, "" As JD_PROFILE, "" As JD_STREF, "LABOUR - REVENUE" As JD_DESC,;
		0 As JD_PROFQTY, IT_QUAN*-1 As Jd_QTY, 0 As JD_QTYBG, 0 As JD_QTYRV,;
		IT_PRICE/100 As JD_CSTUNIT, 0.0000 As JD_CSTBG, 0.0000 As JD_CSTRV,;
		ROUND((IT_PRICE/100)*-1,2) As JD_VALUE, 0.00 As JD_VALBG,;
		0.00 As VALRV, "T" As JD_WIPR, IT_DATE As SQ_CRDATE, "12:00:00" As SQ_CRTIME,;
		"JESS" As SQ_AMUSER, "12:00:00" As SQ_AMTIME, 0.00 As JD_COMITVAL, iJCLINE_NEXTID As Id;
		FROM aitran Where it_numinv = INVOICE  And IT_STATUS = "A" Into Cursor cITRAN

	Select cITRAN

	Copy To DATAPATHT + 'ROWITRAN.Dbf'
	Use DATAPATHT + 'MYJCLINE.Dbf'
	Append From DATAPATHT + 'ROWITRAN.Dbf'

	Use DATAPATH + 'c_jWIPR.Dbf'
	=Afields(struct_arr2)
	Create Cursor cJWIPR From Array struct_arr2
**SELECT * FROM C_JCLINE INTO ARRAY data_arr
	Select cJWIPR
**APPEND FROM ARRAY data_arr

*	Use D:\Data\comp_c\c_itran.Dbf Alias aitran
	Select "RCM" As jw_cstdoc, "" As jw_phase, Alltrim(Transform(iJD_LINE)) As jw_line, "LABOUR(REVENUE)" As jw_ccode,;
		"" As jw_profile, 1 As jw_rate, "115" As jw_scode, "" As jw_pcode, "" As jw_batch, 12 As jw_csttype,;
		IT_DESC As jw_desc, 5 As jw_trtype, IT_DATE As jw_trdate, it_numinv As jw_trref, "DC TOOL REPAIR" As jw_comment,;
		IT_QUAN*-1 As jw_qty, IT_PRICE/100 As jw_cstunit, Round((IT_PRICE/100)*-1,2) As jw_value, 0.00 As jw_ohead,;
		2015 As jw_year, 2 As jw_period, "" As jw_wgrup, 0 As jw_wgper, "" As jw_wgemp, "" As jw_wgpay,;
		"" As jw_placc, "" As jw_stref, "" As jw_stwh, "" As jw_subcnt, "" As jw_reqdoc, it_numinv As jw_invdoc,;
		"" As jw_docdoc, "" As jw_podoc, "" As jw_match, "F" As jw_confirm, "F" As jw_alloc, "F" As jw_trf2wg,;
		IT_DATE As SQ_CRDATE, "12:00:00" As SQ_CRTIME, "JESS" As sq_cruser, "" As sq_amdate, "" As SQ_AMTIME, "" As SQ_AMUSER,;
		0 As jw_dcline, "F" As jw_frbom, "" As jw_wodoc, "" As jw_ptax, "" As jw_ytax,;
		iJWIPR_NEXTID As Id, iJCLINE_NEXTID As jw_jclinid;
		FROM aitran Where it_numinv = INVOICE  And IT_STATUS = "A" Into Cursor cITRAN2

	Select cITRAN2
	Copy To DATAPATHT + 'ROWITRAN2.Dbf'
	Use DATAPATHT + 'MYJWIPR.Dbf'
	Append From DATAPATHT + 'ROWITRAN2.Dbf'

	Close Databases All

	Use DATAPATH + 'c_itran.dbf'
	Scan For it_numinv = INVOICE
		Replace it_jcstdoc With "RCM"
		Replace it_jccode With "LABOUR(REVENUE)"
		Replace it_jline With Alltrim(Transform(iJD_LINE))
	Endscan


Endfor

Local costincrease
costincrease = 0
*FOR EACH invoice IN tarray
Use DATAPATHT + 'MYJWIPR.Dbf'
Scan
	costincrease = costincrease + jw_value
*!*		Wait Window costincrease
Endscan
*ENDFOR

Close Databases All

*.*