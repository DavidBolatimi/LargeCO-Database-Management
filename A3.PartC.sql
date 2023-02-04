--Prob 31
SELECT E.EMP_NUM, E.EMP_LNAME, E.EMP_FNAME, S.SAL_FROM, S.SAL_END, S.SAL_AMOUNT
FROM lgemployee E inner JOIN lgsalary_history S
ON E.emp_num = S.emp_num
WHERE E.emp_num IN (83731, 83745,84039)
ORDER BY emp_num Asc, SAL_FROM asc


--Prob 32
SELECT DISTINCT C.cust_fname, C.cust_lname, C.cust_street, C.cust_city, C.cust_state, C.cust_zip
FROM lgcustomer C JOIN lginvoice I ON C.cust_code = I.cust_code
JOIN lgline L ON L.inv_num = I.inv_num
JOIN lgproduct P ON L.prod_sku = P.prod_sku
JOIN lgbrand B ON B.brand_id = P.brand_id
WHERE brand_name = 'FORESTERS BEST'
AND prod_category = 'Top Coat' AND inv_date BETWEEN '15-JULY-2015' AND '31-JULY-2015'
ORDER BY cust_state ASC, cust_lname ASC, cust_fname ASC

--Prob 33
SELECT E.emp_num, E.emp_lname, E.emp_email, E.emp_title, D.dept_name
FROM lgemployee E JOIN lgdepartment D
ON E.dept_num = D.dept_num
WHERE E.emp_title LIKE '%ASSOCIATE'
ORDER BY dept_name, emp_title


--Prob 34
SELECT B.brand_name, COUNT(B.brand_id) 'NUMPRODUCTS'
FROM lgbrand B JOIN lgproduct P
ON B.brand_id = P.brand_id
GROUP BY B.brand_name

--Prob 35 
SELECT prod_category, COUNT(prod_category) 'NUMPRODUCTS'
FROM lgproduct
WHERE prod_base LIKE 'Water'
GROUP BY prod_category

--Prob 36
SELECT prod_base, prod_type, COUNT(prod_base) 'NUMPRODUCTS'
FROM lgproduct
GROUP BY prod_type, prod_base


--Prob 37
SELECT brand_id, SUM(prod_qoh) 'TOTALINVENTORY'
FROM lgproduct
GROUP BY brand_id
ORDER BY brand_id DESC

--Prob 38
SELECT B.brand_id, B.brand_name, ROUND(AVG(prod_price), 2) 'AVGPRICE'
FROM lgbrand B JOIN lgproduct P
ON B.brand_id = P.brand_id
GROUP BY B.brand_id, B.brand_name
ORDER BY brand_name

--Prob 39
SELECT dept_num, MAX(emp_hiredate) 'MOSTRECENT'
FROM lgemployee
GROUP BY dept_num

--Prob 40
SELECT emp_num, emp_fname, emp_lname, MAXWAGE 'LARGESTSALARY'
FROM (
SELECT DISTINCT MAX(sal_amount) 'MAXWAGE', E.emp_num, E.emp_fname, E.emp_lname FROM lgemployee E JOIN lgsalary_history S ON E.emp_num = S.emp_num GROUP BY E.emp_num, emp_fname, emp_lname ) CHI
ORDER BY CHI.MAXWAGE DESC



--Prob 41
SELECT cust_code, cust_fname, cust_lname, SUM(TOTALINVOICE) 'TOTALINVOICES'

 FROM(
 SELECT I.cust_code, cust_fname, cust_lname, SUM(I.inv_total) 'TOTALINVOICE'
 FROM lgcustomer C JOIN lginvoice I
 ON C.cust_code = I.cust_code
--WHERE TOTALINVOICE > 1500 (INVALID IN OUR DATABASE)
GROUP BY I.cust_code, cust_fname, cust_lname, inv_total) DB
--GROUP BY DB.cust_code, DB.cust_fname, DB.cust_lname
ORDER BY DB.TOTALINVOICE DESC


--Prob 42
SELECT D.dept_num, D.dept_name, D.dept_phone, E.emp_num, E.emp_lname
FROM lgdepartment D JOIN lgemployee E
ON D.emp_num = E.emp_num
ORDER BY D.dept_name

--Prob 43
SELECT vend_id, vend_name, brand_name, SUM(NM) 'NUMPRODUCTS'
FROM (
SELECT V.vend_id, V.vend_name, B.brand_name, COUNT(P.prod_qoh) 'NM'
FROM lgvendor V JOIN lgsupplies S
ON V.vend_id = S.vend_id
JOIN lgproduct P ON P.prod_sku =  S.prod_sku
JOIN lgbrand B ON B.brand_id = P.brand_id
GROUP BY  B.brand_name, V.vend_name, V.vend_id, P.prod_qoh) WL
GROUP BY  WL.vend_name, WL.brand_name, WL.vend_id
ORDER BY  WL.vend_name, WL.brand_name

--Prob 44
SELECT emp_num, emp_lname, emp_fname, SUM(TOTALINVOICE) 'TOTALINVOICES'
FROM (
SELECT E.emp_num, E.emp_lname, E.emp_fname, SUM(I.inv_total) 'TOTALINVOICE'
FROM lgemployee E JOIN lginvoice I
ON E.emp_num = I.employee_id
GROUP BY E.emp_num, E.emp_lname, E.emp_fname, I.inv_total) N
GROUP BY N.emp_num, N.emp_lname, N.emp_fname
ORDER BY N.emp_lname, N.emp_fname

--Prob 45
SELECT MAX(ebt.AVGPRICE) 'LARGEST AVERAGE'
FROM
( SELECT B.brand_id, B.brand_name, ROUND(AVG(prod_price), 2) 'AVGPRICE'
FROM lgbrand B JOIN lgproduct P
ON B.brand_id = P.brand_id
GROUP BY B.brand_id, B.brand_name
) ebt