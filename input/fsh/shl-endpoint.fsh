Profile: ShlEndpoint
Parent: Endpoint
Id: shl-endpoint
Title: "SHL Endpoint"
Description: "This profile defines constraints for an Endpoint to be utilized by a SMART Health Links Receiving Application, for example to launch a SMART on FHIR app or to provide another interactive user experience "
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #fhir
* ^version = "1.0.0"
* ^status = #active
* ^date = "2025-05-06"
* ^publisher = "HL7 International / FHIR Infrastructure"
* ^contact[0].name = "HL7 International - FHIR Infrastructure"
* ^contact[=].telecom.system = #url
* ^contact[=].telecom.value = "http://www.hl7.org/Special/committees/fiwg"
* ^contact[+].name = "Frank McKinney"
* ^contact[=].telecom.system = #email
* ^contact[=].telecom.value = "fm@frankmckinney.com"
* ^jurisdiction = $m49.htm#001 "World"
* name 1..1 MS
* name ^comment = "Describes the interactive experience with sufficient detail for the Receiving User to decide whether to engage"
* connectionType 1..1 MS
* connectionType from $shlconnectiontype (extensible)
* connectionType ^binding.description = "SHL endpoint type"
* connectionType ^comment = "Identifies the endpoint as one providing a SMART Health Links interactive experience"
* address 1..1 MS
* address ^comment = "The URI for the interactive experience"
* period 0..1 MS
* period ^comment = "Documents the window of time when the interactive experience is available"


Instance: shl-interactive-experience-endpoint-1
InstanceOf: shl-endpoint
Usage: #example
Description: "Example of an endpoint providing a SMART Health Links interactive experience"
* meta.profile = "http://hl7.org/fhir/uv/smart-health-cards-and-links/StructureDefinition/shl-endpoint"
* status = #active
* name = "Review and comment on Alice's case in ACME Medical Diagnostic Portal"
* address = "https://interact.example.org/case-id/521039c3-4bb9-45bd-8271-6001d2f4dea9"
* period.end = "2025-10-20T12:30:00Z"
* connectionType = $tempshlendpointtype#"shl-interactive-experience"
* payloadType.coding = $hl7payloadtype#"none"


Instance: shl-smart-on-fhir-endpoint-1
InstanceOf: shl-endpoint
Usage: #example
Description: "Example of an endpoint for establihsing a consumer-mediated SMART on FHIR connection to the data source"
* meta.profile = "http://hl7.org/fhir/uv/smart-health-cards-and-links/StructureDefinition/shl-endpoint"
* status = #active
* name = "Labs-R-Us Application Access"
* address = "https://fhir.example.org"
* connectionType = $hl7restfulsecurityservice#"SMART-on-FHIR"
* payloadType.coding = $hl7payloadtype#"none"
