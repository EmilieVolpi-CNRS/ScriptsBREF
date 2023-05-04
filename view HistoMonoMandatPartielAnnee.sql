CREATE OR REPLACE VIEW "BREF"."HistoMonoMandatPartielAnnee"
 AS
 SELECT "HistoMonoMandatPartielAnnee".idindividu,
    "HistoMonoMandatPartielAnnee".typemandat,
    "HistoMonoMandatPartielAnnee".dureemandat,
    "HistoMonoMandatPartielAnnee".date_debut_mandat,
    "HistoMonoMandatPartielAnnee".date_fin_mandat
   FROM "BREF"."HistoMonoMandatPartielAnnee"() "HistoMonoMandatPartielAnnee"(idindividu, typemandat, dureemandat, date_debut_mandat, date_fin_mandat);
