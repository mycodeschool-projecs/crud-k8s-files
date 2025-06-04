# Aplicație CRUD în Kubernetes

Acest director conține fișierele de configurare Kubernetes pentru implementarea aplicației CRUD. Fiecare fișier definește resurse specifice necesare pentru funcționarea aplicației.

## Componente principale

### Infrastructură

- **storage.yaml**: Definește clasele de stocare utilizate de aplicație pentru persistența datelor.
  > *Teorie*: StorageClass este o resursă Kubernetes care definește tipul de stocare oferit de un provider. Permite alocarea dinamică a volumelor persistente și specifică parametrii precum tipul de stocare, replicarea și politicile de retenție.

- **volumes.yaml**: Configurează volumele persistente necesare pentru stocarea datelor.
  > *Teorie*: PersistentVolume (PV) și PersistentVolumeClaim (PVC) sunt resurse Kubernetes care gestionează stocarea persistentă. PV reprezintă o bucată de stocare în cluster, iar PVC este o cerere de stocare făcută de un pod. Acestea asigură persistența datelor chiar și atunci când podurile sunt repornite.

- **secret.yaml**: Conține secretele utilizate de aplicație (parole, chei de acces, etc.).
  > *Teorie*: Secret este o resursă Kubernetes utilizată pentru stocarea informațiilor sensibile precum parole, token-uri OAuth, chei SSH. Datele sunt stocate în format base64 și pot fi montate ca fișiere în poduri sau expuse ca variabile de mediu.

- **configs.yaml**: Definește ConfigMaps cu configurări pentru diferite componente ale aplicației.
  > *Teorie*: ConfigMap este o resursă Kubernetes care permite separarea configurărilor de codul aplicației. Stochează perechi cheie-valoare care pot fi utilizate ca variabile de mediu, argumente de comandă sau fișiere de configurare în poduri.

### Bază de date

- **mysql.yaml**: Implementează baza de date MySQL utilizată pentru stocarea datelor aplicației.
  > *Teorie*: În Kubernetes, bazele de date precum MySQL sunt de obicei implementate ca StatefulSet, o resursă specializată pentru aplicații cu stare. StatefulSet oferă identificatori de rețea stabili, stocare persistentă și ordonarea garantată a implementării/scalării, esențiale pentru clustere de baze de date. MySQL este un sistem de gestionare a bazelor de date relaționale open-source, utilizat pentru stocarea structurată a datelor aplicației.

### Servicii backend

- **auth-service.yaml**: Serviciul de autentificare (kube-land) care gestionează autentificarea și autorizarea utilizatorilor.
  > *Teorie*: Serviciul de autentificare implementează mecanisme de securitate pentru verificarea identității utilizatorilor (autentificare) și determinarea drepturilor de acces (autorizare). În arhitecturi microservicii, acest serviciu specializat gestionează token-uri JWT, OAuth sau alte protocoale de securitate, oferind un punct centralizat pentru politicile de securitate.

- **command-service.yaml**: Serviciul de comenzi care procesează operațiunile CRUD.
  > *Teorie*: Serviciul de comenzi implementează operațiunile CRUD (Create, Read, Update, Delete) pentru entitățile aplicației. În arhitectura CQRS (Command Query Responsibility Segregation), acest serviciu se concentrează pe procesarea comenzilor care modifică starea sistemului, separând responsabilitățile de scriere de cele de citire pentru o mai bună scalabilitate și performanță.

### Frontend

- **app-client.yaml**: Aplicația client React care oferă interfața utilizator pentru interacțiunea cu serviciile backend.
  > *Teorie*: Aplicațiile frontend în Kubernetes sunt de obicei implementate ca Deployment-uri fără stare. React este o bibliotecă JavaScript pentru construirea interfețelor utilizator interactive, folosind o abordare declarativă și bazată pe componente. În arhitecturi microservicii, frontend-ul comunică cu backend-urile prin API-uri RESTful sau GraphQL, oferind o experiență unificată utilizatorului final.

### Rețea

