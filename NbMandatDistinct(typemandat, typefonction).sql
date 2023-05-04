CREATE OR REPLACE FUNCTION "BREF"."NbMandatDistinct"(
	typemandat character varying,
	typefonction character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
nb int;
BEGIN
case typefonction 
when '' then
	select into nb count(distinct "IdMandat")
	from "BREF"."Mandat"
	where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = upper(unaccent(typemandat)));
else
	select into nb count(distinct "IdMandat")
	from "BREF"."Mandat"
	where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
														 where "TypeMandat" = upper(unaccent(typemandat)))
	and "BREF"."Mandat"."IdMandat" in (select "IdMandat" from "BREF"."Fonction"
									  where "TypeDeFonction_IdTypeFonction" = (select "IdTypeFonction" from "BREF"."TypeFonction"
																			  where "TypeFonction" = upper(unaccent(typefonction))));
end case;
return nb;
END;
$BODY$;