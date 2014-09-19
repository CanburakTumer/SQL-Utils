-------------------------- CROSS MINUS TEST SCRIPT ------------------------
-- author :  Canburak Tümer
-- version : 20140920
-------------------------------------------------------------------------
declare
sql1 varchar2(4000);
sql2 varchar2(4000);
diff1 number;
diff2 number;
BEGIN

sql1 := 'QUERY1';
sql2 := 'QUERY2';

execute immediate 'select count(1) from ('||sql1||'  minus  '||sql2||')' into diff1 ;
execute immediate 'select count(1) from ('||sql2||'  minus  '||sql1||')' into diff2 ;

dbms_output.put_line('diff1 = '|| diff1 || ' - diff2 = '|| diff2);

END;