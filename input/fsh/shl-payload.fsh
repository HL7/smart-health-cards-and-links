Logical: ShlPayload
Parent: Base
Id: ShlPayload
Title: "SMART Health Link Payload"
Description: "The SMART Health Link Payload object"
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
* ^purpose = "This is a logical model reflecting the structure of a SMART Health Link (SHL) payload. Its intent is to provide a means for understanding SHL payload content."
* url 1..1 url "Manifest URL for the SMART Health Link."
* url ^base.path = "ShlPayload.url"
* url ^base.min = 1
* url ^base.max = "1"
* url ^example[0].label = URL"
* url ^example[0].valueUrl = "https://ehr.example.org/qr/Y9xwkUdtmN9wwoJoN3ffJIhX2UGvCL1JnlPVNL3kDWM/m"
* key 1..1 string "Decryption key"
* key ^definition = "Decryption key for processing files returned in the manifest. 43 characters, consisting of 32 random bytes base64urlencoded."
* key ^base.path = "ShlPayload.key"
* key ^base.min = 1
* key ^base.max = "1"
* key ^example[0].label = "key"
* key ^example[0].valueString = "rxTgYlOaKJPFtcEd0qcceN8wEU4p94SqAwIWQe6uX7Q"
* exp 0..1 string "Expiration time"
* exp ^definition = "Number representing expiration time in Epoch seconds, as a hint to help the SMART Health Links Receiving Application determine if this QR is stale. (Note: epoch times should be parsed into 64-bit numeric types.)"
* exp ^base.path = "ShlPayload.exp"
* exp ^base.min = 0
* exp ^base.max = "1"
* exp ^example[0].label = "representing January 1, 2026 12:00:00 AM"
* exp ^example[0].valueString = "1767225600000"
* flag 0..1 string "Flag indicating link characteristics."
* flag ^definition = "String created by concatenating single-character flags in alphabetical order. L: long-term use. P: requires a Passcode to resolve. U: url resolves to a single encrypted file (not to be used in combination with P)."
* flag ^base.path = "ShlPayload.flag"
* flag ^base.min = 0
* flag ^base.max = "1"
* flag ^example[0].label = "representing 'Long-term use and requires passcode'"
* flag ^example[0].valueString = "LP"
* label 0..1 string "short description of the data behind the SMART Health Link."
* label ^definition = "String no longer than 80 characters that provides a short description of the data behind the SMART Health Link."
* label ^base.path = "ShlPayload.flag"
* label ^base.min = 0
* label ^base.max = "1"
* label ^example[0].label = "label"
* label ^example[0].valueString = "Back-to-school immunizations for Oliver Brown"
* v 0..1 integer "Protocol version"
* v ^definition = "SMART Health Links protocol version."
* v ^base.path = "ShlPayload.v"
* v ^base.min = 0
* v ^base.max = "1"
* v ^example[0].label = "meaning default version"
* v ^example[0].valueInteger = 1
* _extension 0..* string "Extension (property name beginning with an underscore) defined by downstream implementation guides or specific implementations." 
* _extension ^definition = "Property names beginning with an underscore ('_') are reserved for extensions defined by downstream implementation guides or specific implementations. The specification reserves the name, extension, and will never define an element with that name. "



Instance: shl-payload-1
InstanceOf: ShlPayload
Usage: #example
Description: "Example of a SMART Health Link Payload"
* url = "https://ehr.example.org/qr/Y9xwkUdtmN9wwoJoN3ffJIhX2UGvCL1JnlPVNL3kDWM/m"
* flag = "LP"
* key = "rxTgYlOaKJPFtcEd0qcceN8wEU4p94SqAwIWQe6uX7Q"
* exp = "1767225600000"
* v = 1
* label = "Back-to-school immunizations for Oliver Brown"

