CREATE OR REPLACE VIEW "BREF"."ViewNuancePolitique"
 AS
 SELECT "NuancePolitique"."IdNuancePolitique" AS "NP_IdNuancePolitique",
    "NuancePolitique"."NuancePolitique"
   FROM "BREF"."NuancePolitique";
