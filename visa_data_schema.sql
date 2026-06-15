 CREATE TABLE visa_data (         +
     id bigint,                   +
     first_name character varying,+
     last_name character varying, +
     email character varying,     +
     gender character varying,    +
     date_of_birth date,          +
     nationality character varying+
 );                               +
 

 NOT NULL id;
 PRIMARY KEY (id);

 CREATE UNIQUE INDEX visa_data_pkey ON public.visa_data USING btree (id);

