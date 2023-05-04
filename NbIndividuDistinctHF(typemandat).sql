CREATE OR REPLACE FUNCTION "BREF"."NbIndividuDistinctHF"(
	typemandat character varying)
    RETURNS TABLE(nbm bigint, pourcentagem numeric, nbf bigint, pourcentagef numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
nb int;
BEGIN
 return query 
 select I."NbM", I."NbM"*100/(select * from "BREF"."NbIndividuDistinct"())::numeric(1000,1) as "pourcentageM", 
 count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(select * from "BREF"."NbIndividuDistinct"())::numeric(1000,1) as "pourcentageF" 
 from "BREF"."Individu" I2, "BREF"."Mandat",
	(select count(I1."IdIndividu") as "NbM"
	from "BREF"."Individu" I1
	 join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = I1."IdIndividu"
	where I1."Sexe" = 'M'
	 and "TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = upper(unaccent(typemandat)))
	 ) I
 where I2."Sexe" = 'F'
 and "BREF"."Mandat"."Elu_IdIndividu" = I2."IdIndividu"
 and "TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = upper(unaccent(typemandat)))
 group by I."NbM";
END;
$BODY$;
