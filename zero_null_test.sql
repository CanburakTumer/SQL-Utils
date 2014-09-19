-------------------------- ZERO NULL TEST SCRIPT ------------------------
-- author :  Canburak Tümer
-- version : 20130515
-------------------------------------------------------------------------
DECLARE
v_owner varchar2(100);
v_table_name varchar2(100);
v_count number(15);
v_dyntask varchar2(1000);
v_error_message varchar2(100);
v_context varchar2(3); 
v_test_for varchar2(4); -- NULL, ZERO, BOTH
v_log_owner varchar2(100);
v_log_table varchar2(100);

CURSOR cur_cols IS SELECT column_name, data_type FROM dba_tab_columns WHERE owner = v_owner AND table_name = v_table_name ORDER BY column_id; 

BEGIN
    ---------------------------------HOW TO USE------------------------------------------------------------
    -- Initial variables please replace with appropriate values
    -- v_owner : should include schema name
    -- v_table_name : should include table name
    -- v_test_for : can take three values ZERO, NULL or BOTH. States what you are testing the table for.
    -- v_context : states where you are testing the table can be PRD or any other 3 letter value.
    --              decides if results are going to be written on DBMS Output or into a log table.
    --              if values is PRD then it writes into a log table. 
    -- v_log_owner : log table's schema
    -- v_log_table : log table's name
    --      metadata for log table (table_name varhcar2(100), error_message varchar2(100), time_stamp date) 
    --------------------------------------------------------------------------------------------------------
    v_owner := 'OWNER';
    v_table_name := 'TABLE';
    v_test_for := 'NULL';
    v_context := 'STB';
    v_log_owner := 'LOG_SCHEMA';
    v_log_table := 'LOG_TABLE';
    
    --------------------------------------------
    -- DO NOT CHANGE BETWEEN THESE TWO COMMENTS
    --------------------------------------------
    FOR rec IN cur_cols
    LOOP
        -- NULL CHECK FOR EVERY COLUMN
        IF v_test_for <> 'ZERO'
        THEN
            v_dyntask := 'SELECT count('||rec.column_name||') FROM '||v_owner||'.'||v_table_name||' WHERE '||rec.column_name||' IS NOT NULL';
            execute immediate v_dyntask into v_count;
            IF v_count = 0 
            THEN 
                v_error_message := 'All values are NULL in '||rec.column_name;
                IF v_context <> 'PRD'
                THEN dbms_output.put_line(v_error_message);
                ELSE
                v_dyntask := 'INSERT INTO '||v_log_owner||'.'||v_log_table ||' VALUES('''||v_owner||'.'||v_table_name||''','''||v_error_message||''',sysdate)';
                execute immediate v_dyntask;
                commit;
                END IF;
            END IF;
        END IF;
        
        -- ZERO CHECK FOR COLUMNS WITH NUMBER DATA TYPE
        IF v_test_for <> 'NULL'
        THEN
            IF rec.data_type = 'NUMBER'
            THEN
                v_dyntask := 'SELECT count('||rec.column_name||') FROM '||v_owner||'.'||v_table_name||' WHERE '||rec.column_name||' <> 0';
                execute immediate v_dyntask into v_count;
                IF v_count = 0 
                THEN 
                    v_error_message := 'All values are ZERO in '||rec.column_name;
                    IF v_context <> 'PRD'
                    THEN dbms_output.put_line(v_error_message);
                    ELSE
                    v_dyntask := 'INSERT INTO '||v_log_owner||'.'||v_log_table ||' VALUES('''||v_owner||'.'||v_table_name||''','''||v_error_message||''',sysdate)';
                    execute immediate v_dyntask;
                    commit;
                    END IF;
                END IF;
            ELSE NULL;
            END IF;
        END IF;
        
    END LOOP;
    --------------------------------------------
    -- DO NOT CHANGE BETWEEN THESE TWO COMMENTS
    --------------------------------------------
END;
