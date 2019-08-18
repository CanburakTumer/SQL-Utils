select * from WORKREP10G.snp_session
where sess_name = ''
and sess_status = 'D'
order by sess_beg desc

select * from WORKREP10G.snp_task_txt
where sess_no = 850290052
order by scen_task_no, nno

select * from WORKREP10G.SNP_SESS_TXT_LOG
where sess_no = 850521052
order by scen_task_no, nno, txt_ord
