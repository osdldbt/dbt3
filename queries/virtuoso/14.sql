-- @(#)14.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q14)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	100.00 * sum(case
		when p_type like 'PROMO%'
			then l_extendedprice * (1 - l_discount)
		else 0
	end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
	lineitem,
	part
where
	l_partkey = p_partkey
	and l_shipdate >= cast (':1' as date)
	and l_shipdate < dateadd ('month', 1, cast (':1' as date));
:e
