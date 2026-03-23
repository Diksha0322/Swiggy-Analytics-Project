create database swiggy_db;
use swiggy_db;
/* Data modelling */
select orderid from orders;
describe orders;
describe customers;
describe restaurant;
describe customeraddress;
describe deliveryagent;
describe menu;
alter table orders
add constraint pk_order_id primary key(orderid);
alter table customers add constraint pk_customer_id primary key(customer_id);
alter table orders 
add constraint fk_customer_id foreign key(customer_id) references customers(customer_id);
alter table restaurant 
add constraint pk_restaurant_id primary key(restaurantid);
alter table orders add constraint fk_restaurant_id foreign key(restaurant_id) references restaurant(restaurantid);
/* customer address modelling */
alter table customeraddress add constraint pk_customer_address_id primary key(customer_address_id);
alter table customeraddress add constraint fk_cust_id foreign key(customer_id) references customers(customer_id);
/* Menu table modelling*/
alter table menu add constraint pk_menu_id primary key(menuitem_id);

alter table menu add constraint fk_rest_id foreign key(restaurant_id) references restaurant(restaurantid);
/* Delivery agent id modelling */
alter table deliveryagent add constraint pk_deliveryagent_id primary key(delivery_agentid);
/* Delivery table modelling */
alter table delivery add constraint pk_del_id primary key(delivery_id);
alter table delivery add constraint fk_ord_id foreign key(order_id) references orders(orderid);
alter table delivery add constraint fk_agnt_id foreign key(delivery_agent_id) references deliveryagent(delivery_agentid);

/* Modelling login_audit */
describe login_audit;
alter table login_audit add constraint pk_login_audit_id primary key(login_audit_id);
alter table login_audit add constraint fk_custom_id foreign key(customerid) references customers(customer_id);

/* column check */
describe orders;
select * from orders;
ALTER TABLE orders
MODIFY order_date DATE,
MODIFY created_date DATE,
MODIFY modified_date DATE;

describe customers;

select * from customers;

ALTER TABLE customers
MODIFY lastorderdate DATE,
MODIFY createddate DATE,
MODIFY modifieddate DATE,
MODIFY dob DATE,
MODIFY anniversary DATE null;

describe delivery;

select count(*) from delivery where modifieddate is null; 

ALTER TABLE delivery
MODIFY pickup_time  DATETIME,
MODIFY expected_delivery_time  DATETIME,
MODIFY actual_delivery_time DATETIME,
MODIFY createddate DATE,
MODIFY modifieddate DATE ;

describe menu; 

select count(*) from menu where modified_date is null; 


ALTER TABLE menu
MODIFY created_date DATE,
MODIFY modified_date DATE ;

describe restaurant;

ALTER TABLE restaurant
MODIFY created_date DATE,
MODIFY modified_date DATE ;

describe deliveryagent;

describe login_audit;
ALTER TABLE login_audit
MODIFY login_time datetime,
MODIFY logout_time datetime ;
