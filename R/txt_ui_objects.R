
# FUNCTIONS ---------------------------------------------------------------

buttit_html <- function(x){
  paste0("<ui><li>",
         paste0(x, collapse = "</li><li>"),
         "</ui></li>")
}



# INPUTS ------------------------------------------------------------------



ui_main_title <- "Resultater"
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


# READER'S GUIDE ---------------------------------------------------------

ui_guide_title <- "Vejledning"


guide_text <- list(
  "Databasen rummer resultaterne af den nationale spørgeskemaundersøgelse
  ‘Livet med en hjertesygdom’ fra 2020/2021, og den giver dig mulighed for at
  dykke ned i resultaterne fra både patient- og pårørendeundersøgelsen samt
  eventuelt at downloade data eller figurer/tabeller.",
  "<b>Sådan bruger du databasen</b>",

  "På forsiden vælger du i boksen øverst til venstre, om du vil se
  resultaterne for patient- eller pårørendeundersøgelsen.",

  "Under menuen ’Vælg emne’ vælger du dernæst, hvilket tema fra spørgeskemaet,
  du vil se nærmere på, f.eks.: ’Behandling på sygehuset’.",

  "I menuen ’Vælg spørgsmål’ fremgår nu samtlige spørgsmål inden for det
  valgte emne. Når et spørgsmål er valgt, vises svarfordelingen på det
  specifikke spørgsmål. Øverst i billedet har du mulighed for at vælge, om du
  vil have svarfordelingen vist som graf eller tabel.",

  "Under fanen ’Stratifikationer’ kan du for visse spørgsmål også vælge at få
  vist besvarelserne opdelt på f.eks. køn/alder, diagnose, uddannelsesniveau
  eller bopælsregion. I disse tilfælde gøres der opmærksom på, at resultaterne
  præsenteres med et problemorienteret fokus. Et eksempel herpå kunne være, at
  det kun er andelen af hjertepatienter, der svarede, at de i mindre grad
  eller slet ikke var trygge ved at komme hjem fra sygehuset, der vises.",


  "Download af graf: En graf hentes ved at trykke på det lille kamera-ikon i
  øverste højre hjørne af grafen. ",
  "Download af tabel: En tabel hentes eller kopieres ved at trykke på ’PDF’
  eller ’Copy’ under tabellen.",

  "<b>Vægtning i patientundersøgelsen</b>",
  "Der gøres opmærksom på, at de beregnede andele i patientundersøgelsen er
  blevet vægtet for såkaldt non response (ikke-deltagelse) for at sikre, at de
  personer som deltog i undersøgelsen, lignede den generelle hjertepatient i
  Danmark så godt som mulig.",

  "Du har under fanen ’Metode’ i den røde menu-bjælke mulighed for at læse
  mere om undersøgelsen og dens metodiske fremgangsmåder."

)
# ABOUT SETUP-------------------------------------------------------------------
ui_about_title <- "Metode"
about_selection <- "Vælg emne:"
about_choices <- list(
  "Kort om undersøgelsen" = "general",
  "Population" = "pop",
  "Patientspørgeskemaet" = "pat",
  "Pårørendespørgeskemaet" = "paar",
  "Dataindsamling" = "data",
  "Databehandling" = "methods",
  "Formidling" = "comm"
)

bullets = list(
  topics = list(
    b_1 = "Behandlingen på sygehuset",
    b_2 = "Kontakten med sundhedspersonalet ",
    b_3 = "Pårørende",
    b_4 = "Medicin",
    b_5 = "Rådgivning og tilbud",
    b_6 = "Arbejdsliv",
    b_7 = "Sociale og økonomiske forhold",
    b_8 = "Hverdagen med en hjertesygdom",
    b_9 = "Helbred og trivsel samt corona-pandemien."
  ),
  experts = list(
    "Forskningsleder, ph.d. Thomas Maribo fra DEFACTUM, Region Midtjylland",
    "Cand.scient.san, fysioterapeut og ph.d. Lars Hermann Tang fra REHPA, Region Syddanmark",
    "Læge, ph.d. og seniorforsker Lone Ross Nylandsted fra Palliativ
  forskningsenhed, Bispebjerg og Frederiksberg Hospital",
    "Cand.scient.san.publ. og ph.d. Line Lund fra Palliativ forskningsenhed,
  Bispebjerg og Frederiksberg Hospital",
    "Psykolog Anne Mose fra Hjerteforeningen",
    "Cand.scient.san.publ. og forskningskonsulent Maja Bülow Lykke fra Hjerteforeningen.",
    "Sociolog og teamleder Sara Kudsk-Iversen fra Hjerteforeningen."
  ),
  paar_topics = list(
    "Nye opgaver og ændret hverdagsliv",
    "Mødet med sundhedsvæsenet",
    "Rådgivning og tilbud til pårørende",
    "Arbejdsliv og økonomi",
    "Helbred",
    "Corona-pandemien."
  ),
  paar_experts = list(
    "Formand for Pårørende i Danmark Marie Lenstrup ",

    'Læge, ph.d. og seniorforsker Lone Ross Nylandsted fra Palliativ
  forskningsenhed, Bispebjerg og Frederiksberg Hospital',

    "Cand.scient.san.publ. og ph.d. Line Lund fra Palliativ forskningsenhed,
  Bispebjerg og Frederiksberg Hospital",

    "Psykolog Anne Mose fra Hjerteforeningen",

    "Sygeplejerske Mia Jandrup fra Hjerteforeningen",

    "Cand.scient.san.publ. og forskningskonsulent Maja Bülow Lykke fra
  Hjerteforeningen",

    "Senior projektleder Stig Brøndum fra Hjerteforeningen",

    "Sociolog og teamleder Sara Kudsk-Iversen fra Hjerteforeningen."
  ),

  comm = list(
    "Køn- og aldersgrupper (kvinder ≤65 år, kvinder >65 år, mænd ≤65 år, mænd >65
år) ",

    "Diagnose (iskæmisk hjertesygdom, hjertesvigt, atrieflimren,
hjerteklapsygdom)",

    "Uddannelse (grundskole, gymnasial/erhvervsfaglig, kort/mellemlang
