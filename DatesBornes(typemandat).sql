CREATE OR REPLACE FUNCTION "BREF"."DatesBornes"(
	typemandat character varying)
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
where m1."DateDebutMandat" = (select min("DateDebutMandat") from "BREF"."Mandat" where "TypeDuMandat_IdTypeMandat" = 
										   (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = upper(unaccent(typemandat))))
and m2."DateFinMandat" = (select max("DateFinMandat") from "BREF"."Mandat" where "TypeDuMandat_IdTypeMandat" = 
										   (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = upper(unaccent(typemandat))));
END;
$BODY$;
