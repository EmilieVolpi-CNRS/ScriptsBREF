CREATE OR REPLACE FUNCTION "BREF"."HistoNbMandatParAnnee"(
	anneedebut integer)
    RETURNS TABLE(typemandat character varying, annee integer, nbm integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
arr varchar[] := array['DEPUTE', 'SENATEUR', 'REPRESENTANT AU PARLEMENT EUROPEEN',  'CONSEILLER REGIONAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER MUNICIPAL'];
rec record;
man varchar;
mindate date;
maxdate date;
minannee int;
maxannee int;
i int;
nb int;
BEGIN
	foreach man in array arr
	loop
		typemandat := man;
		select make_date(anneedebut, 1,1), max("DateFinMandat")
		into mindate, maxdate
		from "BREF"."Mandat"
		where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
															 where "TypeMandat" = man);
		if date_part('month', mindate) = 1 then minannee = date_part('year', mindate);
		else minannee = date_part('year', mindate)+1;
		end if;
		if date_part('month', maxdate) = 1 then maxannee = date_part('year', maxdate)-1;
		else maxannee = date_part('year', maxdate);
		end if;
		for i in minannee..maxannee loop
			nb = 0;
			select into nb count(distinct "IdMandat")
			from "BREF"."Mandat"
			where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = man)
			and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null);
			if(nb != 0) then 
				annee := i;
				nbM := nb;
				return next;
			end if;
		end loop;
	end loop;
END;
$BODY$;