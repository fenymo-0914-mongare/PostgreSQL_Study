 CREATE TABLE cars (           +
     id bigint,                +
     make character varying,   +
     model character varying,  +
     color character varying,  +
     price numeric,            +
     currency character varying+
 );                            +
 

 NOT NULL id;
 NOT NULL make;
 NOT NULL model;
 NOT NULL color;
 NOT NULL price;
 NOT NULL currency;
 PRIMARY KEY (id);

 CREATE UNIQUE INDEX cars_pkey ON public.cars USING btree (id);

