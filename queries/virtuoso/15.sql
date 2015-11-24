-- @(#)15.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q15)
-- Functional Query Definition
-- Approved February 1998
:b
create view revenue:s (supplier_no, total_revenue) as
	select
		l_suppkey,
		sum(l_extendedprice * (1 - l_discount))
	from
		lineitem
	where
		l_shipdate >= cast (':1' as date)
		and l_shipdate < dateadd ('month', 3, cast (':1' as date))
	group by
		l_suppkey;

:x
:o
select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue:s
where
	s_suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue:s
	)
order by
	s_suppkey;

drop view revenue:s;
:e
