select
	DD.[Date],
	DD.[DayOfWeek],
	DD.IsWeekday,
	FS.OrderID as [OrderID],
	FS.OrderQuantity as [OrderQuantity],
	FS.BilledAmount as [Billed Amount],
	DC.customer_id as [Customer ID],
	DC.customer_email as [Customer Email],
	DC.customer_firstname + ' ' + DC.customer_lastname as [CustomerName],
	DC.customer_address as [Customer Address],
	DC.customer_city as [Customer City],
	DC.customer_state as [Customer State],
	DC.customer_zip as [Customer Zip],
	DP.product_id as [Product ID],
	DP.product_name as [Product Name]
from FF_FM.FactSales FS
	join FF_FM.DimCustomers DC on FS.CustomerKey = DC.CustomerKey
	join FF_FM.DimDate DD on FS.OrderDateKey = DD.DateKey
	join FF_FM.DimProducts DP on FS.ProductKey = DP.ProductKey
where DP.product_is_active = 1