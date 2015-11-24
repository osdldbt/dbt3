-- @(#)20.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q20)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select 
	s_name,
	s_address
from
	supplier,
	nation
where
	s_suppkey in (
		select
			ps_suppkey
		from
			partsupp
		where
			ps_partkey in (
				select
					p_partkey
				from
					part
				where
					p_name like ':1%'
			)
			and ps_availqty > (
				select
					0.5 * sum(l_quantity)
				from
					lineitem
				where
					l_partkey = ps_partkey
					and l_suppkey = ps_suppkey
					and l_shipdate >= cast (':2' as date)
					and l_shipdate < dateadd ('year', 1, cast (':2' as date))
			)
	)
	and s_nationkey = n_nationkey
	and n_name = ':3'
order by
	s_name;
:e
