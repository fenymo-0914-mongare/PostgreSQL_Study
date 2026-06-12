 CREATE TABLE person (           +
     id bigint,                  +
     firstname character varying,+
     lastname character varying, +
     gender character varying,   +
     date_of_birth date          +
 );                              +
 

 NOT NULL firstname;
 NOT NULL lastname;
 NOT NULL gender;
 NOT NULL date_of_birth;
 NOT NULL id;
 PRIMARY KEY (id);

 CREATE UNIQUE INDEX person_pkey ON public.person USING btree (id);

