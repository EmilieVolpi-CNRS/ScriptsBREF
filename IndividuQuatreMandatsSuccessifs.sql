CREATE OR REPLACE FUNCTION "BREF"."IndividuQuatreMandatsSuccessifs"(
	)
    RETURNS TABLE(idindividu character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
declare
rec record;
cmp int;
id_indiv varchar;
type_mandat varchar;
date_fin date;
BEGIN
id_indiv = '';
type_mandat= '';
for rec in 
	select "IdIndividu", A."TypeMandat", "IdMandat", "DateDebutMandat", "DateFinMandat"
	from
		(
		select "IdIndividu", "TypeMandat", count("IdMandat") as countmandat from "BREF"."Mandat"
		join "BREF"."Individu" on "BREF"."Individu"."IdIndividu" = "BREF"."Mandat"."Elu_IdIndividu"
		join "BREF"."TypeMandat" on "BREF"."TypeMandat"."IdTypeMandat" = "BREF"."Mandat"."TypeDuMandat_IdTypeMandat"
		group by "IdIndividu", "TypeMandat"
		having count("IdMandat") = 4 --2279 individus
		)A
	join "BREF"."Mandat" on "BREF"."Mandat"."Elu_IdIndividu" = A."IdIndividu"
	join "BREF"."TypeMandat" on "BREF"."TypeMandat"."TypeMandat" = A."TypeMandat" and "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
	order by "IdIndividu", "DateDebutMandat"
loop
--chaque individu enchaine trois mandats = 4 occurence d'un même individu
	if id_indiv != rec."IdIndividu" or type_mandat != rec."TypeMandat" then
		id_indiv = rec."IdIndividu";
		type_mandat = rec."TypeMandat";
		date_fin = rec."DateFinMandat";
		cmp = 1; --1° occurence de l'individu
	else 
		if date_fin = rec."DateDebutMandat" or date_fin + 1 = rec."DateDebutMandat" or date_fin + 2 = rec."DateDebutMandat" then --si les mandats s'enchainent
			if cmp = 1 then  --2° occurence de l'individu
				cmp = 2;
			elsif cmp = 2 then --3° occurence de l'individu
				cmp = 3;
			elsif cmp = 3 then --4° occurence de l'individu
				idindividu := id_indiv;
				return next;
				cmp = 0;
			else
				cmp = 0;
			end if;
			date_fin = rec."DateFinMandat";
		else cmp = 0;
		end if;
	end if;
end loop;

END;
$BODY$;