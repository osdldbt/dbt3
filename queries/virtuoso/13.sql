-- @(#)13.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q13)
-- Functional Query Definition
-- Approved February 1998
:b
:x
:o
select
          c_count,
          count(*) as custdist
  from (
          select
                  c_custkey,
                  count(o_orderkey) as c_count
          from
                  (select * from customer
                  left outer join orders on
                    c_custkey = o_custkey and
                    o_comment not like '%:1%:2%') c_customer
          group by
                  c_custkey
          ) c_orders
  group by
          c_count
  order by
          custdist desc,
          c_count desc;
:e
