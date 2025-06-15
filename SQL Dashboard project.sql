create database project;
use project;
# Kpi-1 No of invoice by Accnt Executive

CREATE TABLE KPI_1 ;
CREATE TABLE KPI_1 (
    invoice_number BIGINT,
    invoice_date DATE,
    revenue_transaction_type VARCHAR(50),
    branch_name VARCHAR(100),
    solution_group VARCHAR(100),
    account_exe_id INT,
    Account_Executive VARCHAR(100),
    income_class VARCHAR(10),
    client_name VARCHAR(255),
    policy_number VARCHAR(100),
    amount DECIMAL(20, 2),
    income_due_date DATE
);


SELECT 
    Account Executive,
    COUNT(*) AS `Cross Sell`
FROM 
    KPI_1
WHERE 
    TRIM(income_class) = 'Cross Sell'
GROUP BY 
    Account_Executive
ORDER BY 
    Account_Executive;


SELECT 
    Account Executive,
    COALESCE(NULLIF(TRIM(income_class), ''), 'Unknown') AS income_class
FROM 
    KPI_1;

SELECT 
    Account Executive,
    COUNT(*) AS valid_rows
FROM 
    KPI_1
WHERE 
    income_class IS NOT NULL AND TRIM(income_class) != ''
GROUP BY 
    Account_Executive;

SELECT 
    AccountExecutive,
    sum(CASE WHEN TRIM(LOWER(income_class)) = 'new' THEN 1 ELSE 0 END) AS `New`,
    SUM(CASE WHEN TRIM(LOWER(income_class)) = 'renewal' THEN 1 ELSE 0 END) AS `Renewal`,
    SUM(CASE WHEN TRIM(LOWER(income_class)) = 'cross sell' THEN 1 ELSE 0 END) AS `Cross Sell`,
    SUM(CASE WHEN TRIM(income_class) = '' OR income_class IS NULL THEN 1 ELSE 0 END) AS `Blank`,
    COUNT(*) AS `Grand Total`
FROM 
    invoicecsv
GROUP BY 
    AccountExecutive
    
UNION ALL 
SELECT 
    'Grand Total' AS AccountExecutive,
    SUM(CASE WHEN TRIM(LOWER(income_class)) = 'new' THEN 1 ELSE 0 END) AS `New`,
    SUM(CASE WHEN TRIM(LOWER(income_class)) = 'renewal' THEN 1 ELSE 0 END) AS `Renewal`,
    SUM(CASE WHEN TRIM(LOWER(income_class)) = 'cross sell' THEN 1 ELSE 0 END) AS `Cross Sell`,
    SUM(CASE WHEN TRIM(income_class) = '' OR income_class IS NULL THEN 1 ELSE 0 END) AS `Blank`,
    COUNT(*) AS `Grand Total`
FROM 
    invoicecsv;
/* Kpi-2 Yearly Meeting Count*/
select count(meeting_date) as "2019", (select count(meeting_date) from meeting
where right(meeting_date,4)="2020") as "2020" from meeting where right (meeting_date,4)="2019";

# Kpi-3
/* Cross Sell */
select concat(format((sum(amount) + (select sum(amount) from fees where income_class ='Cross sell'))/1000000,2),'m') as CAchieved,
concat(format((select sum(amount) from invoice where income_class='Cross Sell')/1000000,2),'m') as CInvoice, 
concat(format((select sum(cross_sell_bugdet) from individual_budgets)/1000000,2),'m') 
as CTarget from brokerage where income_class='Cross sell';

/* New Sell*/
select concat(format((sum(amount) + (select sum(amount) from fees where income_class ='New'))/1000000,2),'m') as NAchieved,
concat(format((select sum(amount) from invoice where income_class='New')/1000000,2),'m') as NInvoice,
concat(format((select sum(New_budget) from individual_budgets)/1000000,2),'m') 
as NTarget from brokerage where income_class='New'; 

/*Renewal*/
select concat(format((sum(amount) + (select sum(amount) from fees where income_class ='Renewal'))/1000000,2),'m') as RAchieved,
concat(format((select sum(amount) from invoice where income_class='Renewal')/1000000,2),'m') as RInvoice,
concat(format((select sum(Renewal_budget) from individual_budgets)/1000000,2),'m') 
as RTarget from brokerage where income_class='Renewal';

/* Kpi-4 stage funnel by Revenue*/
select * from oppur;
select distinct stage,sum(`revenue_amount`) as  Total_revenue from opportunity 
group by stage
order by Total_Revenue desc;

/* Kpi-5 No. of meeting by account executive*/
select account_executive, count(meeting_date) as meeting from meeting group by account_executive;

select account_executive, count(invoice_number) as invoice, income_class from invoice 
group by account_executive, income_class order by invoice desc;

# Kpi-6
/*Total Opportunity Count*/
select count(opportunity_name) as total_opportunites from opportunity;


/* Total Open Opportunity Count*/
select count(opportunity_name) as total_open_opportunities from opportunity where stage in ("Qualify Opportunity","Propose Solution");

/* Opportunity by Revenue Top 4*/
select opportunity_name, sum(revenue_amount) as revenue from opportunity
group by opportunity_name order by revenue desc limit 4;

/*Open Opportunity Top-4*/
select opportunity_name, sum(revenue_amount) as revenue from opportunity
where stage in("Qualify Opportunity","Propose Solution")
group by opportunity_name order by revenue desc limit 4;

/* Opportunity Product Distribution*/
select product_group, count(product_group) as product from opportunity
group by product_group order by product desc; 


 

 


/* Kpi-4 stage funnel by Revenue*/
select * from oppur;
select distinct stage,sum(`revenue_amount`) as  Total_revenue from opportunity 
group by stage
order by Total_Revenue desc;

