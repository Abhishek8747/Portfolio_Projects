--sales_orders = ord
--sales_customers = cus
--sales_order_items = ite
--production_products = pro
--Production_categories cat
--sales_staffs = sta
--sales_stores = sto

select 
ord.order_id,
concat(cus.first_name,' ',cus.last_name)as Customers_Name,
cus.city,
cus.state,
ord.order_date,
sum(ite.quantity) as Total_units, 
round(sum(ite.quantity*ite.list_price),2) as revenue, 
cat.category_name,
pro.product_name, 
sto.store_name,
concat(sta.first_name, ' ', sta.last_name) as sales_rep
from [Portfolio Bikes&Bicycles].dbo.sales#orders$ ord
join [Portfolio Bikes&Bicycles].dbo.sales#customers$ cus
on ord.order_id = cus.customer_id
join [Portfolio Bikes&Bicycles].dbo.sales#order_items$ ite
on ord.order_id = ite.order_id
join [Portfolio Bikes&Bicycles].dbo.production#products$ pro
on ite.product_id = pro.brand_id
join [Portfolio Bikes&Bicycles].dbo.Production#categories$ cat
on pro.category_id = cat.category_id
join [Portfolio Bikes&Bicycles].dbo.sales#stores$ sto
on ord.store_id = sto.store_id
join [Portfolio Bikes&Bicycles].dbo.sales#staffs$ sta
on ord.staff_id = sta.staff_id
group by 
ord.order_id,
ord.order_date,
concat(cus.first_name,' ',cus.last_name),
cus.city,
cus.state,
cat.category_name,
pro.product_name,
concat(sta.first_name, ' ', sta.last_name),
sto.store_name