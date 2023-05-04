CREATE OR REPLACE FUNCTION "BREF"."HistoTypeMandatTemps"(
	)
    RETURNS TABLE(idindividu character varying, typemandat character varying, idmandat integer, datedebutmandat date, datefinmandat date) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
return query

select A."IdIndividu", A."TypeMandat", "IdMandat", "DateDebutMandat", "DateFinMandat"
from
	(
	select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	group by "IdIndividu", "TypeMandat"
	having count("IdMandat") > 1
	) A
join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
order by A."IdIndividu", A."TypeMandat", "DateDebutMandat";
END;
$BODY$;
