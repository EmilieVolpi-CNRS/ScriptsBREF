CREATE OR REPLACE FUNCTION "BREF"."ListeTypesMandatsFonctions"(
	)
    RETURNS TABLE("TypeMandat" character varying, "TypeFonction" character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
	BEGIN
RETURN QUERY select distinct "BREF"."TypeMandat"."TypeMandat", "BREF"."TypeFonction"."TypeFonction"
from "BREF"."TypeMandat"
full outer join "BREF"."Mandat" on "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = "BREF"."TypeMandat"."IdTypeMandat"
full outer join "BREF"."Fonction" on "BREF"."Fonction"."IdMandat" = "BREF"."Mandat"."IdMandat"
full outer join "BREF"."TypeFonction" on "BREF"."TypeFonction"."IdTypeFonction" = "BREF"."Fonction"."TypeDeFonction_IdTypeFonction"
order by "BREF"."TypeMandat"."TypeMandat", "BREF"."TypeFonction"."TypeFonction"; 
END;
$BODY$;