CREATE OR REPLACE FUNCTION "BREF"."NbIndividuDistinctHF"(
	)
    RETURNS TABLE(nbm bigint, pourcentagem numeric, nbf bigint, pourcentagef numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
nb int;
BEGIN
 return query select I."NbM", I."NbM"*100/(select * from "BREF"."NbIndividuDistinct"())::numeric(1000,1) as "pourcentageM", 
 count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(select * from "BREF"."NbIndividuDistinct"())::numeric(1000,1) as "pourcentageF" from "BREF"."Individu" I2,
	(select count(I1."IdIndividu") as "NbM"
	from "BREF"."Individu" I1
	where I1."Sexe" = 'M'
	 ) I
 where I2."Sexe" = 'F'
 group by "NbM";
END;
$BODY$;
