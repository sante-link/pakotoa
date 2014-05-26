# language: fr

Fonctionnalité: Autorités de certifications

  @wip
  Scénario: Création d'une autorité de certification simple
    Étant donné un administrateur
    Lorsqu'il créé une autorité de certification "/C=FR/O=Pakotoa/CN=Test CA/emailAddress=pakotoa@example.com"
    Alors l'autorité de certification "/C=FR/O=Pakotoa/CN=Test CA/emailAddress=pakotoa@example.com" peut signer une demande de signature de certificat pour "/C=FR/O=Pakotoa/CN=Test Certificate"
