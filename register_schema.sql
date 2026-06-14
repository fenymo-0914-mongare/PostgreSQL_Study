 CREATE TABLE register (           +
     id integer,                   +
     first_name character varying, +
     last_name character varying,  +
     bank_name character varying,  +
     gender character varying,     +
     home_address character varying+
 );                                +
 

 NOT NULL id;
 PRIMARY KEY (id);

 CREATE UNIQUE INDEX register_pkey ON public.register USING btree (id);

