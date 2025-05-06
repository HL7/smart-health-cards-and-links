Instance: patient-i-health-cards-issue
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://hl7.org/fhir/uv/smart-health-cards-and-links/OperationDefinition/patient-i-health-cards-issue"
* name = "HealthCardsIssue"
* title = "Issue Verifiable Credential"
* status = #active
* kind = #operation
* date = "2021-03-08"
* publisher = "HL7 International / FHIR Infrastructure"
* contact[0].name = "HL7 International - FHIR Infrastructure"
* contact[=].telecom.system = #url
* contact[=].telecom.value = "http://www.hl7.org/Special/committees/fiwg"
* contact[+].name = "Frank McKinney"
* contact[=].telecom.system = #email
* contact[=].telecom.value = "fm@frankmckinney.com"
* description = "This operation enables a FHIR-enabled issuer to request or generate a specific type of SMART Health Card"
* affectsState = false
* jurisdiction = $m49.htm#001 "World"
* code = #health-cards-issue
* resource = #Patient
* system = false
* type = false
* instance = true
* parameter[0].name = #credentialType
* parameter[=].use = #in
* parameter[=].min = 1
* parameter[=].max = "*"
* parameter[=].type = #uri
* parameter[+].name = #credentialValueSet
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "*"
* parameter[=].type = #uri
* parameter[+].name = #includeIdentityClaim
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "*"
* parameter[=].type = #string
* parameter[+].name = #_since
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #dateTime
* parameter[+].name = #verifiableCredential
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "*"
* parameter[=].type = #string
* parameter[+].name = #resourceLink
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "*"
* parameter[=].part[0].name = #vcIndex
* parameter[=].part[=].use = #out
* parameter[=].part[=].min = 0
* parameter[=].part[=].max = "1"
* parameter[=].part[=].type = #integer
* parameter[=].part[+].name = #bundledResource
* parameter[=].part[=].use = #out
* parameter[=].part[=].min = 1
* parameter[=].part[=].max = "1"
* parameter[=].part[=].type = #uri
* parameter[=].part[+].name = #hostedResource
* parameter[=].part[=].use = #out
* parameter[=].part[=].min = 1
* parameter[=].part[=].max = "1"
* parameter[=].part[=].type = #uri

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