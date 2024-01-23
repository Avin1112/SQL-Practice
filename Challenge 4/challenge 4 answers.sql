create database challenge ;

use challenge ;

-- 1. What are the names of all the customers who live in New York?

select concat(firstname," ",lastname) as "Customer name" from customers where state = 'ny' ;
          
--  What is the total number of accounts in the Accounts table?

select count(distinct(accounttype)) "Unique type of accounts in the Accounts table" from accounts ;

select count(accountid) as "total number of accounts in the Accounts table" from accounts ;

-- 3. What is the total balance of all checking accounts?

select sum(balance) as "Overall total balance including all account types" from accounts ; 

select accounttype as "Account Type", sum(balance) as "Total balance in each account type" from accounts group by accounttype; 

select accounttype as "Account Type" , sum(balance) as "Total balance in Checking account type" from accounts where accounttype = 'checking' ;

-- 4. What is the total balance of all accounts associated with customers who live in Los Angeles ?

select sum(balance) as "total balance of all accounts associated with customers who live in Los Angeles" 
                       from ( select cus.city , acc.balance from accounts acc left join customers cus 
                       on cus.customerid = acc.customerid ) table1
where city = 'los angeles' ; 

-- 5. Which branch has the highest average account balance?

select branchid as "Branch ID" , branchname as "Branch Name", round( avg(balance) , 2 ) as "Averge Balance" 
                          from
                              ( select bran.branchid , bran.branchname , acc.balance 
								from accounts acc inner join branches bran 
								on acc.branchid = bran.branchid ) table1
group by branchid , branchname order by avg(balance) desc limit 1;

-- 6. Which customer has the highest current balance in their accounts?

with table1 as
	  ( select customerid , sum(balance) as "Total Balance" from accounts 
		group by customerid 
        order by sum(balance) desc limit 1) ,
	 table2 as
	  ( select customerid from table1 )
select customerid , concat(firstname," ",lastname) as "Customer Name" from customers where customerid = (select * from table2)  ;

-- 7. Which customer has made the most transactions in the Transactions table ?

select customerid , count(transactionid) as "Number of transactions" from
                                 ( select acc.customerid , tran.transactionid 
                                   from accounts acc left join transactions tran 
                                   on acc.accountid = tran.accountid ) t1
group by customerid order by count(transactionid) desc limit 1 ;

-- 8.Which branch has the highest total balance across all of its accounts?

with table1 as 
	 ( select branchid , sum(balance) from accounts group by branchid order by sum(balance) desc limit 1 )
select t1.branchid , bran.branchname , bran.city , bran.state , t1.`sum(balance)` as "Total Balance"
from table1 t1 inner join branches bran on t1.branchid = bran.branchid ;

-- 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?

with table1 as
	 ( select customerid , sum(balance) as "Total Balance" 
					  from accounts group by customerid 
                      order by sum(balance) desc limit 1)
select customerid , concat(firstname," ",lastname) as "Customer Name", city , state 
from customers where customerid = (select customerid from table1) ; 

-- 10. Which branch has the highest number of transactions in the Transactions table?

with table1 as 
	 ( select acc.branchid , tran.transactionid 
       from accounts acc inner join transactions tran 
       on acc.accountid = tran.accountid ) ,
       table2 as
	 ( select branchid , count(transactionid) as "Total Transactions" 
       from table1 group by branchid order by count(transactionid) desc limit 1) ,
       table3 as
	 ( select t2.branchid , t2.`total transactions` , bran.branchname , bran.city , bran.state
	   from table2 t2 inner join branches bran on t2.branchid = bran.branchid)
select * from table3 ;





















































































































































 







