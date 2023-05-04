CREATE OR REPLACE FUNCTION "BREF"."HistoTypeMandatProfession"(
	)
    RETURNS TABLE(nbmandat text, profession character varying, countmandat integer, pourcentage numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
rec record;
nbtotmandat int;
nb_mandat text;
profession_m varchar;
count_mandat int;
pourcentage_n numeric;
BEGIN

select sum(A.countmandat) 
into nbtotmandat
from
	(
	select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	group by "IdIndividu", "TypeMandat"
	having count("IdMandat") = 2
	)A;

for rec in 
	select '2' as nb_mandat, "LibelleProfession" as profession_m, count("IdMandat") as count_mandat, 
	round(count("IdMandat")*100/(nbtotmandat)::numeric(1000,1), 5) as pourcentage_n
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 2
		)A
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."TypeMandat" = A."TypeMandat" and "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
	join "BREF"."Profession" on "BREF"."Profession"."CodeProfession" = "BREF"."Mandat"."IdProfession"
	group by "LibelleProfession"
loop
	nbmandat := rec.nb_mandat;
	profession := rec.profession_m;
	countmandat := rec.count_mandat;
	pourcentage := rec.pourcentage_n;
	return next;
end loop;

select sum(A.countmandat) 
into nbtotmandat
from
	(
	select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	group by "IdIndividu", "TypeMandat"
	having count("IdMandat") = 3
	)A;

for rec in 
	select '3' as nb_mandat, "LibelleProfession" as profession_m, count("IdMandat") as count_mandat, 
	round(count("IdMandat")*100/(nbtotmandat)::numeric(1000,1), 5) as pourcentage_n
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 3
		)A
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."TypeMandat" = A."TypeMandat" and "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
	join "BREF"."Profession" on "BREF"."Profession"."CodeProfession" = "BREF"."Mandat"."IdProfession"
	group by "LibelleProfession"
loop
	nbmandat := rec.nb_mandat;
	profession := rec.profession_m;
	countmandat := rec.count_mandat;
	pourcentage := rec.pourcentage_n;
	return next;
end loop;

select sum(A.countmandat) 
into nbtotmandat
from
	(
	select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	group by "IdIndividu", "TypeMandat"
	having count("IdMandat") = 4
	)A;

for rec in 
	select '4' as nb_mandat, "LibelleProfession" as profession_m, count("IdMandat") as count_mandat, 
	round(count("IdMandat")*100/(nbtotmandat)::numeric(1000,1), 5) as pourcentage_n
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 4
		)A
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."TypeMandat" = A."TypeMandat" and "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
	join "BREF"."Profession" on "BREF"."Profession"."CodeProfession" = "BREF"."Mandat"."IdProfession"
	group by "LibelleProfession"
loop
	nbmandat := rec.nb_mandat;
	profession := rec.profession_m;
	countmandat := rec.count_mandat;
	pourcentage := rec.pourcentage_n;
	return next;
end loop;

select sum(A.countmandat) 
into nbtotmandat
from
	(
	select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	group by "IdIndividu", "TypeMandat"
	having count("IdMandat") > 4
	)A;

for rec in 
	select '2' as nb_mandat, "LibelleProfession" as profession_m, count("IdMandat") as count_mandat, 
	round(count("IdMandat")*100/(nbtotmandat)::numeric(1000,1), 5) as pourcentage_n
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") > 4
		)A
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."TypeMandat" = A."TypeMandat" and "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
	join "BREF"."Profession" on "BREF"."Profession"."CodeProfession" = "BREF"."Mandat"."IdProfession"
	group by "LibelleProfession"
loop
	nbmandat := rec.nb_mandat;
	profession := rec.profession_m;
	countmandat := rec.count_mandat;
	pourcentage := rec.pourcentage_n;
	return next;
end loop;

END;
$BODY$;
