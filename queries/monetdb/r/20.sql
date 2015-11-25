-- @(#)20.sql	2.1.8.1
-- TPC-H/TPC-R Potential Part Promotion Query (Q20)
-- Function Query Definition
-- Approved February 1998
:b
:x
:o
select
	s_name,
	s_address
from
	q20_1
where
	s_suppkey in (
		select
			distinct (ps_suppkey)
		from
			q20_2
		where
			p_name like ':1%'
			and ps_availqty > (
				select
					0.5 * sum(l_quantity)
				from
					lineitem
				where
					l_partkey = ps_partkey
					and l_suppkey = ps_suppkey
					and l_shipdate >= ':2'
					and l_shipdate < date ':2' + interval '1 year'
			)
	)
	and n_name = ':3'
order by
	s_name;
:e
