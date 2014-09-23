-- @(#)8.sql	2.1.8.1
-- TPC-H/TPC-R National Market Share Query (Q8)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
	o_year,
	sum(case
		when nation = ':1' then volume
		else 0
	end) / sum(volume) as mkt_share
from
	(
		select
			o_year,
			l_extendedprice * (1 - l_discount) as volume,
			nation
		from
			q8
		where
			and r_name = ':2'
			and p_type = ':3'
	) as all_nations
group by
	o_year
order by
	o_year;
:e
