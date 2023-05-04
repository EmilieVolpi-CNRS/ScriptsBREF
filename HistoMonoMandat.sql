CREATE OR REPLACE FUNCTION "BREF"."HistoMonoMandat"(
	)
    RETURNS TABLE(idindividu character varying, idmandat integer, datedebutmandat date, datefinmandat date, typemandat character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
return query select "IdIndividu", "IdMandat", "DateDebutMandat", "DateFinMandat", "TypeMandat" from 
	(
	select "IdIndividu", count("IdMandat") from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	group by "IdIndividu"
	having count("IdMandat") = 1
	) A
join "BREF"."Mandat" on A."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
order by "DateDebutMandat" asc;
END;
$BODY$;