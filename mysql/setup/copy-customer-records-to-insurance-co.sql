SET SQL_SAFE_UPDATES=0;

delete from NewInsuranceCo.CLIENT
where CLIENT_ID > 2000;

-- TITLE, FIRST_NAME, FAMILY_NAME, DOB, PHONE_1, PHONE_2,EMAIL,M_OR_F,PROFESSION,ADDRESS 
delete from NewInsuranceCo.CLIENT
where CLIENT_ID in 
(
	select * from 
	(
		select 	2000 + CUSTOMER_ID
		from SYTYCD.CUSTOMER C
		where not exists
		(
			select 1 from SYTYCD.POLICY P
			where P.CUSTOMER_ID = C.CUSTOMER_ID
			and P.`POLICY-TYPE_ID` = 2
			
		)
		LIMIT 97
	) as T
);

-- Customers without car insurance
insert into NewInsuranceCo.CLIENT(CLIENT_ID,TITLE, FIRST_NAME, FAMILY_NAME, DOB, PHONE_1, PHONE_2,EMAIL,M_OR_F,PROFESSION,ADDRESS_ID)
select 
2000 + CUSTOMER_ID,
TITLE,
FIRST_NAME,
SURNAME,
DATE_OF_BIRTH,
HOME_PHONE,
MOBILE_PHONE,
EMAIL,
GENDER,
OCCUPATION,
ADDRESS_ID
from SYTYCD.CUSTOMER C
where not exists
(
	select 1 from SYTYCD.POLICY P
	where P.CUSTOMER_ID = C.CUSTOMER_ID
	and P.`POLICY-TYPE_ID` = 2
)
LIMIT 1,97 ;

delete from NewInsuranceCo.CLIENT
where CLIENT_ID in 
(
	select * from 
	(
		select 	2000 + CUSTOMER_ID
		from SYTYCD.CUSTOMER C
		where not exists
		(
			select 1 from SYTYCD.POLICY P
			where P.CUSTOMER_ID = C.CUSTOMER_ID
			and P.`POLICY-TYPE_ID` = 1
			
		)
		LIMIT 1,120
	) as T
);

-- Customers without home insurance
insert into NewInsuranceCo.CLIENT(CLIENT_ID,TITLE, FIRST_NAME, FAMILY_NAME, DOB, PHONE_1, PHONE_2,EMAIL,M_OR_F,PROFESSION,ADDRESS_ID)
select 
2000 + CUSTOMER_ID,
TITLE,
FIRST_NAME,
SURNAME,
DATE_OF_BIRTH,
HOME_PHONE,
MOBILE_PHONE,
EMAIL,
GENDER,
OCCUPATION,
ADDRESS_ID
from SYTYCD.CUSTOMER C
where not exists
(
	select 1 from SYTYCD.POLICY P
	where P.CUSTOMER_ID = C.CUSTOMER_ID
	and P.`POLICY-TYPE_ID` = 1
)
LIMIT 1,120 ;

delete from NewInsuranceCo.CLIENT
where CLIENT_ID in 
(
	select * from 
	(
		select 	2000 + CUSTOMER_ID
		from SYTYCD.CUSTOMER C
		where not exists
		(
			select 1 from SYTYCD.POLICY P
			where P.CUSTOMER_ID = C.CUSTOMER_ID
			and P.`POLICY-TYPE_ID` = 3
			
		)
		LIMIT 1,201
	) as T
);

-- Customers without life insurance
insert into NewInsuranceCo.CLIENT(CLIENT_ID,TITLE, FIRST_NAME, FAMILY_NAME, DOB, PHONE_1, PHONE_2,EMAIL,M_OR_F,PROFESSION,ADDRESS_ID)
select 
2000 + CUSTOMER_ID,
TITLE,
FIRST_NAME,
SURNAME,
DATE_OF_BIRTH,
HOME_PHONE,
MOBILE_PHONE,
EMAIL,
GENDER,
OCCUPATION,
ADDRESS_ID
from SYTYCD.CUSTOMER C
where not exists
(
	select 1 from SYTYCD.POLICY P
	where P.CUSTOMER_ID = C.CUSTOMER_ID
	and P.`POLICY-TYPE_ID` = 3
)
LIMIT 1,201 ;

insert into NewInsuranceCo.ADDRESS
select A.ADDRESS_ID + 2000, A.LINE_1, A.LINE_2, A.LINE_3, A.POSTCODE
from SYTYCD.ADDRESS A, NewInsuranceCo.CLIENT C, SYTYCD.CUSTOMER C2
where A.ADDRESS_ID = C.CLIENT_ID - 2000
and C2.ADDRESS_ID = A.ADDRESS_ID;
