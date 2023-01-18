SET EXCLUSIVE ON 

CLOSE DATABASES  ALL 
OPEN DATABASE "C:\temp\wetransfer_c_xadetl-cdx_2023-01-17_1143\comp_c.dbc"
USE xahead 
SET FILTER TO xh_date < DATE(2014,01,01)
BROWSE NOCAPTIONS 
LOCAL lcBatch
SCAN
	lcBatch = xh_batch
	DELETE FROM xadetl WHERE ALLTRIM(xt_batch) == ALLTRIM(lcBatch)
?xh_batch
ENDSCAN 

SELECT  xadetl 
BROWSE NOCAPTIONS 

CLOSE DATABASES all
OPEN DATABASE "C:\temp\wetransfer_c_xadetl-cdx_2023-01-17_1143\comp_c.dbc"
USE xahead 
SET FILTER TO xh_date < DATE(2014,01,01)
DELETE ALL 


CLOSE DATABASES  ALL 