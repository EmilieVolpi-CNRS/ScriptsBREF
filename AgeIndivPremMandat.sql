CREATE OR REPLACE FUNCTION "BREF"."AgeIndivPremMandat"(
	)
    RETURNS TABLE(idindividu character varying, age double precision, datedebutmandat date) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
nb int;
BEGIN
 return query 
 select "IdIndividu", date_part('year', age(min("DateDebutMandat"), "DateNaissance")) as age, min("DateDebutMandat") as "DateDebutMandat"
from "BREF"."Individu"
join "BREF"."Mandat" on  "BREF"."Mandat"."Elu_IdIndividu" = "BREF"."Individu"."IdIndividu"
group by "IdIndividu", "DateNaissance"
order by "IdIndividu";
END;
$BODY$;
