$rootSubject = (Read-Host "Enter Root CA subject. CN=... will be added as prefix")
$rootSubject = "CN=$rootSubject";
New-SelfSignedCertificate -KeyLength 4096 -KeyAlgorithm RSA -HashAlgorithm sha256 -CertStoreLocation Cert:\CurrentUser\My -Subject $rootSubject -KeyProtection Protect -KeyUsage CertSign -Type CodeSigningCert -KeyExportPolicy NonExportable | Tee-Object -Variable rootCA;

$signCertificateSubject = (Read-Host "Enter Signing Certificate subject. CN=... will be added as prefix");
$signCertificateSubject = "CN=$signCertificateSubject";
New-SelfSignedCertificate -KeyLength 4096 -KeyAlgorithm RSA -HashAlgorithm sha256 -CertStoreLocation Cert:\CurrentUser\My -Subject $signCertificateSubject -KeyProtection Protect -Signer $rootCA -Type CodeSigningCert | Tee-Object -Variable Global:MySigningCertificate;

$rootCAFilename = "rootCA.cer";
$exportedRootCAPath = Join-Path ([System.Environment]::GetFolderPath("Desktop")) $rootCAFilename;
Export-Certificate -FilePath $exportedRootCAPath -Cert $rootCA -Force;
Import-Certificate -FilePath $exportedRootCAPath -CertStoreLocation Cert:\CurrentUser\Root;

$signingCertFilename = "signing.cer";
$exportedSigningCertPath = Join-Path ([System.Environment]::GetFolderPath("Desktop")) $signingCertFilename;
Export-Certificate -FilePath $exportedSigningCertPath -Cert $Global:MySigningCertificate -Force;
Import-Certificate -FilePath $exportedSigningCertPath -CertStoreLocation Cert:\CurrentUser\TrustedPublisher;
