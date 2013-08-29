update NewInsuranceCo.CONTRACT
set CLIENT_ID = CLIENT_ID - 1000
where CLIENT_ID in 
(
	select * from
	(
		select 	3000 + CUSTOMER_ID
		from SYTYCD.CUSTOMER C
		where not exists
		(
			select 1 from SYTYCD.POLICY P
			where P.CUSTOMER_ID = C.CUSTOMER_ID
			and P.`POLICY-TYPE_ID` = 1
			
		)
		LIMIT 120
	) as T
)
AND `INSURANCE-TYPE_ID` = 3;

update NewInsuranceCo.CONTRACT
set CLIENT_ID = CLIENT_ID - 1000
where CLIENT_ID in 
(
	select * from
	(
		select 	3000 + CUSTOMER_ID
		from SYTYCD.CUSTOMER C
		where not exists
		(
			select 1 from SYTYCD.POLICY P
			where P.CUSTOMER_ID = C.CUSTOMER_ID
			and P.`POLICY-TYPE_ID` = 2
			
		)
		LIMIT 97
	) as T
)
AND `INSURANCE-TYPE_ID` = 1;

update NewInsuranceCo.CONTRACT
set CLIENT_ID = CLIENT_ID - 1000
where CLIENT_ID in 
(
	select * from
	(
		select 	3000 + CUSTOMER_ID
		from SYTYCD.CUSTOMER C
		where not exists
		(
			select 1 from SYTYCD.POLICY P
			where P.CUSTOMER_ID = C.CUSTOMER_ID
			and P.`POLICY-TYPE_ID` = 3
			
		)
		LIMIT 201
	) as T
)
AND `INSURANCE-TYPE_ID` = 2;	

delete from CONTRACT
where CLIENT_ID >= 3000
and CONTRACT_ID > 3000;