videregående, lang videregående)",

    "Bopælsregion (Region Nordjylland, Region Midtjylland, Region Syddanmark,
Region Sjælland, Region Hovedstaden)",

    "Den pårørendes relation til den hjertesyge (for pårørendeundersøgelsen)"
  ),
reports=list(
  "<a href='https://hjerteforeningen.dk/wp-content/uploads/2021/10/LMEH_Rapport_PATIENT_final-2.pdf'>Patientrapport</a>",
  "<a href='https://hjerteforeningen.dk/wp-content/uploads/2021/10/LMEH_Rapport_PA%CC%8AROeRENDE_final-4.pdf'>Pårørenderapport</a>"
)
)

buttet_html_ls <- lapply(bullets, buttit_html)

download_buttons <- list("pat"=htmltools::renderTags(downloadButton(
  outputId = "download_pat",
  label = paste0(txt_download),
  class = "btn radiobtn btn-default",
))$html %>% as.character(),
"paar"=htmltools::renderTags(downloadButton(
  outputId = "download_paar",
  label = paste0(txt_download),
  class = "btn radiobtn btn-default",
))$html %>% as.character()
)
# ABOUT TEXT --------------------------------------------------------------


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
  "pat" = list(
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
  ),

  "paar" = list(
    "Spørgeskemaet til pårørendeundersøgelsen blev udviklet på baggrund af en
  grundig forundersøgelse gennemført af DEFACTUM, Region Midtjylland.
  Forundersøgelsen omfattede en litteraturgennemgang samt en kvalitativ
  empiriindsamling blandt eksperter og pårørende og udmundede i en række
  identificerede temaer, som viste sig relevante for pårørende til personer
  med hjertesygdom. Der blev efterfølgende identificeret og formuleret
  relevante spørgsmål inden for de enkelte temaer:",
    buttet_html_ls$paar_topics,

    "Under udviklingen af spørgeskemaet blev der desuden kørt en Delphi-proces,
  hvor otte faglige eksperter inden for de inkluderede temaer i spørgeskemaet
  ratede hvert spørgsmål efter relevans samt kommenterede, og hvor spørgsmål,
  der scorede under 8 på en skala fra 1-10, blev udeladt. Følgende eksperter deltog:",
    buttet_html_ls$paar_experts,

    "Desuden bidrog professor Ann-Dorthe Zwisler fra REHPA, Region Syddanmark i
  udviklingen af spørgeskemaet.",

    "Der blev endvidere gennemført kvalitative kognitive enkelt-interviews med
  syv pårørende med henblik på at teste spørgeskemaet og sikre forståelighed,
  kvalitet, relevans mv. Spørgeskemaet blev justeret derefter, og det endelige
  spørgeskema indeholdt i alt 50 spørgsmål eller spørgsmålsbatterier."

  ),

  "data" = list(
    "Spørgeskemaerne blev sat op i SurveyXact og sendt til hjertepatienternes
  elektroniske postkasse, indeholdende invitation både til deltagelse i
  patientundersøgelsen og pårørendeundersøgelsen.",

    "Hjertepatienterne blev bedt om at invitere deres nærmeste voksne pårørende
  til undersøgelsen ved at videregive link og kode til pårørendespørgeskemaet
  til den pårørende. De hjertepatienter, der ikke havde en elektronisk
  postkasse (20 %), fik både patient- og pårørendespørgeskemaet tilsendt pr.
  post med frankerede svarkuverter. Desuden var der mulighed for at kontakte
  en hotline i dagtimerne for at bede om at få papirskema tilsendt, få hjælp
  til at udfylde spørgeskemaet, eller for at få svar på spørgsmål vedrørende
  undersøgelsen.",

    "Spørgeskemaet blev udsendt i oktober 2020, hvor der blev udsendt en
  elektronisk rykker to uger senere. Efter yderligere to uger blev der sendt
  et postomdelt brev indeholdende spørgeskema til både patient og pårørende
  samt frankerede svarkuverter til begge skemaer til de hjertepatienter, der
  endnu ikke havde svaret. Herefter påbegyndtes udringning til de
  hjertepatienter, der endnu ikke havde svaret, og her blev patienterne også
  mindet om at invitere en pårørende til at deltage."
  ),

  "methods" = list(
    "Dataindsamlingen blev afsluttet i februar 2021. Besvarede papirskemaer blev
  indtastet i SurveyXact af projektmedarbejderne og projektets
  studentermedhjælpere efter fælles retningslinjer. Den færdige datafil blev
  overført til Danmarks Statistiks forskerserver og databehandlet der. ",

    "Alle beregninger blev gennemført ved brug af statistisk software R Studio
  Version 1.3.1093 og R version 4.0.3 på Danmarks Statistiks forskerserver.",

    "<b>Særligt for patientundersøgelsen</b>",
    "Svarprocenten blev udregnet for de hjertepatienter, som havde besvaret
  minimum spørgsmål 1 samt yderligere ét spørgsmål i spørgeskemaet. ",

    "For hvert spørgsmål i spørgeskemaet blev der beregnet en andel af
  hjertepatienter, der svarede over/under et på forhånd fastlagt cut-point.
  Denne andel blev beregnet med et problemorienteret fokus. Et eksempel kunne
  være andelen af hjertepatienter, der svarede, at de ikke havde fået
  tilstrækkelig information om udleveret medicin, eller at de havde manglet
  hjælp til at håndtere svære følelser.",

    paste0("Se definition af cut-points", download_buttons$pat),


    "I patientundersøgelsen er de beregnede andele blevet vægtet for såkaldt non-
  respondents (ikke-deltagelse) for at sikre, at de personer som deltog i
  undersøgelsen, lignede den generelle hjertepatient i Danmark så godt som
  muligt. Der blev vægtet på variablene køn, alder og uddannelse. Kort fortalt
  skete denne vægtning ved, at svarene fra deltagende hjertepatienter, der
  lignede de ikke-deltagende hjertepatienter mht. køn, alder og uddannelse,
  blev vægtet op i det samlede gennemsnit, svarende til hvis ikke-deltagerne
  havde deltaget (inverse probability weighting).",

    "Det bemærkes, at antallet af personer ikke er det samme i alle analyser,
  hvilket skyldes, at ikke alle deltagere besvarede alle spørgsmål.",

    "<b>Særligt for pårørendeundersøgelsen</b>",
    "Svarprocenten blev udregnet for de pårørende, som havde besvaret minimum
  spørgsmål 2 samt yderligere ét spørgsmål i spørgeskemaet.",

    "For hvert spørgsmål i spørgeskemaet blev der beregnet en andel af
  pårørende, der svarede over/under et på forhånd fastlagt cut-point. Denne
  andel blev beregnet med et problemorienteret fokus. Et eksempel kunne være
  andelen af pårørende, der svarede, at de ikke havde fået tilstrækkelig
  information om hjertesygdommen, eller at de ikke havde fået tilstrækkelig
  hjælp til at leve bedst muligt som pårørende til en hjertepatient.",

    paste0("Se definition af cut-points", download_buttons$paar),

    "Det bemærkes, at antallet af personer ikke er det samme i alle analyser,
  hvilket skyldes, at ikke alle deltagere besvarede alle spørgsmål, samt at
  ikke alle pårørende har angivet deres alder, uddannelsesniveau og
  bopælsregion. Derudover bemærkes, at resultaterne ikke er vægtet som i
  patientrapporten, hvilket betyder, at resultaterne kun gælder for de
  pårørende, som valgte at deltage i denne undersøgelse, og ikke
  hjertepatienters pårørende generelt."



  ),

  "comm" = list(
    "Undersøgelsens resultater er tilgængelige i denne database. Databasen giver
  mulighed for at undersøge mulige sammenhænge ved at stratificere/opdele de
  beregnede andele på en række variable, herunder: ",
    buttet_html_ls$comm,
"Udvalgte resultatøer præsenteres desuden i to rapporter, som kan hentes her:",
buttet_html_ls$reports
  )

)
