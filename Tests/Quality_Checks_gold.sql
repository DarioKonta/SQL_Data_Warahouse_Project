-- ================================================================================================
-- Crm.cust_info
-- ================================================================================================

SELECT cst_id, COUNT(*) FROM (
	SELECT 
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		cz.BDATE,
		cz.GEN,
		loc.CNTRY
	FROM Silver.crm_cust_info AS ci
	LEFT JOIN	Silver.erp_LOC_A101 AS loc
	ON			ci.cst_key = loc.CID
	LEFT JOIN	Silver.erp_CUST_AZ12 AS cz
	ON			ci.cst_key = cz.CID
	) AS Test
GROUP BY cst_id
HAVING COUNT(*) > 1

-- ================================================================================================
-- Crm.cust_info
-- ================================================================================================

SELECT DISTINCT
ci.cst_gndr,
cz.GEN,
CASE	WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		ELSE COALESCE(cz.GEN, 'N/a')
END AS New_gen
FROM Silver.crm_cust_info AS ci
LEFT JOIN	Silver.erp_LOC_A101 AS loc
ON			ci.cst_key = loc.CID
LEFT JOIN	Silver.erp_CUST_AZ12 AS cz
ON			ci.cst_key = cz.CID
ORDER BY 1, 2

-- ================================================================================================
-- Crm_prd_info
-- ================================================================================================

SELECT prd_key, COUNT(*) FROM ( 
	SELECT 
		pi.prd_id,
		pi.cat_id,
		pi.prd_key,
		pi.prd_nm,
		pi.prd_cost,
		pi.prd_line,
		pi.prd_start_dt,
		pc.CAT,
		pc.SUBCAT,
		pc.MAINTENANCE
	FROM Silver.crm_prd_info AS pi
	LEFT JOIN Silver.erp_PX_CAT_G1V2 AS pc
		ON pi.cat_id = pc.ID
	WHERE prd_end_dt IS NULL -- Shows only active products
) AS Test
GROUP BY prd_key
HAVING COUNT(*) > 1

-- ================================================================================================
-- fact_sales
-- ================================================================================================

SELECT * 
FROM Gold.fact_sales AS f 
LEFT JOIN Gold.dim_customers AS c
	ON f.Customer_key = c.Customer_key
LEFT JOIN GOLD.dim_products AS p
	ON f.Product_key = p.product_key
WHERE c.Customer_key IS NULL