- **ingress.yaml**: Configurează regulile de Ingress pentru expunerea serviciilor către exterior.
  > *Teorie*: Ingress este o resursă Kubernetes care gestionează accesul extern la serviciile din cluster, oferind rutare HTTP/HTTPS, SSL/TLS, găzduire virtuală și echilibrare de încărcare. Funcționează ca un strat de abstracție peste serviciile Kubernetes, permițând expunerea mai multor servicii printr-un singur punct de intrare, cu reguli de rutare bazate pe căi URL sau nume de host.

### Monitorizare și logging

- **zipkin.yaml**: Implementează Zipkin pentru urmărirea distribuită a cererilor între servicii.
  > *Teorie*: Zipkin este un sistem de urmărire distribuită care ajută la colectarea datelor de timp necesare pentru depanarea latențelor în arhitecturile de microservicii. Implementează modelul de urmărire distribuită Dapper de la Google, permițând vizualizarea fluxului de cereri între servicii și identificarea punctelor de eșec sau întârziere.

- **elasticsearch.yaml**: Configurează Elasticsearch pentru stocarea și indexarea logurilor.
  > *Teorie*: Elasticsearch este un motor de căutare și analiză distribuit, bazat pe Lucene. În contextul Kubernetes, este utilizat pentru stocarea, indexarea și căutarea rapidă a logurilor generate de aplicații. Oferă capacități avansate de căutare full-text, analiză și agregare a datelor la scară mare.

- **kibana.yaml**: Implementează Kibana pentru vizualizarea și analiza logurilor din Elasticsearch.
  > *Teorie*: Kibana este o platformă de vizualizare și explorare a datelor pentru Elasticsearch. Permite crearea de tablouri de bord interactive, grafice, hărți și alte vizualizări pentru a analiza logurile și metricile. În Kubernetes, Kibana oferă o interfață web pentru monitorizarea și depanarea aplicațiilor.

- **logstash.yaml**: Configurează Logstash pentru procesarea și trimiterea logurilor către Elasticsearch.
  > *Teorie*: Logstash este un pipeline de procesare a datelor open-source care ingestează, transformă și trimite date către diverse destinații. În stiva ELK, Logstash colectează loguri din diverse surse, le procesează (filtrare, transformare) și le trimite către Elasticsearch pentru indexare și stocare.

- **prometheus.yaml**: Implementează Prometheus pentru colectarea și stocarea metricilor.
  > *Teorie*: Prometheus este un sistem de monitorizare și alertare open-source, conceput pentru fiabilitate și scalabilitate. Utilizează un model de date multidimensional, un limbaj de interogare flexibil (PromQL) și colectează metrici prin polling HTTP. În Kubernetes, Prometheus este standardul de facto pentru monitorizarea sistemelor și aplicațiilor.

- **grafana.yaml**: Configurează Grafana pentru vizualizarea metricilor colectate de Prometheus.
  > *Teorie*: Grafana este o platformă open-source pentru monitorizare și observabilitate, specializată în vizualizarea datelor de serie temporală. Se integrează cu Prometheus și alte surse de date pentru a crea tablouri de bord interactive, grafice și alerte. În Kubernetes, Grafana oferă vizualizări complexe pentru metricile de sistem și aplicație.

### Configurare

- **setup.yaml**: Conține job-uri pentru configurarea inițială a componentelor.
  > *Teorie*: În Kubernetes, Job-urile sunt resurse care execută o sarcină până la finalizare și apoi se opresc. Sunt ideale pentru operațiuni unice precum migrări de bază de date, inițializări sau configurări. Job-urile de configurare inițială asigură că sistemul este pregătit corespunzător înainte ca aplicațiile principale să fie pornite, realizând sarcini precum crearea de scheme de bază de date, popularea cu date inițiale sau configurarea componentelor externe.

## Implementare

Pentru a implementa toate componentele, utilizați scriptul `apply-all.sh`:

```bash
./apply-all.sh
```

Acest script va aplica toate resursele în ordinea corectă pentru a asigura o implementare reușită a aplicației.
