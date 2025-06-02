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
* files.extension ^label = "Extension (property name beginning with an underscore) defined by downstream implementation guides or specific implementations."
* files.extension ^short = "The specification reserves the name, extension, and will never define an element with that name."
* files.extension ^definition = "Property names beginning with an underscore ('_') are reserved for extensions defined by downstream implementation guides or specific implementations. The specification reserves the name, extension, and will never define an element with that name. "
* files.modifierExtension 0..0
* files.contentType 1..1 string "Nature of the content. Values: application/smart-health-card or application/smart-api-access or application/fhir+json"
* files.location 0..1 url "URL to the content."
* files.embedded 0..1 string "Encrypted file contents. JSON Web Encryption (JWE) string."
* files.lastUpdated 0..1 dateTime "Last time the content was modified. ISO 8601 timestamp."
* files.status 0..1 string "Indicates whether a file may be changed in the future. Values are: finalized|can-change|entered-in-error|no-longer-valid|retracted"
* files.fhirVersion 0..1 string "Version of FHIR content"


