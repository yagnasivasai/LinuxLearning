Generate RSA
    openssl genrsa -aes256 -out ca-key.pem 4096
Generate a public CA Cert
    openssl req -new -x509 -sha256 -days 365 -key ca-key.pem -out ca.pem
Optional Stage: View Certificate's Content
    openssl x509 -in ca.pem -text
Create a RSA key
    openssl genrsa -out cert-key.pem 4096
Create a Certificate Signing Request (CSR)
    openssl req -new -sha256 -subj "/CN=yourcn" -key cert-key.pem -out cert.csr
Create a extfile with all the alternative names
    echo "subjectAltName=DNS:localhost.localdomain,IP:192.168.2.140" >> extfile.cnf
Create the certificate
    openssl x509 -req -sha256 -days 365 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial 
cert-key.pem
cat cert.pem > fullchain.pem
cat ca.pem >> fullchain.pem
