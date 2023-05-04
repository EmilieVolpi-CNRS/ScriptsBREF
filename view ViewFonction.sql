CREATE OR REPLACE VIEW "BREF"."ViewFonction"
 AS
 SELECT "Fonction"."IdFonction",
    "Fonction"."DateDebutFonction",
    "Fonction"."DateFinFonction",
    "Fonction"."MotifFinFonction",
    "Fonction"."TypeDeFonction_IdTypeFonction",
    "Fonction"."IdMandat" AS "Fonction_IdMandat"
   FROM "BREF"."Fonction";