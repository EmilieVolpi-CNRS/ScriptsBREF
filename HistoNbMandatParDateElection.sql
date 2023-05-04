CREATE OR REPLACE FUNCTION "BREF"."HistoNbMandatParDateElection"(
	anneedebut integer)
    RETURNS TABLE(typemandat character varying, dateelection date, nbm integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
arr varchar[] := array['DEPUTE', 'SENATEUR', 'REPRESENTANT AU PARLEMENT EUROPEEN',  'CONSEILLER REGIONAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER MUNICIPAL'];
date_rec record;
man varchar;
mindate date;
maxdate date;
nb int;
BEGIN
	foreach man in array arr
	loop
		typemandat := man;
		
		for date_rec in
			select "Date" from "BREF"."SuffrageElection" where "Election" = 
				(select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat"= man)
			and "Date" >= to_date('01/01/'||anneedebut, 'DD/MM/YYYY')
			and "Tour" = 1
			order by "Date" asc
		loop
			mindate = date_rec."Date";
			maxdate = mindate + 30;
		
			select into nb count(distinct "IdMandat")
			from "BREF"."Mandat"
			where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = man)
			and "DateDebutMandat" >= mindate and "DateDebutMandat" <= maxdate
			and ("DateFinMandat" > maxdate or "DateFinMandat" is null);
			
			dateelection := mindate;
			nbM := nb;
			return next;
		end loop;
	end loop;
END;
$BODY$;


