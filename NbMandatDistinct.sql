CREATE OR REPLACE FUNCTION "BREF"."NbMandatDistinct"(
	)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
nb int;
BEGIN
select into nb count(distinct "IdMandat")
from "BREF"."Mandat";
return nb;
END;
$BODY$;