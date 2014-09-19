-------------------------- COLUMN LENGTH TEST SCRIPT ------------------------
-- author :  Canburak Tümer
-- version : 20140920
-------------------------------------------------------------------------
DECLARE
v_query varchar2(4000);
v_target_schema varchar2(30);
v_target_table varchar2(30);
v_data_col_name varchar2(30);
v_data_len number;
v_target_len number;
v_is_there number;
v_dynamic varchar2(4000);
v_loop_start number;
v_loop_threshold number;
BEGIN
-- QUERY TO CHECK
v_query := 'QUERY1';
v_target_schema := 'SCHEMA';
v_target_table := 'TABLE';

-- LOOP INTERVAL
v_dynamic := 'select count(1) from all_tab_columns where table_name = ''LENGTH_TEST'' and owner = ''SCHEMA'' ';
--dbms_output.put_line(v_dynamic);
execute immediate v_dynamic into v_loop_threshold;
v_loop_start := 1;

-- TEMP TABLE EXISTENCE CHECK AND CREATION
v_dynamic := 'select count(1) from dba_tables where table_name = ''LENGTH_TEST'' and owner = ''SCHEMA'' ';
--dbms_output.put_line(v_dynamic);
execute immediate v_dynamic into v_is_there;
case when v_is_there <> 0 then
    execute immediate 'drop table SCHEMA.LENGTH_TEST';
else
    execute immediate 'select * from dual';
end case;
execute immediate 'create table SCHEMA.LENGTH_TEST as '||v_query;

-- CHECKING EVERY COLUMN WITH QUERY RESULT DEPENDING ON COLUMN_ID AND QUERY ORDER
for counter in v_loop_start..v_loop_threshold
loop
    -- get column_name to test
    v_dynamic := 'select column_name from all_tab_columns where table_name = ''LENGTH_TEST'' and owner = ''SCHEMA'' and column_id = '||counter;
    --dbms_output.put_line(v_dynamic);
    execute immediate v_dynamic into v_data_col_name;
    
    --get max data length for column
    v_dynamic := 'select max(length('||v_data_col_name||')) from SCHEMA.LENGTH_TEST';
    --dbms_output.put_line(v_dynamic);
    execute immediate v_dynamic into v_data_len;
    
    -- get length of target column
    v_dynamic := 'select case when data_type = ''NUMBER'' then data_precision else data_length end as targ_len from all_tab_columns where owner = '''|| v_target_schema ||''' and table_name = '''|| v_target_table ||'''  and column_id = '||counter;
    --dbms_output.put_line(v_dynamic);
    execute immediate v_dynamic into v_target_len;
    
    -- compare and write result
    case when v_target_len < v_data_len
        then dbms_output.put_line(v_data_col_name ||' is too long for target table');
    else dbms_output.put_line(v_data_col_name ||' is OK'); end case;
    
end loop;

END;