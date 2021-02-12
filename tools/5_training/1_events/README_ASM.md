# AIOPS AI Manager - training





# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ASM Topology matching 
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

demo-noi-topology-asm-credentials

https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/merge/swagger#!/Rules/injestRule

noi-topology-default-user
Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=



## MATCHCREATE
curl -X "POST" "https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/merge/rules?ruleType=matchTokensRule" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=' \
     -d $'{
  "tokens": [
    "name"
  ],
  "entityTypes": [
    "deployment"
  ],
  "providers": [
    "*"
  ],
  "observers": [
    "*"
  ],
  "ruleType": "matchTokensRule",
  "name": "kubetoy-match-name",
  "ruleStatus": "enabled"
}'


curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d 'bbbbb' 'https://demo-noi-topology.noi.apps.ocp45.tec.uk.ibm.com/1.0/merge/rules'

## MATCHCREATE
curl -X "POST" "https://demo-noi-topology.noi.apps.ocp45.tec.uk.ibm.com/1.0/merge/rules" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:3gX1qb+JnbH7m1H2TARmCsxZp78/tZgeBAF558bzpUI=' \
     --insecure \
     -d $'{
  "tokens": [
    "name"
  ],
  "entityTypes": [
    "deployment"
  ],
  "providers": [
    "*"
  ],
  "observers": [
    "*"
  ],
  "ruleType": "matchTokensRule",
  "name": "kubetoy-match-name",
  "ruleStatus": "enabled"
}'





curl -k -v -X POST -u 'noi-topology-default-user:Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=' --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{
  "name": "kubetoy-match",
  "ruleType": "matchTokensRule",
  "tokens": [
    "name"
  ],
  "ruleStatus": "enabled",
  "entityTypes": [
    "deployment"
  ],
  "observers": [
    "*"
  ],
  "providers": [
    "*"
  ]
}
' 



https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/merge/rules




# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## NOI
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ASM Topology connection 
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

openssl s_client -connect  demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud:443

https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud

demo-noi-topology-noi-user

Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=

-----BEGIN CERTIFICATE-----
MIIGDzCCBPegAwIBAgISBFlvCC27T8VdBrL91SRKjznfMA0GCSqGSIb3DQEBCwUA
MDIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MQswCQYDVQQD
EwJSMzAeFw0yMTAxMjAwNjQ3NDdaFw0yMTA0MjAwNjQ3NDdaMDgxNjA0BgNVBAMT
LXRlYy1jcDRhaW9wcy5ldS1kZS5jb250YWluZXJzLmFwcGRvbWFpbi5jbG91ZDCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL0UVEPu+qOLdGZzsEIQhgvZ
MDlam1Okb/fgbCh+PRKDXLM50F9XLWCZj/OTLDYk3Kz9LkUef+m2nec5PNfNC7Ti
UpmC7hRn7rVnEw7Z39BOV7ct2UvF1+0pJTZX1Fl64pd6Hi2WmcunB9GFetGz/4v4
EgF1WwDVK+cDLWCXZEHCT+HFIiJszxbC11Ol62Hvc7D/IolnmrCau0hRLs7oerG5
Ia0tY93c5lFfWslIf1lFRVwOnN8N7p94UrDXoWCF4eJvpwQLldl9PBRV7+k+zn5r
+HxviShdqtNUtW0CXClcTaekgU8fRmQfX6JATJaWioUQn+UKlfJsra1l1MumFWsC
AwEAAaOCAxcwggMTMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcD
AQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQUcWUCG2T05AYVtsXc
UheWdEB4WxQwHwYDVR0jBBgwFoAUFC6zF7dYVsuuUAlA5h+vnYsUwsYwVQYIKwYB
BQUHAQEESTBHMCEGCCsGAQUFBzABhhVodHRwOi8vcjMuby5sZW5jci5vcmcwIgYI
KwYBBQUHMAKGFmh0dHA6Ly9yMy5pLmxlbmNyLm9yZy8wgeYGA1UdEQSB3jCB24JV
Ki50ZWMtY3A0YWlvcHMtM2MxNGFhMWZmMmRhMTkwMWJmYzdhZDhiNDk1Yzg1ZDkt
MDAwMC5ldS1kZS5jb250YWluZXJzLmFwcGRvbWFpbi5jbG91ZIJTdGVjLWNwNGFp
b3BzLTNjMTRhYTFmZjJkYTE5MDFiZmM3YWQ4YjQ5NWM4NWQ5LTAwMDAuZXUtZGUu
Y29udGFpbmVycy5hcHBkb21haW4uY2xvdWSCLXRlYy1jcDRhaW9wcy5ldS1kZS5j
b250YWluZXJzLmFwcGRvbWFpbi5jbG91ZDBMBgNVHSAERTBDMAgGBmeBDAECATA3
BgsrBgEEAYLfEwEBATAoMCYGCCsGAQUFBwIBFhpodHRwOi8vY3BzLmxldHNlbmNy
eXB0Lm9yZzCCAQQGCisGAQQB1nkCBAIEgfUEgfIA8AB2AJQgvB6O1Y1siHMfgosi
LA3R2k1ebE+UPWHbTi9YTaLCAAABdx7DjKsAAAQDAEcwRQIhAKSyxu39wLcnpDYm
/2dyCGah9Hk+tQgD/oiuvTf/ugdWAiA5kyN6LiBg0FXOHs2HakMvfP7xlSd9ITio
R9aLGVjSbgB2AH0+8viP/4hVaCTCwMqeUol5K8UOeAl/LmqXaJl+IvDXAAABdx7D
jNwAAAQDAEcwRQIhAMgXlUXpvjdA54tXYfPhqimIc+lvF4UIyl+74f8mPvReAiBj
C6LDA0V0k00PXSrIvsAm8vtoLXQX7Gme6t4tsCBz4TANBgkqhkiG9w0BAQsFAAOC
AQEASxx6TfxYnhxtygcfZeK9MtSio/9XevqHip0RsgHFtYHrb7pu3fP/BJphNEU8
U3GxVnYL2ff5rlTZj0ss7C3Y+R96wWYWl6ucOOd8ohR8i077xfj0F7PJ6axQkXzA
bT704QfskiEPtqu0l9zenUFuZXNWODAxxUrqf8YqHqGulpGrQkSJYJ3ZImLR8CrB
BuK8t/oEDzgkYDhe4S/2hWsWw34JK2Re4De645pMeL6KWEH/RuyAlVXvcgzumNlH
vcrSrrDKtjSzm79vag9u+zKwXWifoV0QGJOuEsv3+poqzLiMXKMYTgZZEOT6zOBw
D66Rqwf7dDs+fH4IMjGo1y+5Hw==
-----END CERTIFICATE-----
