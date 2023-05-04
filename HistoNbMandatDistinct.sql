CREATE OR REPLACE FUNCTION "BREF"."HistoNbMandatDistinct"(
	typemandat character varying,
	typefonction character varying)
    RETURNS TABLE(annee integer, nbm integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
mindate date;
maxdate date;
minannee int;
maxannee int;
i int;
nb int;
BEGIN
	select min("DateDebutMandat"), current_date
	into mindate, maxdate
	from "BREF"."Mandat"
	where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
														 where "TypeMandat" = upper(unaccent(typemandat)));
	if date_part('month', mindate) = 1 then minannee = date_part('year', mindate);
	else minannee = date_part('year', mindate)+1;
	end if;
	if date_part('month', maxdate) = 1 then maxannee = date_part('year', maxdate)-1;
	else maxannee = date_part('year', maxdate);
	end if;
	for i in minannee..maxannee loop
		nb = 0;
		case typefonction 
		when '' then
			select into nb count(distinct "IdMandat")
			from "BREF"."Mandat"
			where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = upper(unaccent(typemandat)))
			and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null);
			if(nb != 0) then 
				annee := i;
				nbM := nb;
				return next;
			end if;
		else
			select into nb count(distinct "IdMandat")
			from "BREF"."Mandat"
			where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																 where "TypeMandat" = upper(unaccent(typemandat)))
			and "BREF"."Mandat"."IdMandat" in (select "IdMandat" from "BREF"."Fonction"
											  where "TypeDeFonction_IdTypeFonction" = (select "IdTypeFonction" from "BREF"."TypeFonction"
																					  where "TypeFonction" = upper(unaccent(typefonction))))
			and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null);
			if(nb != 0) then 
				annee := i;
				nbM := nb;
				return next;
			end if;
		end case;
	end loop;
END;
$BODY$;