-- @(#)9.sql	2.1.8.1
-- TPC-H/TPC-R Product Type Profit Measure Query (Q9)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	nation,
	o_year,
	sum(l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity) as sum_profit
from
	q9
where
	p_name like '%:1%'
group by
	nation,
	o_year
order by
	nation,
	o_year desc;
:e
