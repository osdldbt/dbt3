-- @(#)12.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q12)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT'
			or o_orderpriority = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT'
			and o_orderpriority <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	orders,
	lineitem
where
	o_orderkey = l_orderkey
	and l_shipmode in (':1', ':2')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= cast (':3' as date)
	and l_receiptdate < dateadd ('year', 1, cast (':3' as date))
group by
	l_shipmode
order by
	l_shipmode;
:e
