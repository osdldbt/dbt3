-- @(#)10.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q10)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
    :n 20
	c_custkey,
	c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal,
	n_name,
	c_address,
	c_phone,
	c_comment
from
	customer,
	orders,
	lineitem,
	nation
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= cast (':1' as date)
	and o_orderdate < dateadd ('month', 3, cast (':1' as date))
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey,
	c_name,
	c_acctbal,
	c_phone,
	n_name,
	c_address,
	c_comment
order by
	revenue desc;
:e
