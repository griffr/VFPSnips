SET EXCLUSIVE ON 
SET SAFETY OFF 
USE D:\data\invjccode.dbf
DELETE ALL
PACK 
APPEND FROM d:\data\sopstojcs.csv TYPE DELIMITED 
COPY TO d:\data\invoices.dbf
COPY TO d:\data\ripoutjc.dbf
CLOSE DATABASES ALL 
USE d:\data\invoices.dbf ALIAS inv
ALTER table inv drop COLUMN job
ALTER table inv drop COLUMN ccode
CLOSE DATABASES all
USE d:\data\ripoutjc.dbf ALIAS ripjc
ALTER table ripjc drop COLUMN invoice
ALTER table ripjc drop COLUMN ccode
CLOSE DATABASES ALL 