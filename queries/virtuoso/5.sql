-- @(#)5.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q5)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	customer,
	orders,
	lineitem,
	supplier,
	nation,
	region
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and l_suppkey = s_suppkey
	and c_nationkey = s_nationkey
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = ':1'
	and o_orderdate >= cast (':2' as date)
	and o_orderdate < dateadd('year', 1, cast (':2' as date))
group by
	n_name
order by
	revenue desc;
:e
