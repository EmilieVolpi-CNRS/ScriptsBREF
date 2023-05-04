CREATE OR REPLACE FUNCTION "BREF"."NoviciatMaireParDateElection"(
	anneedebut integer)
    RETURNS TABLE(typefonction character varying, dateelection date, id_individu character varying, nom_naissance character varying, prenom character varying, sexe character varying, date_naissance date, id_mandat integer, nom_territoire character varying, date_debut_mandat date, date_fin_mandat date, motif_fin_mandat character varying, libelle_profession character varying, nuance_politique character varying, date_debut_mandat_noviciat_pol date, type_mandat_noviciat_pol character varying, nom_territoire_mandat_noviciat_pol character varying, date_debut_mandat_noviciat_inst date, type_mandat_noviciat_inst character varying, nom_territoire_mandat_noviciat_inst character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
date_rec record;
rec record;
mindate date;
maxdate date;
BEGIN
	for date_rec in
		select "Date" from "BREF"."SuffrageElection" 
		where "Date" >= to_date('01/01/'||anneedebut, 'DD/MM/YYYY')
		and "Election" = 4
		and "Tour" = 1
		order by "Date" asc
	loop
		mindate = date_rec."Date";
-- 		maxdate = mindate + 30;
		dateelection := mindate;
		
		-- special case for the 2020 municipal election
		if (mindate = '2020-03-15')
		then
			select into dateelection "Date" 
				from "BREF"."SuffrageElection" 
				where "Election" = 4
				and "Date" >= mindate
				and "Tour" = 2
				order by "Date"
				limit 1;				
		end if;
			
		maxdate = dateelection + 30;
		
		for rec in
			select "Individu"."IdIndividu", "NomDeNaissance", "Prenom", "Sexe", "DateNaissance", "TypeFonction",
			"Mandat"."IdMandat", T1."NomTerritoire", "Mandat"."DateDebutMandat", "Mandat"."DateFinMandat", "Mandat"."MotifFinMandat", "LibelleProfession", "NuancePolitique",
			N1."DateDebutMandat" as "DateDebutMandatNoviciatPol", N1."TypeMandat" as "TypeMandatP", T2."NomTerritoire" as "NomTerritoireP",
			N2."DateDebutMandat" as "DateDebutMandatNoviciatInst", N2."TypeMandat" as "TypeMandatI", T3."NomTerritoire" as "NomTerritoireI"
			from "BREF"."Mandat"
			join "BREF"."Fonction" on "Fonction"."IdMandat" = "Mandat"."IdMandat"
			join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu" 
			join "BREF"."Territoire" T1 on T1."IdTerritoire" = "Mandat"."Territoire_IdTerritoire"
			left join "BREF"."Profession" on "Profession"."CodeProfession" = "Mandat"."IdProfession"
			left join "BREF"."NuancePolitique" on "NuancePolitique"."IdNuancePolitique" = "Mandat"."IdNuancePolitique"
			left join "BREF"."NoviciatPolitiqueTous" N1 on N1."IdIndividu" = "Individu"."IdIndividu"
			left join "BREF"."Territoire" T2 on T2."IdTerritoire" = N1."Territoire_IdTerritoire"
			left join "BREF"."NoviciatInstitutionnelTous" N2 on N2."IdIndividu" = "Individu"."IdIndividu"
				and N2."TypeMandat" = (select "TypeMandat" from "BREF"."TypeMandat" where "IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat")
			left join "BREF"."Territoire" T3 on T3."IdTerritoire" = N2."Territoire_IdTerritoire"
			left join "BREF"."TypeFonction" on "IdTypeFonction" = "TypeDeFonction_IdTypeFonction"
			where "Mandat"."DateDebutMandat" >= mindate and "Mandat"."DateDebutMandat" <= maxdate
			and ("Mandat"."DateFinMandat" > maxdate or "Mandat"."DateFinMandat" is null)
			and "Mandat"."TypeDuMandat_IdTypeMandat" = 4
			and "Fonction"."TypeDeFonction_IdTypeFonction" = 46
			order by "NomDeNaissance"
		loop
			typefonction = rec."TypeFonction";
			id_individu = rec."IdIndividu";
			nom_naissance = rec."NomDeNaissance";
			prenom = rec."Prenom";
			sexe = rec."Sexe";
			date_naissance = rec."DateNaissance";
			id_mandat = rec."IdMandat";
			nom_territoire = rec."NomTerritoire";
			date_debut_mandat = rec."DateDebutMandat";
			date_fin_mandat = rec."DateFinMandat";
			motif_fin_mandat = rec."MotifFinMandat";
			libelle_profession  = rec."LibelleProfession";
			nuance_politique = rec."NuancePolitique";
			date_debut_mandat_noviciat_pol = rec."DateDebutMandatNoviciatPol";
			type_mandat_noviciat_pol = rec."TypeMandatP";
			nom_territoire_mandat_noviciat_pol  = rec."NomTerritoireP";
			date_debut_mandat_noviciat_inst  = rec."DateDebutMandatNoviciatInst";
			type_mandat_noviciat_inst = rec."TypeMandatI";
			nom_territoire_mandat_noviciat_inst = rec."NomTerritoireI";
		return next;
		end loop;
	end loop;
END;
$BODY$;
