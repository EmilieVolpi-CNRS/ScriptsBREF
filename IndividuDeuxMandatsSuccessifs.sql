CREATE OR REPLACE FUNCTION "BREF"."IndividuDeuxMandatsSuccessifs"(
	)
    RETURNS TABLE(idindividu character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
rec record;
id_indiv varchar;
date_fin date;
BEGIN
id_indiv = '';
for rec in 
	select "IdIndividu", "IdMandat", "DateDebutMandat", "DateFinMandat"
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 2
		)A
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."TypeMandat" = A."TypeMandat" and "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
	order by "IdIndividu", "DateDebutMandat"
loop
	if id_indiv != rec."IdIndividu" then
		id_indiv = rec."IdIndividu";
		date_fin = rec."DateFinMandat";
	else 
		if date_fin = rec."DateDebutMandat" or date_fin + 1 = rec."DateDebutMandat" then
			idindividu := id_indiv;
			return next;
		end if;
	end if;
end loop;

END;
$BODY$;