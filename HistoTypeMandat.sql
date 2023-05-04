CREATE OR REPLACE FUNCTION "BREF"."HistoTypeMandat"(
	)
    RETURNS TABLE(idindividu character varying, typemandat character varying, count bigint) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
return query
	select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	group by "IdIndividu", "TypeMandat"
	having count("IdMandat") > 1
	order by "IdIndividu", "TypeMandat";
END;
$BODY$;