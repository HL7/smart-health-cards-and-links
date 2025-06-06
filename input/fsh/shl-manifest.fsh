Logical: ShlManifest
Parent: Base
Id: ShlManifest
Title: "SMART Health Link Manifest"
Description: "The SMART Health Link Manifest object"
* ^extension.url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension.valueCode = #fhir
* ^version = "1.0.0"
* ^abstract = false
* ^publisher = "HL7 International / FHIR Infrastructure"
* ^contact.name = "HL7 International / FHIR Infrastructure"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fiwg"
* ^jurisdiction.coding.system = "http://unstats.un.org/unsd/methods/m49/m49.htm"
* ^jurisdiction.coding.code = #World
* ^purpose = "This is a logical model reflecting the structure of a SMART Health Link (SHL) manifest. Its intent is to provide a means for understanding mainfest content."
* list 0..1 List "Property containing a List resource with metadata related to contained files."
* list ^base.path = "ShlManifest.list"
* list ^base.min = 0
* list ^base.max = "1"
* files 1..* BackboneElement "Object containing metadata related to one or more contained files."
* files.id 0..0
* files.extension 0..0 
* files.extension ^short = "The SMART Health Links manifest supports extensions to its content through the list property, which holds a FHIR List resource that can be extended using standard FHIR extensions."
* files.modifierExtension 0..0
* files.contentType 1..1 string "Nature of the content. Values: application/smart-health-card or application/smart-api-access or application/fhir+json"
* files.location 0..1 url "URL to the content."
* files.embedded 0..1 string "Encrypted file contents. JSON Web Encryption (JWE) string."
* files.lastUpdated 0..1 dateTime "Last time the content was modified. ISO 8601 timestamp."
* files.status 0..1 string "Indicates whether a file may be changed in the future. Values are: finalized|can-change|no-longer-valid"
* files.fhirVersion 0..1 string "Version of FHIR content"


