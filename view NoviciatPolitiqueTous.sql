CREATE OR REPLACE VIEW "BREF"."NoviciatPolitiqueTous"
 AS
 SELECT c."IdIndividu",
    c."IdMandat",
    c."Territoire_IdTerritoire",
    c."DateDebutMandat",
    c."TypeMandat"
   FROM ( SELECT "Individu"."IdIndividu",
            "Mandat"."IdMandat",
            "Mandat"."Territoire_IdTerritoire",
            "Mandat"."DateDebutMandat",
            "TypeMandat"."TypeMandat"
           FROM "BREF"."Mandat"
             JOIN "BREF"."Individu" ON "Individu"."IdIndividu"::text = "Mandat"."Elu_IdIndividu"::text
             JOIN "BREF"."TypeMandat" ON "TypeMandat"."IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat"
          WHERE (("Individu"."IdIndividu"::text, "Mandat"."DateDebutMandat") IN ( SELECT a."IdIndividu",
                    a."DatePremierMandat"
                   FROM ( SELECT "Individu_1"."IdIndividu",
                            date_part('year'::text, age(min("Mandat_1"."DateDebutMandat")::timestamp with time zone, "Individu_1"."DateNaissance"::timestamp with time zone)) AS age,
                            min("Mandat_1"."DateDebutMandat") AS "DatePremierMandat"
                           FROM "BREF"."Individu" "Individu_1"
                             JOIN "BREF"."Mandat" "Mandat_1" ON "Mandat_1"."Elu_IdIndividu"::text = "Individu_1"."IdIndividu"::text
                          GROUP BY "Individu_1"."IdIndividu", "Individu_1"."DateNaissance") a)) AND "Mandat"."TypeDuMandat_IdTypeMandat" <> 3 AND "Individu"."IdIndividu"::text <> '0'::text
        UNION
        ( SELECT "Individu"."IdIndividu",
            "Mandat"."IdMandat",
            "Mandat"."Territoire_IdTerritoire",
            "Mandat"."DateDebutMandat",
            'MAIRE'::character varying AS "TypeMandat"
           FROM "BREF"."Mandat"
             JOIN "BREF"."Individu" ON "Individu"."IdIndividu"::text = "Mandat"."Elu_IdIndividu"::text
             JOIN "BREF"."TypeMandat" ON "TypeMandat"."IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat"
          WHERE (("Individu"."IdIndividu"::text, "Mandat"."DateDebutMandat") IN ( SELECT a."IdIndividu",
                    a."DatePremierMandat"
                   FROM ( SELECT "Individu_1"."IdIndividu",
                            date_part('year'::text, age(min("Mandat_1"."DateDebutMandat")::timestamp with time zone, "Individu_1"."DateNaissance"::timestamp with time zone)) AS age,
                            min("Mandat_1"."DateDebutMandat") AS "DatePremierMandat"
                           FROM "BREF"."Individu" "Individu_1"
                             JOIN "BREF"."Mandat" "Mandat_1" ON "Mandat_1"."Elu_IdIndividu"::text = "Individu_1"."IdIndividu"::text
                             JOIN "BREF"."Fonction" ON "Fonction"."IdMandat" = "Mandat_1"."IdMandat"
                          WHERE "Mandat_1"."TypeDuMandat_IdTypeMandat" = 4 AND "Fonction"."TypeDeFonction_IdTypeFonction" = 46
                          GROUP BY "Individu_1"."IdIndividu", "Individu_1"."DateNaissance") a)) AND "Individu"."IdIndividu"::text <> '0'::text
          ORDER BY "Individu"."IdIndividu", "Mandat"."DateDebutMandat")) c
  WHERE ((c."IdIndividu"::text, c."DateDebutMandat", c."TypeMandat"::text) IN ( SELECT b."IdIndividu",
            min(b."DateDebutMandat") AS "DateDebutMandat",
            min(b."TypeMandat"::text) AS "TypeMandat"
           FROM (( SELECT "Individu"."IdIndividu",
                    "Mandat"."IdMandat",
                    "Mandat"."Territoire_IdTerritoire",
                    "Mandat"."DateDebutMandat",
                    "TypeMandat"."TypeMandat"
                   FROM "BREF"."Mandat"
                     JOIN "BREF"."Individu" ON "Individu"."IdIndividu"::text = "Mandat"."Elu_IdIndividu"::text
                     JOIN "BREF"."TypeMandat" ON "TypeMandat"."IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat"
                  WHERE (("Individu"."IdIndividu"::text, "Mandat"."DateDebutMandat") IN ( SELECT a."IdIndividu",
                            a."DatePremierMandat"
                           FROM ( SELECT "Individu_1"."IdIndividu",
                                    date_part('year'::text, age(min("Mandat_1"."DateDebutMandat")::timestamp with time zone, "Individu_1"."DateNaissance"::timestamp with time zone)) AS age,
                                    min("Mandat_1"."DateDebutMandat") AS "DatePremierMandat"
                                   FROM "BREF"."Individu" "Individu_1"
                                     JOIN "BREF"."Mandat" "Mandat_1" ON "Mandat_1"."Elu_IdIndividu"::text = "Individu_1"."IdIndividu"::text
                                  GROUP BY "Individu_1"."IdIndividu", "Individu_1"."DateNaissance") a)) AND "Mandat"."TypeDuMandat_IdTypeMandat" <> 3 AND "Individu"."IdIndividu"::text <> '0'::text
                  ORDER BY "Individu"."IdIndividu", "Mandat"."DateDebutMandat", "TypeMandat"."TypeMandat")
                UNION
                ( SELECT "Individu"."IdIndividu",
                    "Mandat"."IdMandat",
                    "Mandat"."Territoire_IdTerritoire",
                    "Mandat"."DateDebutMandat",
                    'MAIRE'::character varying AS "TypeMandat"
                   FROM "BREF"."Mandat"
                     JOIN "BREF"."Individu" ON "Individu"."IdIndividu"::text = "Mandat"."Elu_IdIndividu"::text
                     JOIN "BREF"."TypeMandat" ON "TypeMandat"."IdTypeMandat" = "Mandat"."TypeDuMandat_IdTypeMandat"
                  WHERE (("Individu"."IdIndividu"::text, "Mandat"."DateDebutMandat") IN ( SELECT a."IdIndividu",
                            a."DatePremierMandat"
                           FROM ( SELECT "Individu_1"."IdIndividu",
                                    date_part('year'::text, age(min("Mandat_1"."DateDebutMandat")::timestamp with time zone, "Individu_1"."DateNaissance"::timestamp with time zone)) AS age,
                                    min("Mandat_1"."DateDebutMandat") AS "DatePremierMandat"
                                   FROM "BREF"."Individu" "Individu_1"
                                     JOIN "BREF"."Mandat" "Mandat_1" ON "Mandat_1"."Elu_IdIndividu"::text = "Individu_1"."IdIndividu"::text
                                     JOIN "BREF"."Fonction" ON "Fonction"."IdMandat" = "Mandat_1"."IdMandat"
                                  WHERE "Mandat_1"."TypeDuMandat_IdTypeMandat" = 4 AND "Fonction"."TypeDeFonction_IdTypeFonction" = 46
                                  GROUP BY "Individu_1"."IdIndividu", "Individu_1"."DateNaissance") a)) AND "Individu"."IdIndividu"::text <> '0'::text
                  ORDER BY "Individu"."IdIndividu", "Mandat"."DateDebutMandat")) b
          GROUP BY b."IdIndividu"));
