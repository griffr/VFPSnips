SET EXCLUSIVE OFF
CLOSE DATABASES all
SELECT a
**point to backup cname file
USE "C:\ProgramData\Pegasus\O3 Server VFP\DemoData\z_cname.dbf" ALIAS cname
SET ORDER TO CNAME1   && CN_REF

SELECT b
**point to live cname file
USE "C:\ProgramData\Pegasus\O3 Server VFP\Data\z_dsprod.dbf" ALIAS dsprod
SET RELATION TO dsprod.ds_cnref INTO cname
BROWSE noca
replace ALL ds_cost WITH cname.cn_cost
? "DONE"
**shows live cname after update so can eyeball a memo
BROWSE NOCAPTIONS
CLOSE DATABASES ALL