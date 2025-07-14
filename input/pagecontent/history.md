Below is a log of changes to the HL7 SMART Health Cards and Links IG. 


_Note: In addition to the following HL7 implementation guide changes, the historical log of changes to the SMART Health Cards specification prior to it becoming an HL7 standard can be found at [Health Cards Change Log](cards-changelog.html)._

<p></p>
<p></p>

#### **Release 1.0.0**

This is the first HL7-balloted release of the SMART Health Cards and SMART Health Links specification--a standard previously maintained by the Verifiable Credential Information coalition (VCI).

As a result of comments submitted during HL7 balloting, several backward-compatible adjustments and additions were made to the SMART Health Links specification, which are listed below.

<p></p>
<p></p>

**SMART Health Link Extensibility**
Added options to [extend certain SMART Health Link artifacts](links-specification.html#extensions).

<p></p>

**Additional SMART Health Link Manifest Properties**
Added the [following optional properties to the SMART Health Links specification](links-specification.html#smart-health-link-manifest-file):
* status - indicates whether files identified in the manifest may change in the future
* lastUpdated - the last time a file was modified
* fhirVersion - version of FHIR content identified in the manifest

<p></p>

**FHIR Logical Models for Structures Described in the SMART Health Links Specification**  

Added FHIR logical models for the following structures to enable validation of the IG's examples and allow downstream derivation.
* [SMART Health Link Payload](StructureDefinition-ShlPayload.html)
* [SMART Health Link Manifest](StructureDefinition-ShlManifest.html)

<p></p>

**Conformance and User-Facing Identification**

Added the [Conformance and User-Facing Identification](links-specification.html#conformance-and-user-facing-identification) section establishing rules and conventions supporting consistent SMART Health Link implementation and user experience.

<p></p>
 
**SMART Health Link Endpoint Profile**
Added a [FHIR profile](StructureDefinition-shl-endpoint.html) for Endpoint usage described in the Health Links Specification.

<p></p>

**Additional Encryption Nonce Requirement**
In the [Encrypting and Decrypting Files](links-specification.html#encrypting-and-decrypting-files) section of the SMART Health Links specification, added a requirement to the SMART Health Links protocol that the SHL Sharing Application SHALL ensure a unique nonce for each encryption operation.

<p></p>

**Additional Client Authentication (for non-"Plain SMART Health Links")**
Included the option for downstream implementation guides that do not wish to conform to the Plain SMART Health Link definition to layer on [additional client authentication or link-signing protocols](links-specification.html#including-additional-client-authentication).

<p></p>
<p></p>