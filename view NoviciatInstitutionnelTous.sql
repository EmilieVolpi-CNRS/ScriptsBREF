CREATE OR REPLACE VIEW "BREF"."NoviciatInstitutionnelTous"
 AS
 SELECT "Individu"."IdIndividu",
    "TypeMandat"."TypeMandat",
	"Mandat"."IdMandat",
	"Mandat"."Territoire_IdTerritoire",
    "Mandat"."DateDebutMandat"
   FROM (("BREF"."Mandat"
     JOIN "BREF"."Individu" ON ((("Individu"."IdIndividu")::text = ("Mandat"."Elu_IdIndividu")::text)))
     JOIN "BREF"."TypeMandat" ON (("TypeMandat"."IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat")))
  WHERE (((("Individu"."IdIndividu")::text, "Mandat"."DateDebutMandat", "Mandat"."TypeDuMandat_IdTypeMandat") IN ( SELECT a."IdIndividu",
            a."DatePremierMandat",
            a."TypeDuMandat_IdTypeMandat"
           FROM ( SELECT "Individu_1"."IdIndividu",
                    date_part('year'::text, age((min("Mandat_1"."DateDebutMandat"))::timestamp with time zone, ("Individu_1"."DateNaissance")::timestamp with time zone)) AS age,
                    min("Mandat_1"."DateDebutMandat") AS "DatePremierMandat",
                    "Mandat_1"."TypeDuMandat_IdTypeMandat"
                   FROM ("BREF"."Individu" "Individu_1"
                     JOIN "BREF"."Mandat" "Mandat_1" ON ((("Mandat_1"."Elu_IdIndividu")::text = ("Individu_1"."IdIndividu")::text)))
                  GROUP BY "Individu_1"."IdIndividu", "Individu_1"."DateNaissance", "Mandat_1"."TypeDuMandat_IdTypeMandat") a)) AND ("Mandat"."TypeDuMandat_IdTypeMandat" <> 3) AND (("Individu"."IdIndividu")::text <> '0'::text))
  ORDER BY "Individu"."IdIndividu", "TypeMandat"."TypeMandat", "Mandat"."DateDebutMandat";