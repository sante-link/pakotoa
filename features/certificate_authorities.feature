# language: fr

Fonctionnalité: Autorités de certifications

  Scénario: Création d'une autorité de certification simple
    Étant donné un administrateur
    Lorsqu'il créé une autorité de certification "/C=FR/O=Pakotoa/CN=Test CA/emailAddress=pakotoa@example.com"
    Alors l'autorité de certification "/C=FR/O=Pakotoa/CN=Test CA/emailAddress=pakotoa@example.com" peut signer une demande de signature de certificat pour "/C=FR/O=Pakotoa/CN=Test Certificate"

  Scénario: Création d'une chaine d'autorités de certification
    Étant donné un administrateur
    Lorsqu'il créé une autorité de certification "/C=FR/O=Pakotoa/CN=Test Root CA/emailAddress=pakotoa@example.com" avec la phrase de passe "correct horse battery staple"
    Et il créé une autorité de certification "/C=FR/O=Pakotoa/CN=Test Child CA/emailAddress=pakotoa@example.com" signée par "/C=FR/O=Pakotoa/CN=Test Root CA/emailAddress=pakotoa@example.com" avec la phrase de passe "glasses coffee box cellar" en utilisant la phrase de passe "correct horse battery staple"
    Et il créé une autorité de certification "/C=FR/O=Pakotoa/CN=Test SubChild CA/emailAddress=pakotoa@example.com" signée par "/C=FR/O=Pakotoa/CN=Test Child CA/emailAddress=pakotoa@example.com" en utilisant la phrase de passe "glasses coffee box cellar"
    Alors l'autorité de certification "/C=FR/O=Pakotoa/CN=Test SubChild CA/emailAddress=pakotoa@example.com" peut signer une demande de signature de certificat pour "/C=FR/O=Pakotoa/CN=Test Certificate"
