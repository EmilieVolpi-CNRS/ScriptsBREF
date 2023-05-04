CREATE OR REPLACE FUNCTION "BREF"."HistoMonoMandatPartielAnneeHF"(
	)
    RETURNS TABLE(nbm bigint, pourcentagem numeric, nbf bigint, pourcentagef numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
return query
	select "NbM", "NbM"*100/("NbM"+count(B."IdIndividu"))::numeric(1000,1) as "pourcentageM", 
	count(B."IdIndividu") as "NbF", count(B."IdIndividu")*100/("NbM"+count(B."IdIndividu"))::numeric(1000,1) as "pourcentageF"
	from
		(
		select count("IdIndividu") as "NbM" from "BREF"."HistoMonoMandatPartielAnnee"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."HistoMonoMandatPartielAnnee".idindividu
		where "Sexe" = 'M') A,
		(select * from "BREF"."HistoMonoMandatPartielAnnee"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."HistoMonoMandatPartielAnnee".idindividu
		 )B
	where B."Sexe" = 'F'
	group by "NbM";
END;
$BODY$;
