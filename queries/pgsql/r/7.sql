-- @(#)7.sql	2.1.8.1
-- TPC-H/TPC-R Volume Shipping Query (Q7)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	supp_nation,
	cust_nation,
	l_year,
	sum(volume) as revenue
from
    q7
where
	(
		(supp_nation = ':1' and cust_nation = ':2')
		or (supp_nation = ':2' and cust_nation = ':1')
	)
	and l_shipdate between date '1995-01-01' and date '1996-12-31'
group by
	supp_nation,
	cust_nation,
	l_year
order by
	supp_nation,
	cust_nation,
	l_year;
:e
