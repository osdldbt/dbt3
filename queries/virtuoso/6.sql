-- @(#)6.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q6)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= cast (':1' as date)
	and l_shipdate < dateadd ('year', 1, cast (':1' as date))
	and l_discount between :2 - 0.01 and :2 + 0.01
	and l_quantity < :3;
:e
