CREATE OR REPLACE FUNCTION "BREF"."HistoNbMairesParDateElection"(
	anneedebut integer)
    RETURNS TABLE(dateelection date, nbm integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
date_rec record;
mindate date;
maxdate date;
nb int;
BEGIN
	for date_rec in
		select "Date" from "BREF"."SuffrageElection" where "Election" = 4
		and "Date" >= to_date('01/01/'||anneedebut, 'DD/MM/YYYY')
		and "Tour" = 1
		order by "Date" asc
	loop
		mindate = date_rec."Date";
		maxdate = mindate + 30;

		select into nb count(distinct "IdFonction")
		from "BREF"."Fonction"
		where "BREF"."Fonction"."TypeDeFonction_IdTypeFonction" = 46
		and "DateDebutFonction" >= mindate and "DateDebutFonction" <= maxdate
		and ("DateFinFonction" > maxdate or "DateFinFonction" is null);

		dateelection := mindate;
		nbM := nb;
		return next;
	end loop;
END;
$BODY$;
