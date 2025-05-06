### Overview

Paper medical records--such as vaccination histories and insurance cards--are easily lost or damaged, are difficult to authenticate, and are often not on-hand when they’re needed. 

SMART Health Cards and Links are FHIR-based standards that address these challenges, enabling individuals to receive their health information and share it with others in a tamper-proof and verifiable digital form. The standards can also be used to share less sensitive information that doesn't need to be verified by the receiver. They provide a digital version of an individual's clinical information that can be kept at the ready and easily shared with others when the need arises--using a QR code, mobile app or web browser.

Together SMART Health Cards and Links provide options that support multiple goals--from keeping a small amount of verifiable medical information close by to authorizing a trusted party to access their entire medical record. They empower individuals with secure, equitable, and privacy-preserving access to their clinical information.

<p></p>

Examples of what an individual can do using these standards include:

- receive proof of critical immunizations on a physical card or in a mobile app and allow others to verify them by scanning the attached QR code
- using a SMART Health Link to transmit their member ID when checking in at their doctor's office
- send an elementary school a link to their child's immunization history, allowing the school to verify the information with the immunization registry and copy in the details if it wishes
- receive a "ticket" to access the results of a lab test when they're ready
- give a provider time-limited or ongoing access to some or all of their medical data, including the ability to search
- scan a prescription bottle to receive the full prescription details.

<p></p>

### IG Organization
The implementation guide is organized into two sections:

* **SMART Health Cards** describes the protocol that allows an individual to keep a copy of their important health records with them in the form of a secure QR code that may be saved digitally or printed on paper. SMART Health Cards build on international open standards and decentralized infrastructure to provide end-user privacy and the ability to work across organizational and jurisdictional boundaries. This section includes:
  * [Health Cards user stories](cards-user-stories.html) 
  * the formal [Health Cards specification](cards-specification.html)
  * the [Issue Verifiable Credential operation](OperationDefinition-patient-i-health-cards-issue.html) for requesting and generating SMART Health Cards
  * a description of [Health Cards credential modeling](cards-credential-modeling.html)
  * [SMART Health Card examples](cards-examples.html)
  * a [Health Cards FAQ](frequently-asked-questions.html)
  * the historical [log of changes to the SMART Health Cards specification](cards-changelog.html) prior to it becoming an HL7 standard

<p></p>

* **SMART Health Links** describes the protocol that enables storage and sharing of more information than can be kept on a single SMART Health Card (using cloud storage) and provides additional sharing options including limited-time access, long-term sharing of data that can evolve over time, and protecting access with a PIN that can be communicated to the recipient out-of-band. This section contains:
  * [Health Links user stories](links-user-stories.html) 
  * the formal [Health Links specification](links-specification.html)
  * [Health Link examples](links-examples.html)

<p></p>

In addition, there is a **[glossary](glossary.html)** of related terms and abbreviations used throughout the guide.

<p></p>

### Referenced Specifications
This implementation guide relies on the following external specifications: 

- [IETF (Internet Engineering Task Force) RFC 7515 - JSON Web Signature (JWS)](https://datatracker.ietf.org/doc/html/rfc7515)
- [IETF RFC 7517 - JSON Web Key (JWK)](https://tools.ietf.org/html/rfc7517)
- [IETF RFC 7517 - JSON Web Key Set (JWK Set)](https://tools.ietf.org/html/rfc7517#section-5)
- [IETF RFC 7518 - JSON Web Algorithms (JWA)](https://datatracker.ietf.org/doc/html/rfc7518)
- [IETF RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [IETF RFC 7638 - JSON Web Key (JWK) Thumbprint](https://datatracker.ietf.org/doc/html/rfc7638)
- [IETF Network Working Group RFC 1951 - DEFLATE Compressed Data Format Specification version 1.3](https://www.ietf.org/rfc/rfc1951.txt)
- [IETF Network Working Group RFC 4648 - Base64 Data Encodings](https://datatracker.ietf.org/doc/html/rfc4648)
- [IETF Network Working Group RFC 4868 - Using HMAC-SHA-256, HMAC-SHA-384, and HMAC-SHA-512 with IPsec](https://datatracker.ietf.org/doc/html/rfc4868)
- [IETF Network Working Group RFC 5280 - X.509 Public Key Infrastructure Certificate and Certificate Revocation List (CRL)](https://datatracker.ietf.org/doc/html/rfc5280)
- [IETF BCP 195 - Transport Layer Security (TLS)](https://www.rfc-editor.org/info/bcp195)
- [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin) 

<p></p>

### Contributing
The Verifiable Clinical Information (VCI) coalition convened the original consensus group that started the work that led to this implementation guide. The Argonaut Project and CARIN Alliance were also key contributors.

<p></p>

### Sponsoring HL7 Workgroup  
[FHIR Infrastructure](https://confluence.hl7.org/display/FHIRI)

<p></p>

### Authors

<table class="grid">
    <tbody>
	  <tr>
		<td>Editor: Josh Mandel</td>
		<td><a href="mailto:jmandel@gmail.com">jmandel@gmail.com</a></td>
	  </tr>
  	  <tr>
		<td>Assisting author: Frank McKinney</td>
		<td><a href="mailto:fm@frankmckinney.com">fm@frankmckinney.com</a></td>
	  </tr>
  	  <tr>
		<td>Publishing lead: Mark Roberts</td>
		<td><a href="mailto:mark.roberts@leavittpartners.com">mark.roberts@leavittpartners.com</a></td>
	  </tr>
	</tbody>
  </table>

<p></p>

### Dependencies
{% include dependency-table.xhtml %}

### Cross Version Analysis
{% include cross-version-analysis.xhtml %}

### Global Profiles
{% include globals-table.xhtml %}

### IP Statements
{% include ip-statements.xhtml %}


<p></p>
<p></p>