CREATE OR REPLACE FUNCTION "BREF"."MonoTypeMandatStrictementSuccessifAutreTypeSimultane"(
	)
    RETURNS TABLE(idindividu character varying, idmandat integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
rec record;
rec2 record;
id_indiv varchar;
datedebutmandat1 date;
datefinmandat2 date;
typemandat int;
BEGIN
id_indiv = '';
for rec in 
	select * from "BREF"."IndividuPlusDeuxMandatsDeuxMandatSuccessifsPlusInfos"
loop
	if id_indiv != rec.idindividu then
		id_indiv = rec.idindividu;
		select "DateDebutMandat", "TypeDuMandat_IdTypeMandat" into datedebutmandat1, typemandat from "BREF"."Mandat" where "IdMandat" = rec.idmandat;
	else 
		select "DateFinMandat" into datefinmandat2 from "BREF"."Mandat" where "IdMandat" = rec.idmandat;
	
		for rec2 in
			select "IdMandat", "DateDebutMandat", "DateFinMandat" from "BREF"."Mandat" 
			where "Elu_IdIndividu" = id_indiv
			and "TypeDuMandat_IdTypeMandat" != typemandat
		loop
			if (rec2."DateDebutMandat" >= datedebutmandat1 and rec2."DateFinMandat" <= datefinmandat2) 
			or (rec2."DateDebutMandat" <= datedebutmandat1 and rec2."DateFinMandat" >= datedebutmandat1 and rec2."DateFinMandat" <= datefinmandat2) 
			or (rec2."DateDebutMandat" >= datedebutmandat1 and rec2."DateDebutMandat" <= datefinmandat2 and rec2."DateFinMandat" >= datefinmandat2)
			or (rec2."DateDebutMandat" <= datedebutmandat1 and rec2."DateFinMandat" >= datefinmandat2) then
				idindividu = id_indiv;
				idmandat = rec2."IdMandat";
				return next;
			end if;
		end loop;
	end if;
end loop;

END;
$BODY$;
