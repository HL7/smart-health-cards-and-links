Instance: example-health-cards-issue-response-1
InstanceOf: Parameters
Usage: #example
Description: "Example of an Issue Verifiable Credential operation response containing all output parameters"
* parameter[0].name = "verifiableCredential"
* parameter[=].valueString = "<<Health Card as JWS>>"
* parameter[+].name = "resourceLink"
* parameter[=].part[0].name = "vcIndex"
* parameter[=].part[=].valueInteger = 0
* parameter[=].part[+].name = "bundledResource"
* parameter[=].part[=].valueUri = "resource:2"
* parameter[=].part[+].name = "hostedResource"
* parameter[=].part[=].valueUri = "https://fhir.example.org/Immunization/123"