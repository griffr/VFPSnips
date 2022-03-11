SET EXCLUSIVE OFF
CLOSE DATABASES all
SELECT a
**point to backup cname file
USE "C:\ProgramData\Pegasus\O3 Server VFP\DemoData\z_cname.dbf" ALIAS backup

SET ORDER TO CNAME1   && CN_REF
SELECT b
**point to live cname file
USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\z_cname.dbf" ALIAS current
SET RELATION TO current.cn_ref INTO backup

replace ALL cn_exten WITH backup.cn_exten
? "DONE"
**shows live cname after update so can eyeball a memo
BROWSE NOCAPTIONS
CLOSE DATABASES ALL