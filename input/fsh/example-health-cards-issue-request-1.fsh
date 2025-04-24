Instance: example-health-cards-issue-request-1
InstanceOf: Parameters
Usage: #example
Description: "Example of an Issue Verifiable Credential operation request containing all input parameters"
* parameter[0].name = "credentialType"
* parameter[=].valueUri = "Immunization"
* parameter[+].name = "credentialValueSet"
* parameter[=].valueUri = "https://terminology.smarthealth.cards/ValueSet/immunization-orthopoxvirus-all"
* parameter[+].name = "includeIdentityClaim"
* parameter[=].valueString = "Patient.name"
* parameter[+].name = "_since"
* parameter[=].valueDateTime = "2023-03"