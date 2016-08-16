	LPARAMETERS llServer, lcDetails, llSuccess, lcExtra, lcTask
	IF PCOUNT()=4
		lcTask = ""
	ENDIF
		IF FILE("C:\ProgramData\Pegasus\O3 Server VFP\OperaWorker.log")
		   gnErrFile = FOPEN("C:\ProgramData\Pegasus\O3 Server VFP\OperaWorker.log",12)
		ELSE
		   gnErrFile = FCREATE("C:\ProgramData\Pegasus\O3 Server VFP\OperaWorker.log")
		ENDIF
	IF gnErrFile < 0
	ELSE
		=FSEEK(gnErrFile,0,2)
	    =FPUTS(gnErrFile, TTOC(DATETIME())+"  "+IIF(llSuccess,"Successful","Fail")+" - "+lcDetails+IIF(!EMPTY(lcExtra)," ("+lcExtra+")",""))
	ENDIF
	=FCLOSE(gnErrFile)
	RETURN