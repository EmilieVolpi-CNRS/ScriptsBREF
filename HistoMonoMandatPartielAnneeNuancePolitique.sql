CREATE OR REPLACE FUNCTION "BREF"."HistoMonoMandatPartielAnneeNuancePolitique"(
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
select count(idindividu)
into nbtotindiv
from "BREF"."HistoMonoMandatPartielAnnee";
	
for rec in 
	select "NuancePolitique", count("IdMandat") as countmandat
	from "BREF"."HistoMonoMandatPartielAnnee"
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = idindividu
	join "BREF"."NuancePolitique" on "BREF"."NuancePolitique"."IdNuancePolitique" = "BREF"."Mandat"."IdNuancePolitique"
	group by "NuancePolitique"
loop
	nuancepolitique := rec."NuancePolitique";
	countindiv := rec.countmandat;
	pourcentage := round(rec.countmandat*100/(nbtotindiv)::numeric(1000,1), 5);
	return next;	
end loop;
END;
$BODY$;
