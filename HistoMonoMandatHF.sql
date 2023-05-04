CREATE OR REPLACE FUNCTION "BREF"."HistoMonoMandatHF"(
	)
    RETURNS TABLE(nbm bigint, pourcentagem numeric, nbf bigint, pourcentagef numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
return query
select AA."NbM", AA."NbM"*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageM", 
count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageF"
from
	(
	select count(A."IdIndividu") as "NbM" from 
		(
		select "IdIndividu", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		group by "IdIndividu"
		having count("IdMandat") = 1
		) A,
	"BREF"."Individu" I1
	where I1."IdIndividu" = A."IdIndividu"
	and I1."Sexe" = 'M'
	) AA,
	(
	select "IdIndividu", count("IdMandat") from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	group by "IdIndividu"
	having count("IdMandat") = 1
	) B, "BREF"."Individu" I2
where I2."IdIndividu" = B."IdIndividu"
and I2."Sexe" = 'F'
group by "NbM";
END;
$BODY$;