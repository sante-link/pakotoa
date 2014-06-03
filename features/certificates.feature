# language: fr

Fonctionnalité: Certificats

  Scénario: Révocation de certificats
    Étant donné un administrateur
    Et une autorité de certification "/C=FR/O=Pakotoa"
    Et un certificat "/C=FR/O=Pakotoa/CN=TEST 1" signé par "/C=FR/O=Pakotoa"
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 1 liens "Revoke"
    Étant donné 5 minutes s'écoulent
    Et un certificat "/C=FR/O=Pakotoa/CN=TEST 2" signé par "/C=FR/O=Pakotoa"
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 2 liens "Revoke"
    Étant donné le certificat "/C=FR/O=Pakotoa/CN=TEST 1" est révoqué
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 1 liens "Revoke"
    Étant donné 20 minutes s'écoulent
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 0 liens "Revoke"
