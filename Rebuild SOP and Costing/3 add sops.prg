CLOSE DATABASES ALL 
USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\I_ITRAN.DBF"
APPEND FROM C:\DATA\ITRANP.DBF
USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\I_IHEAD.DBF"
APPEND FROM C:\DATA\IHEADP.DBF
CLOSE DATABASES ALL 