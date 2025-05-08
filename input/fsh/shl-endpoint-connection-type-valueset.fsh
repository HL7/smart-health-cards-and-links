ValueSet: ShlEndpointConnectionType
Id: shl-endpoint-connection-type
Title: "SMART Health Links Value Set - Connection Type"
Description: "This value set contains codes indicating the type of endpoint referenced in a SMART Health Links manifest entry"
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #fhir
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-05-06"
* ^publisher = "HL7 International / FHIR Infrastructure"
* ^contact[0].name = "HL7 International - FHIR Infrastructure"
* ^contact[=].telecom.system = #url
* ^contact[=].telecom.value = "http://www.hl7.org/Special/committees/fiwg"
* ^contact[+].name = "Frank McKinney"
* ^contact[=].telecom.system = #email
* ^contact[=].telecom.value = "fm@frankmckinney.com"
* ^jurisdiction = $m49.htm#001 "World"
* ^purpose = "Provides connection types to be used when defining an endpoint in a SMART Health Links manifest entry"
* include codes from system EndpointConnectionType
* $hl7restfulsecurityservice#SMART-on-FHIR "SMART-on-FHIR"
* $tempshlendpointtype#shl-interactive-experience
