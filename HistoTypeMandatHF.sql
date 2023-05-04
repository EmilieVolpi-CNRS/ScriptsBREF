CREATE OR REPLACE FUNCTION "BREF"."HistoTypeMandatHF"(
	)
    RETURNS TABLE(nbmandat text, nbm bigint, pourcentagem numeric, nbf bigint, pourcentagef numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
nb_mandat text;
nb_m bigint; 
pourcentage_m numeric;
nb_f bigint;
pourcentage_f numeric;
BEGIN

select '2' as "NbMandat", AA."NbM", AA."NbM"*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageM",
count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageF"
into nb_mandat, nb_m, pourcentage_m, nb_f, pourcentage_f
from 
	(
	select count(A."IdIndividu") as "NbM" 
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 2
		) A
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = A."IdIndividu"
	where "Sexe" = 'M'
	) AA,
	(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 2
	) B, "BREF"."Individu" I2
where I2."IdIndividu" = B."IdIndividu"
and I2."Sexe" = 'F'
group by "NbM";
nbmandat := nb_mandat;
nbm := nb_m;
pourcentagem := pourcentage_m;
nbf := nb_f;
pourcentagef := pourcentage_f;
return next;

select '3' as "NbMandat", AA."NbM", AA."NbM"*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageM",
count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageF"
into nb_mandat, nb_m, pourcentage_m, nb_f, pourcentage_f
from 
	(
	select count(A."IdIndividu") as "NbM" 
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 3
		) A
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = A."IdIndividu"
	where "Sexe" = 'M'
	) AA,
	(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 3
	) B, "BREF"."Individu" I2
where I2."IdIndividu" = B."IdIndividu"
and I2."Sexe" = 'F'
group by "NbM";
nbmandat := nb_mandat;
nbm := nb_m;
pourcentagem := pourcentage_m;
nbf := nb_f;
pourcentagef := pourcentage_f;
return next;

select '4' as "NbMandat", AA."NbM", AA."NbM"*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageM",
count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageF"
into nb_mandat, nb_m, pourcentage_m, nb_f, pourcentage_f
from 
	(
	select count(A."IdIndividu") as "NbM" 
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 4
		) A
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = A."IdIndividu"
	where "Sexe" = 'M'
	) AA,
	(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 4
	) B, "BREF"."Individu" I2
where I2."IdIndividu" = B."IdIndividu"
and I2."Sexe" = 'F'
group by "NbM";
nbmandat := nb_mandat;
nbm := nb_m;
pourcentagem := pourcentage_m;
nbf := nb_f;
pourcentagef := pourcentage_f;
return next;

select '4+' as "NbMandat", AA."NbM", AA."NbM"*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageM",
count(I2."IdIndividu") as "NbF", count(I2."IdIndividu")*100/(AA."NbM"+count(I2."IdIndividu"))::numeric(1000,1) as "pourcentageF"
into nb_mandat, nb_m, pourcentage_m, nb_f, pourcentage_f
from 
	(
	select count(A."IdIndividu") as "NbM" 
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") > 4
		) A
	join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = A."IdIndividu"
	where "Sexe" = 'M'
	) AA,
	(
		select "IdIndividu", "TypeMandat", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") > 4
	) B, "BREF"."Individu" I2
where I2."IdIndividu" = B."IdIndividu"
and I2."Sexe" = 'F'
group by "NbM";
nbmandat := nb_mandat;
nbm := nb_m;
pourcentagem := pourcentage_m;
nbf := nb_f;
pourcentagef := pourcentage_f;
return next;

END;
$BODY$;