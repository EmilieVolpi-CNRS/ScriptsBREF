CREATE OR REPLACE FUNCTION "BREF"."Cumul2"(
	)
    RETURNS TABLE(mandat character varying, annee integer, nbm integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 2000
AS $BODY$
DECLARE
	arr varchar[] := array['CONSEILLER EPCI', 'CONSEILLER MUNICIPAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER REGIONAL', 'DEPUTE', 'SENATEUR', 'REPRESENTANT AU PARLEMENT EUROPEEN'];
	--arr varchar[] := array['CONSEILLER EPCI', 'CONSEILLER MUNICIPAL', 'CONSEILLER DEPARTEMENTAL', 'CONSEILLER REGIONAL'];
	listemandatscumuls varchar array;
	count_liste int; 
	man1 varchar;
	man2 varchar;
	man3 varchar;
	man4 varchar;
	man varchar;
	mindate1 date;
	mindate2 date;
	mindate3 date;
	mindate4 date;
	maxdate1 date;
	maxdate2 date;
	maxdate3 date;
	maxdate4 date;
	minannee int;
	maxannee int;
	nb int;
	i int;
	ok bool;
	okliste bool;
BEGIN

	--deux mandats cumulés
	count_liste := 0;
	foreach man1 in array arr
	loop
		foreach man2 in array arr
		loop
			if man1 != man2 then 
		
				man = man1 || '/' || man2;
				
				--on cherche l'année à partir de laquelle et jusqu'à laquelle on cherche le cumu
				select min("DateDebutMandat"), max("DateFinMandat")
				into mindate1, maxdate1
				from "BREF"."Mandat"
				where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																	 where "TypeMandat" = man1);
				select min("DateDebutMandat"), max("DateFinMandat")
				into mindate2, maxdate2
				from "BREF"."Mandat"
				where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																	 where "TypeMandat" = man2);
				if mindate1 > mindate2 then
					if date_part('month', mindate1) = 1 then minannee = date_part('year', mindate1);
					else minannee = date_part('year', mindate1)+1;
					end if;
				else
					if date_part('month', mindate2) = 1 then minannee = date_part('year', mindate2);
					else minannee = date_part('year', mindate2)+1;
					end if;
				end if;
				
				if maxdate1 < maxdate2 then
					if date_part('month', maxdate1) = 1 then maxannee = date_part('year', maxdate1)-1;
					else maxannee = date_part('year', maxdate1);
					end if;
				else
					if date_part('month', maxdate2) = 1 then maxannee = date_part('year', maxdate2)-1;
					else maxannee = date_part('year', maxdate2);
					end if;
				end if;
				
				--pour toutes les années possibles de cumul
				for i in minannee..maxannee loop
					nb = 0;
					select into nb count(A."IdIndividu") from
					(select "Individu"."IdIndividu"
					from "BREF"."Mandat"
					join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
					where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
						where "TypeMandat" = upper(unaccent(man1)))
					and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
					) A
					inner join
					(select "Individu"."IdIndividu"
					from "BREF"."Mandat"
					join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
					where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
						where "TypeMandat" = upper(unaccent(man2)))
					and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
					) B
					on A."IdIndividu" = B."IdIndividu";
					
					--si il y a bien un cumul on cherche si on a pas déjà enregistré ce type de cumul, sinon on l'enregistre
					if nb != 0 then 
						ok := true;
						
						if (count_liste >= 1)then
							for i in 1..count_liste 
							loop
								if listemandatscumuls[i] = man2 || '/' || man1 then
									ok := false;
									exit;
								end if;
							end loop;
						end if;
						
						if ok = true then
					
							if(count_liste = 0) then
								count_liste := 1;
								listemandatscumuls[count_liste] := man;
							else
								
								--si l'association de mandat en cours n'est pas encore dans la liste, on l'ajoute
								okliste := true;
								
								for i in 1..count_liste 
								loop
									if listemandatscumuls[i] = man then
										okliste := false;
										exit;
									end if;
								end loop;
							
								if okliste = true then
									count_liste := count_liste+1;
									listemandatscumuls[count_liste] := man;
								end if;
							end if;

							mandat := man;
							annee := i;
							nbM := nb;

							return next;	
						end if;
					end if;
				end loop;
			end if;
		end loop;
	end loop;

	-- trois mandats cumulés
	ok := false;
	for i in 1..count_liste 
	loop
		listemandatscumuls[i] = '';
	end loop;
	count_liste := 0;
	
	foreach man1 in array arr
	loop
		foreach man2 in array arr
		loop
			foreach man3 in array arr
			loop
				if man1 != man2 and man1 != man3 and man2 != man3 then 

					man = man1 || '/' || man2 || '/' || man3;

					--on cherche l'année à partir de laquelle et jusqu'à laquelle on cherche le cumu
					select min("DateDebutMandat"), max("DateFinMandat")
					into mindate1, maxdate1
					from "BREF"."Mandat"
					where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																		 where "TypeMandat" = man1);
					select min("DateDebutMandat"), max("DateFinMandat")
					into mindate2, maxdate2
					from "BREF"."Mandat"
					where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																		 where "TypeMandat" = man2);
					select min("DateDebutMandat"), max("DateFinMandat")
					into mindate3, maxdate3
					from "BREF"."Mandat"
					where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																		 where "TypeMandat" = man3);
					if mindate1 > mindate2 and mindate1 > mindate3 then
						if date_part('month', mindate1) = 1 then minannee = date_part('year', mindate1);
						else minannee = date_part('year', mindate1)+1;
						end if;
					elsif mindate2 > mindate1 and mindate2 > mindate3 then
						if date_part('month', mindate2) = 1 then minannee = date_part('year', mindate2);
						else minannee = date_part('year', mindate2)+1;
						end if;
					else
						if date_part('month', mindate3) = 1 then minannee = date_part('year', mindate3);
						else minannee = date_part('year', mindate3)+1;
						end if;
					end if;

					if maxdate1 < maxdate2 and maxdate1 < maxdate3 then
						if date_part('month', maxdate1) = 1 then maxannee = date_part('year', maxdate1)-1;
						else maxannee = date_part('year', maxdate1);
						end if;
					elsif maxdate2 < maxdate1 and maxdate2 < maxdate3 then
						if date_part('month', maxdate2) = 1 then maxannee = date_part('year', maxdate2)-1;
						else maxannee = date_part('year', maxdate2);
						end if;
					else
						if date_part('month', maxdate3) = 1 then maxannee = date_part('year', maxdate3)-1;
						else maxannee = date_part('year', maxdate3);
						end if;
					end if;

					raise notice 'man %', man;
					raise notice 'min % max %', minannee, maxannee;

					--pour toutes les années possibles de cumul
					for i in minannee..maxannee loop
						nb = 0;
						select into nb count(A."IdIndividu") from
						(select "Individu"."IdIndividu"
						from "BREF"."Mandat"
						join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
							where "TypeMandat" = upper(unaccent(man1)))
						and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
						) A
						inner join
						(select "Individu"."IdIndividu"
						from "BREF"."Mandat"
						join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
							where "TypeMandat" = upper(unaccent(man2)))
						and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
						) B
						on A."IdIndividu" = B."IdIndividu"
						inner join
						(select "Individu"."IdIndividu"
						from "BREF"."Mandat"
						join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
							where "TypeMandat" = upper(unaccent(man3)))
						and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
						) C
						on B."IdIndividu" = C."IdIndividu";

						--si il y a bien un cumul on cherche si on a pas déjà enregistré ce type de cumul, sinon on l'enregistre
						if nb != 0 then 
							raise notice 'count_liste %', count_liste;
							ok := true;
							
							if (count_liste >= 1)then
								for i in 1..count_liste 
								loop	
								
									--raise notice 'on rentre liste[%] : %', i, listemandatscumuls[i];
									--raise notice '%', man2 || '/' || man1;
									
									if ((listemandatscumuls[i] = man1 || '/' || man3 || '/' || man2)
									or (listemandatscumuls[i] = man2 || '/' || man1 || '/' || man3)
									or (listemandatscumuls[i] = man2 || '/' || man3 || '/' || man1)
									or (listemandatscumuls[i] = man3 || '/' || man1 || '/' || man2)
									or (listemandatscumuls[i] = man3 || '/' || man2 || '/' || man1))
									then
										--raise notice 'false % - %', listemandatscumuls[i], man2 || '/' || man1;
										ok := false;
										exit;
									end if;
								end loop;
							end if;

							if ok = true then

								if(count_liste = 0) then
									count_liste := 1;
									listemandatscumuls[count_liste] := man;
								else
									--raise notice 'listemandatscumuls[%] %',i, listemandatscumuls[i];
									--raise notice 'man %', man;

									--si l'association de mandat en cours n'est pas encore dans la liste, on l'ajoute
									okliste := true;

									for i in 1..count_liste 
									loop
										if listemandatscumuls[i] = man then
											okliste := false;
											--raise notice 'okliste false';
											exit;
										end if;
									end loop;

									if okliste = true then
										count_liste := count_liste+1;
										listemandatscumuls[count_liste] := man;
									end if;
								end if;

								mandat := man;
								annee := i;
								nbM := nb;

								return next;	
							end if;
						end if;
					end loop;
				end if;
			end loop;
		end loop;
	end loop;

	-- quatre mandats cumulés
	ok := false;
	for i in 1..count_liste 
	loop
		listemandatscumuls[i] = '';
	end loop;
	count_liste := 0;
	
	foreach man1 in array arr
	loop
		foreach man2 in array arr
		loop
			foreach man3 in array arr
			loop
				foreach man4 in array arr
				loop
					if man1 != man2 and man1 != man3 and man1 != man4 and man2 != man3 and man2 != man4 and man3 != man4 then 

						man = man1 || '/' || man2 || '/' || man3 || '/' || man4;

						--on cherche l'année à partir de laquelle et jusqu'à laquelle on cherche le cumu
						select min("DateDebutMandat"), max("DateFinMandat")
						into mindate1, maxdate1
						from "BREF"."Mandat"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																			 where "TypeMandat" = man1);
						select min("DateDebutMandat"), max("DateFinMandat")
						into mindate2, maxdate2
						from "BREF"."Mandat"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																			 where "TypeMandat" = man2);
						select min("DateDebutMandat"), max("DateFinMandat")
						into mindate3, maxdate3
						from "BREF"."Mandat"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																			 where "TypeMandat" = man3);
						select min("DateDebutMandat"), max("DateFinMandat")
						into mindate4, maxdate4
						from "BREF"."Mandat"
						where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
																			 where "TypeMandat" = man4);
						if mindate1 > mindate2 and mindate1 > mindate3 and mindate1 > mindate4 then
							if date_part('month', mindate1) = 1 then minannee = date_part('year', mindate1);
							else minannee = date_part('year', mindate1)+1;
							end if;
						elsif mindate2 > mindate1 and mindate2 > mindate3 and mindate2 > mindate4 then
							if date_part('month', mindate2) = 1 then minannee = date_part('year', mindate2);
							else minannee = date_part('year', mindate2)+1;
							end if;
						elsif mindate3 > mindate1 and mindate3 > mindate2 and mindate3 > mindate4 then
							if date_part('month', mindate3) = 1 then minannee = date_part('year', mindate3);
							else minannee = date_part('year', mindate3)+1;
							end if;
						else
							if date_part('month', mindate4) = 1 then minannee = date_part('year', mindate4);
							else minannee = date_part('year', mindate4)+1;
							end if;
						end if;

						if maxdate1 < maxdate2 and maxdate1 < maxdate3 and maxdate1 < maxdate4 then
							if date_part('month', maxdate1) = 1 then maxannee = date_part('year', maxdate1)-1;
							else maxannee = date_part('year', maxdate1);
							end if;
						elsif maxdate2 < maxdate1 and maxdate2 < maxdate3 and maxdate2 < maxdate4 then
							if date_part('month', maxdate2) = 1 then maxannee = date_part('year', maxdate2)-1;
							else maxannee = date_part('year', maxdate2);
							end if;
						elsif maxdate3 < maxdate1 and maxdate3 < maxdate2 and maxdate3 < maxdate4 then
							if date_part('month', maxdate3) = 1 then maxannee = date_part('year', maxdate3)-1;
							else maxannee = date_part('year', maxdate3);
							end if;
						else
							if date_part('month', maxdate4) = 1 then maxannee = date_part('year', maxdate4)-1;
							else maxannee = date_part('year', maxdate4);
							end if;
						end if;

						raise notice 'man %', man;
						raise notice 'min % max %', minannee, maxannee;

						--pour toutes les années possibles de cumul
						for i in minannee..maxannee loop
							nb = 0;
							select into nb count(A."IdIndividu") from
							(select "Individu"."IdIndividu"
							from "BREF"."Mandat"
							join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
							where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
								where "TypeMandat" = upper(unaccent(man1)))
							and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
							) A
							inner join
							(select "Individu"."IdIndividu"
							from "BREF"."Mandat"
							join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
							where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
								where "TypeMandat" = upper(unaccent(man2)))
							and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
							) B
							on A."IdIndividu" = B."IdIndividu"
							inner join
							(select "Individu"."IdIndividu"
							from "BREF"."Mandat"
							join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
							where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
								where "TypeMandat" = upper(unaccent(man3)))
							and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
							) C
							on B."IdIndividu" = C."IdIndividu"
							inner join
							(select "Individu"."IdIndividu"
							from "BREF"."Mandat"
							join "BREF"."Individu" on "Individu"."IdIndividu" = "Mandat"."Elu_IdIndividu"
							where "BREF"."Mandat"."TypeDuMandat_IdTypeMandat" = (select "IdTypeMandat" from "BREF"."TypeMandat"
								where "TypeMandat" = upper(unaccent(man4)))
							and "DateDebutMandat" < to_date('01/02/'||i, 'DD/MM/YYYY') and ("DateFinMandat" > to_date('01/02/'||i, 'DD/MM/YYYY') or "DateFinMandat" is null)
							) D
							on C."IdIndividu" = D."IdIndividu";

							--si il y a bien un cumul on cherche si on a pas déjà enregistré ce type de cumul, sinon on l'enregistre
							if nb != 0 then 
								raise notice 'count_liste %', count_liste;
								ok := true;

								if (count_liste >= 1)then
									for i in 1..count_liste 
									loop	

										raise notice 'on rentre liste[%] : %', i, listemandatscumuls[i];
										raise notice '%', man2 || '/' || man1;

										if ((listemandatscumuls[i] = man1 || '/' || man2 || '/' || man4 || '/' || man3)
										or (listemandatscumuls[i] = man1 || '/' || man3 || '/' || man2 || '/' || man4)
										or (listemandatscumuls[i] = man1 || '/' || man3 || '/' || man4 || '/' || man2)
										or (listemandatscumuls[i] = man1 || '/' || man4 || '/' || man2 || '/' || man3)
										or (listemandatscumuls[i] = man1 || '/' || man4 || '/' || man3 || '/' || man2)
										or (listemandatscumuls[i] = man2 || '/' || man1 || '/' || man3 || '/' || man4)
										or (listemandatscumuls[i] = man2 || '/' || man1 || '/' || man4 || '/' || man3)	
										or (listemandatscumuls[i] = man2 || '/' || man3 || '/' || man1 || '/' || man4)
										or (listemandatscumuls[i] = man2 || '/' || man3 || '/' || man4 || '/' || man1)
										or (listemandatscumuls[i] = man2 || '/' || man4 || '/' || man1 || '/' || man3)
										or (listemandatscumuls[i] = man2 || '/' || man4 || '/' || man3 || '/' || man1)
										or (listemandatscumuls[i] = man3 || '/' || man1 || '/' || man2 || '/' || man4)
										or (listemandatscumuls[i] = man3 || '/' || man1 || '/' || man4 || '/' || man2)
										or (listemandatscumuls[i] = man3 || '/' || man2 || '/' || man1 || '/' || man4)
										or (listemandatscumuls[i] = man3 || '/' || man2 || '/' || man4 || '/' || man1)
										or (listemandatscumuls[i] = man3 || '/' || man4 || '/' || man1 || '/' || man2)
										or (listemandatscumuls[i] = man3 || '/' || man4 || '/' || man2 || '/' || man4)
										or (listemandatscumuls[i] = man4 || '/' || man1 || '/' || man2 || '/' || man3)
										or (listemandatscumuls[i] = man4 || '/' || man1 || '/' || man3 || '/' || man2)
										or (listemandatscumuls[i] = man4 || '/' || man2 || '/' || man3 || '/' || man4)
										or (listemandatscumuls[i] = man4 || '/' || man2 || '/' || man4 || '/' || man3)
										or (listemandatscumuls[i] = man4 || '/' || man3 || '/' || man1 || '/' || man2)
										or (listemandatscumuls[i] = man4 || '/' || man3 || '/' || man2 || '/' || man1))
										then
											raise notice 'false % - %', listemandatscumuls[i], man2 || '/' || man1;
											ok := false;
											exit;
										end if;
									end loop;
								end if;

								if ok = true then

									if(count_liste = 0) then
										count_liste := 1;
										listemandatscumuls[count_liste] := man;
									else
										raise notice 'listemandatscumuls[%] %',i, listemandatscumuls[i];
										raise notice 'man %', man;

										--si l'association de mandat en cours n'est pas encore dans la liste, on l'ajoute
										okliste := true;

										for i in 1..count_liste 
										loop
											if listemandatscumuls[i] = man then
												okliste := false;
												raise notice 'okliste false';
												exit;
											end if;
										end loop;

										if okliste = true then
											count_liste := count_liste+1;
											listemandatscumuls[count_liste] := man;
										end if;
									end if;

									mandat := man;
									annee := i;
									nbM := nb;

									return next;	
								end if;
							end if;
						end loop;
					end if;
				end loop;
			end loop;
		end loop;
	end loop;

END;
$BODY$;
