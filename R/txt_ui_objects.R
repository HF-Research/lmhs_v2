ui_main_title <- "Results"
choose_person_type <- enc2utf8("Vælg patient eller pårørende")
person_type_choices <- enc2utf8(c("pat", "paar"))
names(person_type_choices) <- enc2utf8(c("Patient", "Pårørende"))

choose_topic <- enc2utf8("Vælg emne")
choose_question <- enc2utf8("Vælg spørgsmål")
choose_stratification <- enc2utf8("Stratifikationer")

# OUTPUT ------------------------------------------------------------------

ui_plot_title <- "Data"
txt_download <- "Hent"
txt_tab_title_map <- "Kort"
txt_sex <- "Køn"
txt_weighted_helper_title <- "*Hvad betyder \"Vægtet\"?"
txt_weighted_helper <-
  "Andel og antal er vægtet for ikke-deltagelse i fht. køn,
alder og uddannelse."


# ABOUT -------------------------------------------------------------------
ui_about_title <- "Vejledning"
about_selection <- "Vælg emne:"
about_choices <- list("Kort om undersøgelsen" = "general",
                      "Population" = "pop",
                      "Patientspørgeskemaet"="pat")

bullets=list(topics=list(
  b_1="Behandlingen på sygehuset",
  b_2="Kontakten med sundhedspersonalet ",
  b_3="Pårørende",
  b_4="Medicin",
  b_5="Rådgivning og tilbud",
  b_6="Arbejdsliv",
  b_7="Sociale og økonomiske forhold",
  b_8="Hverdagen med en hjertesygdom",
  b_9="Helbred og trivsel samt corona-pandemien."
),
experts=list(
  "Forskningsleder, ph.d. Thomas Maribo fra DEFACTUM, Region Midtjylland",
  "Cand.scient.san, fysioterapeut og ph.d. Lars Hermann Tang fra REHPA, Region Syddanmark",
  "Læge, ph.d. og seniorforsker Lone Ross Nylandsted fra Palliativ
  forskningsenhed, Bispebjerg og Frederiksberg Hospital",
  "Cand.scient.san.publ. og ph.d. Line Lund fra Palliativ forskningsenhed,
  Bispebjerg og Frederiksberg Hospital",
  "Psykolog Anne Mose fra Hjerteforeningen",
  "Cand.scient.san.publ. og forskningskonsulent Maja Bülow Lykke fra Hjerteforeningen.",
  "Sociolog og teamleder Sara Kudsk-Iversen fra Hjerteforeningen."
))

buttet_html_ls <- map(bullets, buttit_html)

about_text <- list(
  "general" = list(
    "Hjerteforeningen har haft et ønske om at gentage undersøgelsen ’Livet med en
hjertesygdom’ fra 2014 med henblik på at kunne følge med i, hvordan
hjertepatienterne og deres pårørende har det, og hvordan de oplever mødet med
sundhedsvæsenet. Det centrale i undersøgelsen er, at den bygger på
patienternes og de pårørendes egne oplevelser af deres sygdoms- og
behandlingsforløb. Denne viden er yderst værdifuld for at kunne forbedre
kvaliteten af indsatser på sundhedsområdet og kan inddrages både i
planlægning, strategisk ledelse og kvalitetssikring.",

    "Resultaterne fra ’Livet med en hjertesygdom’ vil desuden blive
anvendt som led i Hjerteforeningens arbejde med at sikre den bedste behandling
og den bedst mulige livskvalitet for hjertepatienter og deres pårørende. Målet
er, at denne undersøgelse vil hjælpe med at identificere de temaer eller
områder, hvor der er et særligt behov for at udvide eller forbedre
eksisterende behandling eller støttetilbud.",

    "Undersøgelsen er gennemført af Hjerteforeningen i samarbejde med Gentofte
Hospital af en projektgruppe bestående af seniorforsker og projektleder Nina
Føns Johnsen, ph.d. - studerende Sidsel Marie Bernt Jørgensen, seniorforsker
Matthew Phelps, teamleder Poul Dengsøe Jensen samt forskningschef Gunnar
Gislason.",

    "Undersøgelsen er støttet af Snedkermester Sophus Jacobsen og hustru Astrid
Jacobsens Fond, Helsefonden, Grete og Sigurd Pedersens Fond, Ingeniør og
kaptajn Aage Nielsens Familiefond samt Lemvigh-Müller Fonden."
  ),
  "pop" = list(
    "De potentielle deltagere til undersøgelsen blev identificeret i
Landspatientregisteret, hvis de i løbet af 2018 havde haft kontakt til et
dansk hospital med én af følgende fire diagnoser: iskæmisk hjertesygdom,
hjertesvigt, atrieflimren og hjerteklapsygdom. Hjertepatienterne skulle
samtidig være mindst 35 år og bosiddende i Danmark, og de måtte ikke have
været i kontakt med et dansk hospital inden for de seneste ti år med den samme
hjertesygdom, som de blev udtrukket på baggrund af.",

    "Fra denne population trak Sundhedsdatastyrelsen en tilfældig
stikprøve på 10.000 hjertepatienter. De hjertepatienter, der blev
inviteret til undersøgelsen, blev bedt om selv at definere deres
nærmeste, voksne pårørende, samt at invitere vedkommende til
undersøgelsen. Patienter uden voksne pårørende, blev bedt om at
se bort fra invitationen til pårørendeundersøgelsen.",

"Af nedenstående tabel fremgår det, hvordan de fire patientgrupper er
defineret: "
),
"pat"=list(
  "Patientspørgeskemaet til dataindsamlingen i 2020 indeholdt mange af de
  samme spørgsmål som i første undersøgelse, da dette spørgeskema var udviklet
  på baggrund af en grundig forundersøgelse og desuden havde fokus på
  internationalt anvendte skalaer. Nogle få spørgsmål blev ekskluderet og nye
  tilføjet, da der f.eks. var behov for særligt fokus på kosttilskud og
  naturlægemidler, patientinddragelse, arbejdsliv, ensomhed, trivsel og
  corona-pandemien.",

  "Det nye spørgeskema indeholdt således spørgsmål inden for følgende temaer: ",

  buttet_html_ls$topics,

  "Der blev kørt en Delphi-proces, hvor otte faglige eksperter inden for de
  inkluderede temaer i spørgeskemaet ratede hvert spørgsmål efter relevans
  samt kommenterede, og spørgsmål, der scorede under 8 (på en skala fra 0 til
  10), blev udeladt. ",

  "Følgende eksperter deltog:",
  buttet_html_ls$experts,
  "Desuden bidrog overlæge, ph.d. og professor Ann-Dorte Zwisler fra REHPA,
  Region Syddanmark med sparring i forbindelse med udviklingen af
  spørgeskemaet.",

  "Der blev endvidere gennemført kvalitative kognitive enkelt-interviews med
  11 hjertepatienter med henblik på at teste spørgeskemaet og sikre
  forståelighed, kvalitet, relevans mv. Spørgeskemaet blev justeret derefter,
  og det endelige spørgeskema indeholdt i alt 51 spørgsmål eller
  spørgsmålsbatterier."
))
