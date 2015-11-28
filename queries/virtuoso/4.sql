-- @(#)4.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q4)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	o_orderpriority,
	count(*) as order_count
from
	orders
where
	o_orderdate >= cast (':1' as date)
	and o_orderdate < dateadd ('month', 3, cast (':1' as date))
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;
:e
