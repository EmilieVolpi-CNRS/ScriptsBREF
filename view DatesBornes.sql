CREATE OR REPLACE FUNCTION "BREF"."DatesBornes"(
	)
    RETURNS TABLE("MinDateDebutMandat" date, "MinIdMandat" integer, "MaxDateFinMandat" date, "MaxIdMandat" integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
RETURN QUERY select m1."DateDebutMandat" as "MinDateDebutMandat", m1."IdMandat" as "MinIdMandat",
m2."DateFinMandat" as "MaxDateFinMandat", m2."IdMandat" as "MaxIdMandat"
from "BREF"."Mandat" m1, "BREF"."Mandat" m2
where m1."DateDebutMandat" = (select min("DateDebutMandat") from "BREF"."Mandat")
and m2."DateFinMandat" = (select max("DateFinMandat") from "BREF"."Mandat");
END;
$BODY$;