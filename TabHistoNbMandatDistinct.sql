CREATE OR REPLACE FUNCTION "BREF"."TabHistoNbMandatDistinct"(
	)
    RETURNS TABLE(mandat character varying, annee integer, nbm integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
	arr varchar[] := array['CONSEILLER MUNICIPAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER REGIONAL', 'DEPUTE', 'SENATEUR', 'REPRESENTANT AU PARLEMENT EUROPEEN'];
	man varchar;
	rec record;
BEGIN
  foreach man in array arr
  LOOP
  	raise NOTICE '%',man;
  	mandat := man;
	for rec in
  		SELECT * from "BREF"."HistoNbMandatDistinct"(man,'')
	loop
		annee := rec."annee";
		nbm := rec."nbm";
		return next;
	end loop;
  END LOOP;
END;
$BODY$;
