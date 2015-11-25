-- @(#)17.sql	2.1.8.1
-- TPC-H/TPC-R Small-Quantity-Order Revenue Query (Q17)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
	q17
where
	p_brand = ':1'
	and p_container = ':2';
:e
