CREATE OR REPLACE FUNCTION "BREF"."HistoMonoMandatPartielAnnee"(
	)
    RETURNS TABLE(idindividu character varying, typemandat character varying, dureemandat integer, date_debut_mandat date, date_fin_mandat date) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
rec record;
duree int;
BEGIN
for rec in 
	select "IdIndividu", "BREF"."TypeMandat"."IdTypeMandat", "BREF"."TypeMandat"."TypeMandat", "IdMandat", "DateDebutMandat", "DateFinMandat", "TypeMandat" 
	from 
		(
		select "IdIndividu", count("IdMandat") from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		group by "IdIndividu"
		having count("IdMandat") = 1 --593170 individus ne font qu'un seul mandat (des types spécifiés)
		) A
	join "BREF"."Mandat" on A."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
	where "IdTypeMandat" in (2, 4, 5, 6, 8, 9)
	order by "DateDebutMandat" asc
loop
	duree =  date_part('year', rec."DateFinMandat") - date_part('year', rec."DateDebutMandat");
	case rec."IdTypeMandat"
	when 2 then --"CONSEILLER DEPARTEMENTAL"
		if (((date_part('year', rec."DateDebutMandat")>= 1958 and date_part('year', rec."DateDebutMandat") < 1985) 
			 or (date_part('year', rec."DateDebutMandat")>= 1992 and date_part('year', rec."DateDebutMandat") < 2001)) 
			 and duree < 6) 
		or (((date_part('year', rec."DateDebutMandat")>= 1985 and date_part('year', rec."DateDebutMandat") < 1992) 
			or (date_part('year', rec."DateDebutMandat")>= 2001 and date_part('year', rec."DateDebutMandat") < 2008)
			or (date_part('year', rec."DateDebutMandat")>= 2004 and date_part('year', rec."DateDebutMandat") < 2011)
			or (date_part('year', rec."DateDebutMandat")>= 2008)) 
			and duree < 7)
		then
			idindividu := rec."IdIndividu";
			typemandat := rec."TypeMandat";
			dureemandat := duree;
			date_debut_mandat := rec."DateDebutMandat";
			date_fin_mandat := rec."DateFinMandat";
			return next;
		end if;
	when 4 then --"CONSEILLER MUNICIPAL"
		if duree < 6 then
			idindividu := rec."IdIndividu";
			typemandat := rec."TypeMandat";
			dureemandat := duree;
			date_debut_mandat := rec."DateDebutMandat";
			date_fin_mandat := rec."DateFinMandat";
			return next;
		end if;
	when 5 then --"CONSEILLER REGIONAL"
		if (date_part('year', rec."DateDebutMandat")>= 1958 and duree < 6) 
		or (date_part('year', rec."DateDebutMandat")>= 2010 and date_part('year', rec."DateDebutMandat") < 2015 and duree < 5)
		then
			idindividu := rec."IdIndividu";
			typemandat := rec."TypeMandat";
			dureemandat := duree;
			date_debut_mandat := rec."DateDebutMandat";
			date_fin_mandat := rec."DateFinMandat";
			return next;
		end if;
	when 6 then --"DEPUTE"
		if (((date_part('year', rec."DateDebutMandat")>= 1962 and date_part('year', rec."DateDebutMandat") < 1967) 
			 or (date_part('year', rec."DateDebutMandat")>= 1968 and date_part('year', rec."DateDebutMandat") < 1978)
			or (date_part('year', rec."DateDebutMandat")>= 1981 and date_part('year', rec."DateDebutMandat") < 1986)
			or (date_part('year', rec."DateDebutMandat")>= 1988 and date_part('year', rec."DateDebutMandat") < 1993)
			or (date_part('year', rec."DateDebutMandat")>= 1997)) 
			 and duree < 5)
		or (date_part('year', rec."DateDebutMandat")>= 1958 and date_part('year', rec."DateDebutMandat") < 1962 and duree < 4)
		or (date_part('year', rec."DateDebutMandat")>= 1967 and date_part('year', rec."DateDebutMandat") < 1968 and duree < 1)
		or (date_part('year', rec."DateDebutMandat")>= 1978 and date_part('year', rec."DateDebutMandat") < 1981 and duree < 3)
		or (date_part('year', rec."DateDebutMandat")>= 1986 and date_part('year', rec."DateDebutMandat") < 1988 and duree < 2)
		or (date_part('year', rec."DateDebutMandat")>= 1993 and date_part('year', rec."DateDebutMandat") < 1997 and duree < 4)
		then
			idindividu := rec."IdIndividu";
			typemandat := rec."TypeMandat";
			dureemandat := duree;
			date_debut_mandat := rec."DateDebutMandat";
			date_fin_mandat := rec."DateFinMandat";
			return next;
		end if;
	when 8 then --"REPRESENTANT AU PARLEMENT EUROPEEN"
		if duree < 5 then
			idindividu := rec."IdIndividu";
			typemandat := rec."TypeMandat";
			dureemandat := duree;
			date_debut_mandat := rec."DateDebutMandat";
			date_fin_mandat := rec."DateFinMandat";
			return next;
		end if;
	when 9 then --"SENATEUR"
		if (((date_part('year', rec."DateDebutMandat")>= 1958 and date_part('year', rec."DateDebutMandat") < 1998) 
			 or (date_part('year', rec."DateDebutMandat")>= 2008 and date_part('year', rec."DateDebutMandat") < 2017)) 
			 and duree < 9) 
		or (((date_part('year', rec."DateDebutMandat")>= 2011 and date_part('year', rec."DateDebutMandat") < 2017) 
			or (date_part('year', rec."DateDebutMandat")>= 2014)) 
			and duree < 6)
		or (((date_part('year', rec."DateDebutMandat")>= 1998 and date_part('year', rec."DateDebutMandat") < 2008)
			 or (date_part('year', rec."DateDebutMandat")>= 2004 and date_part('year', rec."DateDebutMandat") < 2014)
			 or (date_part('year', rec."DateDebutMandat")>= 2001 and date_part('year', rec."DateDebutMandat") < 2011))
			and duree < 10)
		then
			idindividu := rec."IdIndividu";
			typemandat := rec."TypeMandat";
			dureemandat := duree;
			date_debut_mandat := rec."DateDebutMandat";
			date_fin_mandat := rec."DateFinMandat";
			return next;
		end if;
	else
	end case;
end loop;

END;
$BODY$;