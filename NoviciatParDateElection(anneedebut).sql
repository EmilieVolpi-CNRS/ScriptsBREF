CREATE OR REPLACE FUNCTION "BREF"."NoviciatParDateElection"(
	anneedebut integer)
    RETURNS TABLE(typemandat character varying, dateelection date, id_individu character varying, nom_naissance character varying, prenom character varying, sexe character varying, date_naissance date,
			id_mandat integer, nom_territoire character varying, date_debut_mandat date, date_fin_mandat date, motif_fin_mandat character varying, libelle_profession character varying, nuance_politique character varying,
			date_debut_mandat_noviciat_pol date, type_mandat_noviciat_pol character varying, nom_territoire_mandat_noviciat_pol character varying,
			date_debut_mandat_noviciat_inst date, type_mandat_noviciat_inst character varying, nom_territoire_mandat_noviciat_inst character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
arr varchar[] := array['DEPUTE', 'SENATEUR', 'REPRESENTANT AU PARLEMENT EUROPEEN',  'CONSEILLER REGIONAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER MUNICIPAL'];
date_rec record;
rec record;
man varchar;
mindate date;
maxdate date;
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
			dateelection := mindate;
			for rec in
				select "Individu"."IdIndividu", "NomDeNaissance", "Prenom", "Sexe", "DateNaissance",
				"Mandat"."IdMandat", T1."NomTerritoire", "Mandat"."DateDebutMandat", "Mandat"."DateFinMandat", "Mandat"."MotifFinMandat", "LibelleProfession", "NuancePolitique",
				N1."DateDebutMandat" as "DateDebutMandatNoviciatPol", N1."TypeMandat" as "TypeMandatP", T2."NomTerritoire" as "NomTerritoireP",
				N2."DateDebutMandat" as "DateDebutMandatNoviciatInst", N2."TypeMandat" as "TypeMandatI", T3."NomTerritoire" as "NomTerritoireI"
				from "BREF"."Mandat"
				join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu" 
				join "BREF"."Territoire" T1 on T1."IdTerritoire" = "Mandat"."Territoire_IdTerritoire"
				left join "BREF"."Profession" on "Profession"."CodeProfession" = "Mandat"."IdProfession"
				left join "BREF"."NuancePolitique" on "NuancePolitique"."IdNuancePolitique" = "Mandat"."IdNuancePolitique"
				left join "BREF"."NoviciatPolitiqueTous" N1 on N1."IdIndividu" = "Individu"."IdIndividu"
				left join "BREF"."Territoire" T2 on T2."IdTerritoire" = N1."Territoire_IdTerritoire"
				left join "BREF"."NoviciatInstitutionnelTous" N2 on N2."IdIndividu" = "Individu"."IdIndividu"
					and N2."TypeMandat" = (select "TypeMandat" from "BREF"."TypeMandat" where "IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat")
				left join "BREF"."Territoire" T3 on T3."IdTerritoire" = N2."Territoire_IdTerritoire"
				where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat" where "TypeMandat" = man)
				and "Mandat"."DateDebutMandat" >= mindate and "Mandat"."DateDebutMandat" <= maxdate
				and ("Mandat"."DateFinMandat" > maxdate or "Mandat"."DateFinMandat" is null)
				order by "NomDeNaissance"
			loop
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
	end loop;
END;
$BODY$;