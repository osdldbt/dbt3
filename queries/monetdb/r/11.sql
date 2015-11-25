-- @(#)11.sql	2.1.8.1
-- TPC-H/TPC-R Important Stock Identification Query (Q11)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	ps_partkey,
	sum(value)
from
	q11_1
where
    n_name = ':1'
group by
	ps_partkey having
		sum(value) > (
			select
				sum(ps_supplycost * ps_availqty) * :2
			from
				q11_2
			where
				n_name = ':1'
		)
order by
	sum(value) desc;
:e
