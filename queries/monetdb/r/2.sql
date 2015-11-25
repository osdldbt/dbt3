-- @(#)2.sql	2.1.8.2
-- TPC-H/TPC-R Minimum Cost Supplier Query (Q2)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select s_acctbal,
       s_name,
       n_name,
       p_partkey,
       p_mfgr,
       s_address,
       s_phone,
       s_comment
from q2_1 a, q2_2 b
where p_partkey = ps_partkey
  and s_suppkey = ps_suppkey
  and p_size = :1
  and reverse(p_type) like reverse('%:2')
  and s_nationkey = n_nationkey
  and n_regionkey = r_regionkey
  and a.r_name = ':3'
  and b.r_name = ':3'
  and a.ps_supplycost = b.ps_supplycost
order by s_acctbal desc, n_name, s_name, p_partkey
:n 100;
:e
