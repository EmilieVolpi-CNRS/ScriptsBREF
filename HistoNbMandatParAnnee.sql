REATE OR REPLACE FUNCTION "BREF"."HistoNbMandatParAnnee"(
	)
    RETURNS TABLE(typemandat character varying, annee integer, nbm integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	arr varchar[] := array['CONSEILLER MUNICIPAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER REGIONAL', 'DEPUTE', 'SENATEUR', 'REPRESENTANT AU PARLEMENT EUROPEEN'];
	rec record;
	man varchar;
BEGIN
	foreach man in array arr
	loop
		for rec in select * from "BREF"."HistoNbMandatDistinct"(man, '')	
		loop
			typemandat := man;
			annee := rec.annee;
			nbm := rec.nbm;
			return next;
		end loop;
end loop;
END;
$BODY$;