CREATE OR REPLACE FUNCTION "BREF"."HistoMonoMandatNuancePolitique"(
	)
    RETURNS TABLE(nuancepolitique character, countindiv bigint, pourcentage numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
nbtotindiv int;
rec record;
BEGIN

select count(A."IdIndividu")
into nbtotindiv
from
	(
	select "IdIndividu"
	from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	group by "IdIndividu"
	having count("IdMandat") = 1
	)A;

--raise notice '%', nbtotindiv;

for rec in 
	select "NuancePolitique", count("IdMandat") as countmandat
	from
		(
		select "IdIndividu" from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		group by "IdIndividu"
		having count("IdMandat") = 1
		) A,
	"BREF"."Mandat", "BREF"."NuancePolitique"
	where "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	and "BREF"."NuancePolitique"."IdNuancePolitique" = "BREF"."Mandat"."IdNuancePolitique"
	group by "NuancePolitique"
loop
	nuancepolitique := rec."NuancePolitique";
	countindiv := rec.countmandat;
	pourcentage := round(rec.countmandat*100/(nbtotindiv)::numeric(1000,1), 5);
	return next;	
end loop;
END;
$BODY$;
