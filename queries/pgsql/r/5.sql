-- @(#)5.sql	2.1.8.1
-- TPC-H/TPC-R Local Supplier Volume Query (Q5)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	q5
where
	r_name = ':1'
	and o_orderdate >= date ':2'
	and o_orderdate < date ':2' + interval '1 year'
group by
	n_name
order by
	revenue desc;
:e
