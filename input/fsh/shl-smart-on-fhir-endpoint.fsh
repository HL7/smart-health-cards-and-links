Profile: ShlSmartOnFhirEndpoint
Parent: Endpoint
Id: shl-smart-on-fhir-endpoint
Title: "SHL SMART on FHIR Endpoint"
Description: "This profile defines constraints for an Endpoint that establishes a consumer-mediated SMART on FHIR connection to the data source"
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
* name ^comment = "Describes the SMART on FHIR endpoint with sufficient detail for the Receiving User to decide whether to connect"
* connectionType 1..1 MS
* connectionType from $shlconnectiontype (extensible)
* connectionType ^binding.description = "SHL endpoint type"
* connectionType.system 1..1 MS
* connectionType.system = $hl7restfulsecurityservice
* connectionType.code 1..1 MS
* connectionType.code = #SMART-on-FHIR
* connectionType ^comment = "Identifies the endpoint as OAuth2 using the SMART-on-FHIR profile"
* address 1..1 MS
* address ^comment = "The URI for the interactive experience"

Instance: shl-smart-on-fhir-endpoint-1
InstanceOf: shl-smart-on-fhir-endpoint
Usage: #example
Description: "Example of an endpoint for establihsing a consumer-mediated SMART on FHIR connection to the data source"
* meta.profile = "http://hl7.org/fhir/uv/smart-health-cards-and-links/StructureDefinition/shl-smart-on-fhir-endpoint"
* status = #active
* name = "Labs-R-Us Application Access"
* address = "https://fhir.example.org"
* connectionType = $hl7restfulsecurityservice#"SMART-on-FHIR"
* payloadType.coding = $hl7payloadtype#"none"
