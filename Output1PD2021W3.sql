--Written in Snowflake
--Temporary view for unpivoted table
WITH TablePivot AS (
                    SELECT *
                    -- Union in sub-query to alias
                    FROM    (SELECT *
                                    ,'York' AS store
                            FROM PD2021_WK03_YORK 
                            UNION 
                            SELECT *
                                    ,'Leeds' AS store
                            FROM PD2021_WK03_LEEDS 
                            UNION 
                            SELECT *
                                    ,'London' AS store
                            FROM PD2021_WK03_LONDON
                            UNION
                            SELECT *
                                    ,'Birmingham' AS store
                            FROM PD2021_WK03_BIRMINGHAM
                            UNION
                            SELECT *
                                    ,'Manchester' AS store
                            FROM PD2021_WK03_MANCHESTER
                            ) AS w32021
                    UNPIVOT(sales FOR age_product IN ("New_-_Saddles", "New_-_Mudguards","New_-_Wheels","New_-_Bags","Existing_-_Saddles","Existing_-_Mudguards","Existing_-_Wheels","Existing_-_Bags") )
                    )

--Pre-Grouped Table
, TableSplitWithQuarter AS     (
                    SELECT QUARTER(p."Date") AS QUARTER
                            ,p.store
                            ,SPLIT_PART(p.age_product,'_-_',1) AS customer_type
                            ,SPLIT_PART(p.age_product,'_-_',2) AS product
                            ,p.sales AS products_sold
                            FROM TablePivot as p
                    )
--Grouping Step
SELECT  t.product
        ,t.quarter
        ,sum(t.products_sold) AS products_sold

FROM TableSplitWithQuarter as t

GROUP BY t.product, t.quarter
;
