CREATE OR REPLACE FUNCTION "BREF"."NbIndividuDistinct"(
	)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
nb int;
BEGIN

	select into nb count(distinct "IdIndividu")
	from "BREF"."Individu";
return nb;
END;
$BODY$;