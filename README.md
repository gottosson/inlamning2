# Min lilla bokhandel av Gabriella Ottosson YH25

Jag har skapat en databas över Min lilla bokhandel och syftet med databasen är att beskriva min bokhandel samt dess relationer som finns. 
## Tabeller
* Kunder
* Produkter
* Beställningar
* Orderrader
* Kundlogg

Relationen mellan dessa är att en kund kan göra flera beställningar. En beställning innehåller en eller flera produkter och i detta fall är produkterna böcker. I beställningarna kan det finnas flera orderrader. Jag har även skapat en kundlogg som automatiskt loggar när en kund registrerar sig hos bokhandeln. 

<ins>**Bild på ER-diagrammet:**</ins><img width="2082" height="1216" alt="Inlämningsuppgift2" src="https://github.com/user-attachments/assets/dd02da50-afa3-4e2a-9b17-c8771759d0aa" />


## Reflektion och analys
Jag har valt att skapa min databas för min bokhandel i en relationsdatabas som MySQL. Detta för att det krävs struktur för att få en överblick över min bokhandel, dess kunder och produkter samt hur dessa relaterar till varandra. Det är viktigt att det blir "rätt" vid beställningar - rätt kund ska få rätt bok och till korrekt pris. Genom att använda Primary Keys och Foreign Keys säkerställer jag dataintegritet, exempelvis att en order inte kan skapas på en kund som inte finns. 

I nuläget är inte min bokhandel så stor men om den skulle hantera 100 000 kunder tänker jag att jag skulle behöva skapa fler index för att snabbt kunna söka igenom min databas och få fram data. Men inte för många heller eftersom varje index som skapas tar upp extra diskutrymme och minne, vilket kan bli kostsamt och resurskrävande när datamängden växer till hundratusentals rader. När 100 000 kunder handlar ofta kommer också min data i tabellerna för Beställningar samt Orderrader att bli enorm. Det skulle kanske vara en bra idé införa en strategi för arkivering, exempelvis att gamla beställningar från flera år tillbaka som sällan läses skulle kunna flyttas till en separat historik-tabell. Detta håller den aktiva tabellen "lätt" och snabb för kunderna som handlar just nu. Jag tänker att jag också skulle behöva se över att Totalbelopp i nuläget skrivs in manuellt i min Beställningar-tabell, vilket kan öka risken för fel av den mänskliga faktorn. Istället skulle jag kunna använda mig av en Trigger eller en Stored Procedure som räknar ut summan automatiskt baserat på vad som finns i Orderrader. Sist men inte minst tänker jag att en automatiserad back-up lösning av databasen skulle behövas vid hanterandet av hundratusentals kunder. Förlust av data för så många kunder skulle få allvarliga konsekvenser för bokhandeln.

Detta är en övningsuppgift i kursen Databaser i yrkeshögskoleprogrammet _Cloud and IT-infrastructure specialist_.
